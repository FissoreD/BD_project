-- Requetes de consultations
-- 5 requetes impliquant 1 table dont 1 avec un group By et une avec un Order By

-- Les cartes dont la remise est >= � 0.4
SELECT
    oc.nom
FROM
    carte_o oc
WHERE
    oc.remise >= 0.4;

-- Nom et prenom de chaque fournisseur
SELECT
    nom,
    prenom
FROM
    fournisseur_o;

-- Fournisseur qui n'ont plus de factures � payer
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

-- Requ�te avec regroupement sur les jobs
SELECT
    job,
    SUM(salaire)
FROM
    empl_o oe
GROUP BY
    job;

-- Requ�te avec tri utilisant notre m�thode map
SELECT
    oa.pays,
    od.ville
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

    -- mdofication de la quantit� de la ligne d'un ticket
    -- le trigger mets � jour les quantit� sur l'article tout
    -- en v�rifiant qu'il n'y ait pas des probl�me de manquement 
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
    -- toutes les factures 

-- 2 requetes impliquant plus de 2 tables
    -- les cartes utilis�es plus des 5 fois depuis le 22/10/2000
    -- ont une augmentation de 2% de remise
--update carte_o set 
--remise = remise + 0.02
--where 




-- Requetes de suppression 
-- 2 requetes impliquant 1 table
-- 2 requetes impliquant 2 tables
-- 2 requetes impliquant plus de 2 tables

-- Here code