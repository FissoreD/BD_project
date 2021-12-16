SET SERVEROUTPUT ON 
DELETE FROM adresse_o;

DELETE FROM fournisseur_o;

DELETE FROM ticket_o;

DELETE FROM empl_o;

DELETE FROM client_o;

DELETE FROM ligneticket_o;

DELETE FROM article_o;

DELETE FROM carte_o;

INSERT INTO carte_o VALUES (
    'silver',
    0.4,
    listrefclients_t()
);

INSERT INTO carte_o VALUES (
    'gold',
    0.4,
    listrefclients_t()
);

INSERT INTO carte_o VALUES (
    'bronze',
    0.2,
    listrefclients_t()
);

DECLARE
    refart1      REF article_t;
    ad1          REF adresse_t;
    ad2          REF adresse_t;
    article      REF article_t;
    employe1     REF empl_t;
    fourn1       REF fournisseur_t;
    client1      REF client_t;
    fact_recue1  REF facturerecue_t;
    ligne_ticket REF ligneticket_t;
BEGIN
    INSERT INTO adresse_o ad VALUES (
        'France',
        'Biot',
        '06410',
        'Rue Roumanille',
        19000
    ) RETURNING ref(ad) INTO ad1;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Biot',
        '06410',
        'Rue Roumanille',
        17000
    ) RETURNING ref(ad) INTO ad2;

    INSERT INTO fournisseur_o f VALUES (
        1234,
        'First',
        'Boite',
        ad1,
        TO_DATE('01-02-1990', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn1;

    INSERT INTO empl_o e VALUES (
        1111111111111,
        'Dupont',
        'Marcello',
        'Caissier',
        ad2,
        TO_DATE('25-12-1999', 'DD-MM-YYYY'),
        TO_DATE('06-05-2020', 'DD-MM-YYYY'),
        1500,
        NULL
    ) RETURNING ref(e) INTO employe1;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(1, 0, listrefligneticket_t(), 'autre', NULL,
                                                   TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn1, TO_DATE('31-12-2021', 'DD-MM-YYYY'),
                                                   0) ) RETURNING ref(o) INTO fact_recue1;

    INSERT INTO article_o a VALUES (
        0,
        '1111111111111',
        'ASUS X53S',
        450,
        fact_recue1
    ) RETURNING ref(a) INTO article;

    INSERT INTO ligneticket_o lt VALUES (
        1,
        0,
        5,
        article
    ) RETURNING ref(lt) INTO ligne_ticket;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1234
    ) VALUES ( article );

    INSERT INTO TABLE (
        SELECT
            ligneticket
        FROM
            ticket_o
        WHERE
            id = 1
    ) VALUES ( ligne_ticket );

    INSERT INTO client_o c VALUES (
        1,
        'Croesi',
        'Elena',
        ad1,
        TO_DATE('07-07-1999', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client1;

    INSERT INTO ticket_o VALUES ( factureemise_t(2, 1, listrefligneticket_t(), 'autre', employe1,
                                                 TO_DATE('22-12-2021', 'DD-MM-YYYY'), client1, TO_DATE('31-12-2021', 'DD-MM-YYYY'),
                                                 0) );

    INSERT INTO TABLE (
        SELECT
            ligneticket
        FROM
            ticket_o
        WHERE
            id = 2
    ) VALUES ( ligne_ticket );

END;
/

--COMMIT;

DECLARE
    fourn1          fournisseur_t;
    client1         client_t;
    factures_recues setticket_t;
    factures_emises setticket_t;
BEGIN
    SELECT
        value(f)
    INTO fourn1
    FROM
        fournisseur_o f
    WHERE
        siret = 1234;

    factures_recues := fourn1.get_factures_a_payer;
    factures_emises := client_t.get_factures_a_encaisser(1);
    FOR i IN factures_recues.first..factures_recues.last LOOP
        dbms_output.put_line('La facture '
                             || factures_recues(i).id
                             || ' est a payer');
    END LOOP;

    FOR i IN factures_emises.first..factures_emises.last LOOP
        dbms_output.put_line('La facture '
                             || factures_emises(i).id
                             || ' est a encaisser');
    END LOOP;

END;
/
DECLARE
    res1         factureemise_t;
    listarticles listrefligneticket_t;
    resint       NUMBER;
    bool         BOOLEAN;
BEGIN
    SELECT
        TREAT(value(f) AS factureemise_t)
    INTO res1
    FROM
        ticket_o f
    WHERE
        id = 2;
        
    listarticles := ticket_t.getarticles(1);
   bool := res1.is_valid;
    IF true and bool THEN
        dbms_output.put_line('quantite in ticket '
                             || res1.id
                             || ' is valid');
    ELSE
        dbms_output.put_line('quantite in ticket '
                             || res1.id
                             || ' is invalid');
    END IF;

dbms_output.put_line('prix totale de la facture : ' || res1.gettotal);
END;
/
