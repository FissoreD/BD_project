/*
	2.4 LES REQUETES
*/
SET SERVEROUTPUT OFF;

-- Requetes de consultations
-- 5 requetes impliquant 1 table dont 1 avec un group By et une avec un Order By

-- Les cartes dont la remise est >= a 0.2
SELECT
    oc.nom
FROM
    carte_o oc
WHERE
    oc.remise >= 0.2;

-- Articles dont il en reste plus de 3 et qui coutent 50 euros ou moins
SELECT
    nom
FROM
    article_o
WHERE
        quantite > 3
    AND prix_vente <= 50;

-- Nom et prenom de chaque fournisseur
SELECT
    nom,
    prenom
FROM
    fournisseur_o;

    
-- Requete avec regroupement sur les jobs
SELECT
    job,
    SUM(salaire)
FROM
    empl_o oe
GROUP BY
    job;

-- Requete avec tri utilisant notre methode map
SELECT
    oa.pays,
    oa.ville
FROM
    adresse_o oa
WHERE
    oa.numero = 17000
    OR oa.numero = 19000
    OR oa.numero = 12
ORDER BY
    value(oa);
    
-- La date limite de toutes les factures recues
SELECT
    TREAT(value(ot) AS facturerecue_t).datelimite AS datelimite
FROM
    ticket_o ot
WHERE
    value(ot) IS OF ( facturerecue_t );

-- 5 requetes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri

-- Fournisseur dont les factures que nous avons recues ont ete toutes payees
SELECT
    o.siret AS siret
FROM
    fournisseur_o o
    LEFT JOIN (
        SELECT
            deref(TREAT(deref(t.column_value) AS facturerecue_t).fournisseur).siret AS ss
        FROM
            TABLE (
                SELECT
                    b.get_factures_a_payer()
                FROM
                    fournisseur_o b
                WHERE
                    b.siret = 1234
            ) t
    ) ON siret = ss
WHERE
    ss IS NULL;
    
-- Client dont les factures que nous avons emises ont ete toutes payees
SELECT
    o.id AS id
FROM
    client_o o
    LEFT JOIN (
        SELECT
            deref(TREAT(deref(t.column_value) AS factureemise_t).client).id AS id2
        FROM
            TABLE (
                SELECT
                    oc.get_factures_a_encaisser()
                FROM
                    client_o oc
                WHERE
                    oc.id = 2
            ) t
    ) ON id = id2
WHERE
    id2 IS NULL;
    
-- Informations employe emmetteur du ticket 11
SELECT
    ot.id,
    oe.numsecu,
    oe.nom,
    oe.embauche
FROM
    ticket_o ot
    LEFT JOIN empl_o   oe ON oe.numsecu = ot.employeemmetteur.numsecu
WHERE
    ot.id = 11;

-- Liste tickets emis des employes trie par ordre ante-chronologique
SELECT
    oe.nom,
    oe.prenom,
    ot.id,
    ot.dateemission
FROM
    empl_o   oe
    LEFT JOIN ticket_o ot ON oe.numsecu = ot.employeemmetteur.numsecu
WHERE
    ot.id IS NOT NULL
ORDER BY
    ot.dateemission DESC;

-- Pour chaque employe, la quantite total d'argent encaisser depuis son enregistrement
-- (le total des totaux de chacun de ses tickets)
-- on ne considere pas les employes n'ayant emis aucun ticket
SELECT
    oe.numsecu,
    oe.nom,
    SUM(ot2.total) AS total
FROM
         empl_o oe
    INNER JOIN (
        SELECT
            o.employeemmetteur.numsecu n,
            o.gettotal()               total
        FROM
            ticket_o o
    ) ot2 ON oe.numsecu = ot2.n
GROUP BY
    oe.numsecu,
    oe.nom;

-- 5 requetes impliquant 3 tables avec jointures internes dont 1 externe + 1 group by + 1 tri

-- Le nom de l'article vendu avec l'id du ticket dans lequel il a ete enregistre associe a l'employe ayant
-- scanne l'article (l'employe qui a remis le ticket)
SELECT
    oe.nom,
    oe.prenom,
    ticket_id,
    nom_article
FROM
         empl_o oe
    INNER JOIN (
        SELECT
            ot.id                       AS ticket_id,
            ot.employeemmetteur.numsecu AS n,
            ol.article.nom              AS nom_article
        FROM
                 ticket_o ot
            INNER JOIN ligneticket_o ol ON ot.id = ol.parentticket.id
    ) ON oe.numsecu = n;

-- Id des factures emises du client 1 sachant qu'il a la carte gold en utilisant 2 sous-jointures externes
SELECT
    tab1.id_client,
    tab2.nom AS nom_carte,
    tab1.id_facture
FROM
         (
        SELECT
            id_facture,
            oc.id AS id_client
        FROM
            client_o oc
            LEFT JOIN (
                SELECT
                    deref(TREAT(deref(tc.column_value) AS factureemise_t).client).id AS idss,
                    TREAT(deref(tc.column_value) AS factureemise_t).id               AS id_facture
                FROM
                    TABLE (
                        SELECT
                            c.get_factures_a_encaisser()
                        FROM
                            client_o c
                        WHERE
                            c.id = 1
                    ) tc
            ) ON id = idss
        WHERE
            idss IS NOT NULL
    ) tab1
    INNER JOIN (
        SELECT
            id_client2,
            o.nom AS nom
        FROM
            carte_o o
            LEFT JOIN (
                SELECT
                    TREAT(deref(t.column_value) AS client_t).carte.nom AS ssnom,
                    TREAT(deref(t.column_value) AS client_t).id        AS id_client2
                FROM
                    TABLE (
                        SELECT
                            car.clients
                        FROM
                            carte_o car
                        WHERE
                            car.nom = 'bronze'
                    ) t
            ) ON nom = ssnom
        WHERE
            ssnom IS NOT NULL
    ) tab2 ON tab1.id_client = tab2.id_client2;

-- Le nom de l'article associe au numero de securite social de celui qui l'a vendu et ce trie par nom d'article
SELECT
    oe.numsecu,
    nom_article
FROM
         empl_o oe
    INNER JOIN (
        SELECT
            ot.employeemmetteur.numsecu AS n,
            ol.article.nom              AS nom_article
        FROM
                 ticket_o ot
            INNER JOIN ligneticket_o ol ON ot.id = ol.parentticket.id
    ) ON oe.numsecu = n
ORDER BY
    nom_article;

-- Pour chaque employe, on calcule la moyenne (en pourcentage) de la proportion du cout d'un article dans le total du ticket
-- dans lequel l'article est (on ne consid?re pas les employes n'ayant emis aucun ticket)
SELECT
    oe.numsecu,
    oe.nom,
    oe.prenom,
    AVG(round(prix / total * 100, 2)) AS mean_total_percent_proportion
FROM
         empl_o oe
    INNER JOIN (
        SELECT
            ot.employeemmetteur.numsecu AS n,
            ol.article.prix_vente       AS prix,
            ot.gettotal()               AS total,
            ol.article.nom              AS nom_article
        FROM
                 ticket_o ot
            INNER JOIN ligneticket_o ol ON ot.id = ol.parentticket.id
    ) ON oe.numsecu = n
GROUP BY
    oe.numsecu,
    oe.nom,
    oe.prenom
ORDER BY
    mean_total_percent_proportion DESC;
    
-- Pour chaque employe, on calcule le benefice brut total ? partir des tickets
SELECT
    oe.numsecu,
    oe.nom,
    oe.prenom,
    nvl(SUM(prix - prix_fournisseur), 0) AS benefice_brut
FROM
    empl_o oe
    LEFT JOIN (
        SELECT
            ot.employeemmetteur.numsecu AS n,
            ol.article.prix_vente       AS prix,
            ol.article.prix_achat       AS prix_fournisseur,
            ol.article.nom              AS nom_article
        FROM
                 ticket_o ot
            INNER JOIN ligneticket_o ol ON ot.id = ol.parentticket.id
    ) ON oe.numsecu = n
GROUP BY
    oe.numsecu,
    oe.nom,
    oe.prenom
ORDER BY
    benefice_brut DESC;
    
-- Requetes de mise a jour
-- 2 requetes impliquant 1 table

    -- mdofication de la quantite de la ligne d'un ticket
    -- le trigger mets a jour les quantite sur l'article tout
    -- en verifiant qu'il n'y ait pas des probleme de manquement 
    -- dans le stock
UPDATE ligneticket_o
SET
    quantite = 5
WHERE
    numeroligne = 2;
    
    -- les employes qui travaillent depuis le 15/10/2000 recoivent
    -- un augmentation de salaire
UPDATE empl_o
SET
    salaire = salaire + 1000
WHERE
    embauche > TO_DATE('15-10-2000', 'DD-MM-YYYY');

-- 2 requetes impliquant 2 tables

    -- les employes qui n'habitent pas a Nice recoivent
    -- 10 euro de salaire en plus pour payer l'essance
UPDATE empl_o
SET
    salaire = salaire + 10
WHERE
    deref(adresse).ville != 'Nice';

    -- les employes qui ont emis plus de 500 euro de ticket,
    -- recoivent un bonus de 50 euro dans leur salaire
UPDATE empl_o
SET
    salaire = salaire + 50
WHERE
    numsecu IN (
        SELECT
            deref(employeemmetteur).numsecu
        FROM
            ticket_o t
        WHERE
            t.gettotal() > 500
    );

-- 2 requetes impliquant plus de 2 tables

    -- tous les articles dans le catalogue du fournisseur 1234
    -- subissent 2% d'augmentation de prix
UPDATE article_o art
SET
    art.prix_vente = art.prix_vente * 1.02
WHERE
    codebarre IN (
        SELECT
            lre.column_value.codebarre
        FROM
            TABLE (
                SELECT
                    f.get_catalogue()
                FROM
                    fournisseur_o f
                WHERE
                    siret = 1234
            ) lre
    );
    
    -- tous les articles presents dans la facture d'achat 1
    -- subissent une reduction du prix de vente du 5%
UPDATE article_o art
SET
    art.prix_vente = art.prix_vente * 0.95
WHERE
    codebarre IN (
        SELECT
            lre.column_value.article.codebarre
        FROM
            TABLE (
                SELECT
                    ligneticket
                FROM
                    ticket_o
                WHERE
                    id = 1
            ) lre
    );
    


-- Requetes de suppression 
-- 2 requetes impliquant 1 table

-- ici on sait que le client 7 n'a ni de carte ni de facture
DELETE FROM client_o
WHERE
    id = 7;

-- ici on sait que ces cartes ne sont affectees a aucun client
DELETE FROM carte_o
WHERE
    remise > 0.35;

-- 2 requetes impliquant 2 tables

-- on supprime un carte et supprime le pointeur des clients vers celle-ci
DELETE FROM carte_o
WHERE
    nom = 'gold';

UPDATE client_o clt
SET
    clt.carte = NULL
WHERE
    carte IS DANGLING;

-- 2 requetes impliquant plus de 2 tables

-- on supprime un ticket (pas une facture, vieux de plus de 10 ans)
-- -> on supprime ses ligneticket
-- -> on met ?? jour ligne_ticket_avec_this dans les articles concern??s par ce ticket
-- -> on met ?? jour ticket_emis dans l'employe concerne par ce ticket


DECLARE
    ref_ticket      REF ticket_t;
    article         article_t;
    ref_ligneticket REF ligneticket_t;
    ref_l_tick      setligneticket_t;
    employe         empl_t;
    ticket_id       NUMBER := 17;
BEGIN
    --on met a jour ticket_emis dans l'employe concerne par ce ticket
    SELECT
        deref(t.employeemmetteur),
        ref(t)
    INTO
        employe,
        ref_ticket
    FROM
        ticket_o t
    WHERE
        t.id = ticket_id;

    employe.delete_ticket_emis(ref_ticket);
    
    --on supprime le ticket
    DELETE FROM ticket_o
    WHERE
        id = 17;

    --on regroupe les ligneticket n'ayant plus de ticket parent
    SELECT
        CAST(COLLECT(value(l)) AS setligneticket_t)
    INTO ref_l_tick
    FROM
        ligneticket_o l
    WHERE
        parentticket IS DANGLING;

    --on it?re sur chacune des ligneticket qui n'ont plus de ticket parent
    FOR i IN ref_l_tick.first..ref_l_tick.last LOOP
        --on supprime de l'article la reference vers cette ligneticket
        SELECT
            deref(l.article),
            ref(l)
        INTO
            article,
            ref_ligneticket
        FROM
            ligneticket_o l
        WHERE
            value(l) = ref_l_tick(i);

        article.delete_ligne_ticket(ref_ligneticket);

        --on supprime la lignetick
        DELETE FROM ligneticket_o l
        WHERE
            value(l) = ref_l_tick(i);

    END LOOP;

END;
/

-- on supprime le client 1 qui a une carte et sur lequel on a emis une facture
-- 1. on met a jour donc listrefclients_t dans la carte du client 1
-- 2. on supprime les factures emises sur ce client
-- (Attention au trigger delete_facture_checker car on ne peut pas supprimer des factures de moins de 10 ans)
DECLARE
    ref_client REF client_t;
    carte      carte_t;
    ref_fact_e setfactureemise_t;
    client_id  NUMBER := 1;
BEGIN
    SELECT
        deref(v.carte),
        ref(v)
    INTO
        carte,
        ref_client
    FROM
        client_o v
    WHERE
        v.id = client_id;

    carte.deleteclient(ref_client);
    DELETE FROM client_o c
    WHERE
        id = 1;

    SELECT
        CAST(COLLECT(TREAT(value(t) AS factureemise_t)) AS setfactureemise_t)
    INTO ref_fact_e
    FROM
        ticket_o t
    WHERE
        TREAT(value(t) AS factureemise_t).client IS
dangling;

FOR i IN ref_fact_e.first..ref_fact_e.last LOOP
    DELETE FROM ticket_o t
    WHERE
        value(t) = ref_fact_e(i);

END LOOP;

end;
/

ROLLBACK;