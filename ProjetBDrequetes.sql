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

-- Fournisseur qui n'ont plus de factures a payer
SELECT
    *
FROM
    fournisseur_o of
WHERE
    (
        SELECT
            COUNT(*)
        FROM
            of.get_factures_a_payer()
    ) != 0;

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
    -- subissent 2% d'augementation de prix
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
-- 2 requetes impliquant 2 tables
-- 2 requetes impliquant plus de 2 tables

-- Here code