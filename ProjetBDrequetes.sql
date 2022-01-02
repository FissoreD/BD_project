-- Requetes de consultations
-- 5 requetes impliquant 1 table dont 1 avec un group By et une avec un Order By

-- Les cartes dont la remise est >= a 0.2
SELECT
    oc.nom
FROM
    carte_o oc
WHERE
    oc.remise >= 0.2;

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
ORDER BY
    value(oa);


-- 5 requetes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri
--SELECT *
--FROM
--         empl_o oe
--    INNER JOIN adresse_o oa ON oe.adresse = oa;

-- 5 requetes impliquant plus de 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri

-- Fournisseur dont les factures que nous avons recues ont ete toutes payees
SELECT
    o.siret AS siret
FROM
    fournisseur_o o
    LEFT JOIN TABLE (
        SELECT
            b.get_factures_a_payer()
        FROM
            fournisseur_o b
        WHERE
            b.siret = o.siret
    )             t ON o.siret = TREAT(value(t) AS facturerecue_t).fournisseur.siret
WHERE
    TREAT(value(t) AS facturerecue_t).fournisseur.siret IS NULL;

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

    -- les employ�s qui n'habitent pas � Nice recoivent
    -- 10 euro de salaire en plus pour payer l'essance
UPDATE empl_o
SET
    salaire = salaire + 10
WHERE
    deref(adresse).ville != 'Nice';

    -- les employ�s qui ont �mis plus de 500 euro de ticket,
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
                    catalogue
                FROM
                    fournisseur_o
                WHERE
                    siret = 1234
            ) lre
    );
    
    -- tous les articles pr�sents dans la facture d'achat 1
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
WHERE id = 7;

-- ici on sait que ces cartes ne sont affectees a aucun client
DELETE FROM carte_o
WHERE remise > 0.35;

-- 2 requetes impliquant 2 tables
-- 2 requetes impliquant plus de 2 tables

-- on supprime le client 1 qui a une carte et sur lequel on a emis une facture
-- 1. on met � jour donc listrefclients_t dans la carte du client 1
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
        TREAT(value(t) AS factureemise_t).client IS DANGLING;

    FOR i IN ref_fact_e.first..ref_fact_e.last LOOP
        DELETE FROM ticket_o t
        WHERE
            value(t) = ref_fact_e(i);
    END LOOP;

END;
/
-- Here code