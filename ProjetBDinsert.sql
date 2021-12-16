SET SERVEROUTPUT ON;

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

SELECT
    *
FROM
    carte_o oc
ORDER BY
    value(oc) DESC;

DELETE FROM empl_o;

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
        12345,
        'First',
        'Boite',
        ad1,
        TO_DATE('01-02-1990', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn1;

    INSERT INTO empl_o e VALUES (
        1111111111112,
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
/*
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

    INSERT INTO ticket_o VALUES (
    factureemise_t(
        1,
        1,
        listrefligneticket_t(),
        'autre',
        employe1,
        TO_DATE('22-12-2021', 'DD-MM-YYYY'),
        client1,
        TO_DATE('31-12-2021', 'DD-MM-YYYY'),
        0)
    );

    INSERT INTO TABLE (
        SELECT
            ligneticket
        FROM
            ticket_o
        WHERE
            id = 1
    ) VALUES ( ligne_ticket );
*/
END;
/

DESC ticket_o
/

DECLARE
    fourn1  fournisseur_t;
    client1 client_t;
    res     setfacturerecue_t;
    res1    setfactureemise_t;
BEGIN
    SELECT
        value(f)
    INTO fourn1
    FROM
        fournisseur_o f
    WHERE
        siret = 1234;

    res := fourn1.get_factures_a_payer;
    res1 := client_t.get_factures_a_encaisser(1);
    FOR i IN res.first..res.last LOOP
        dbms_output.put_line('Facture � payer : ' || res(i).id);
    END LOOP;

    FOR i IN res1.first..res1.last LOOP
        dbms_output.put_line('Factures � encaisser : ' || res1(i).id);
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
        value(f)
    INTO res1
    FROM
        ticket_o f
    WHERE
        id = 1;

    listarticles := ticket_t.getarticles(1);
    bool := res1.is_valid;
    IF bool THEN
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

SELECT
    t.column_value.article.prix
FROM
    TABLE (
        SELECT
            ligneticket
        FROM
            ticket_o f
        WHERE
            id = 1
    ) t;