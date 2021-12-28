-- Requetes de consultations
-- 5 requetes impliquant 1 table dont 1 avec un group By et une avec un Order By
-- 5 requetes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri
-- 5 requetes impliquant plus de 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri

-- Here code

-- Requetes de mise a jour
-- 2 requetes impliquant 1 table

    -- mdofication de la quantité de la ligne d'un ticket
    -- le trigger mets à jour les quantité sur l'article tout
    -- en vérifiant qu'il n'y ait pas des problème de manquement 
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
    -- les cartes utilisées plus des 5 fois depuis le 22/10/2000
    -- ont une augmentation de 2% de remise
--update carte_o set 
--remise = remise + 0.02
--where 




-- Requetes de suppression 
-- 2 requetes impliquant 1 table
-- 2 requetes impliquant 2 tables
-- 2 requetes impliquant plus de 2 tables

-- Here code