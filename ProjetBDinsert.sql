SET SERVEROUTPUT ON

DELETE FROM adresse_o;

DELETE FROM fournisseur_o;

DELETE FROM ticket_o;

DELETE FROM empl_o;

DELETE FROM client_o;

DELETE FROM ligneticket_o;

DELETE FROM article_o;

DELETE FROM carte_o;

DECLARE
    ad1             REF adresse_t;
    ad2             REF adresse_t;
    ad3             REF adresse_t;
    ad4             REF adresse_t;
    ad5             REF adresse_t;
    ad6             REF adresse_t;
    ad7             REF adresse_t;
    ad8             REF adresse_t;
    ad9             REF adresse_t;
    ad10            REF adresse_t;
    ad11            REF adresse_t;
    ad12            REF adresse_t;
    ad13            REF adresse_t;
    ad14            REF adresse_t;
    ad15            REF adresse_t;
    ad16            REF adresse_t;
    ad17            REF adresse_t;
    ad18            REF adresse_t;
    ad19            REF adresse_t;
    ad20            REF adresse_t;
    article1        REF article_t;
    article2        REF article_t;
    article3        REF article_t;
    article4        REF article_t;
    article5        REF article_t;
    article6        REF article_t;
    article7        REF article_t;
    article8        REF article_t;
    article9        REF article_t;
    article10       REF article_t;
    article11       REF article_t;
    article12       REF article_t;
    article13       REF article_t;
    article14       REF article_t;
    article15       REF article_t;
    employe1        REF empl_t;
    employe2        REF empl_t;
    employe3        REF empl_t;
    employe4        REF empl_t;
    employe5        REF empl_t;
    employe6        REF empl_t;
    fourn1          REF fournisseur_t;
    fourn2          REF fournisseur_t;
    fourn3          REF fournisseur_t;
    fourn4          REF fournisseur_t;
    fourn5          REF fournisseur_t;
    client1         REF client_t;
    client2         REF client_t;
    client3         REF client_t;
    client4         REF client_t;
    client5         REF client_t;
    client6         REF client_t;
    client7         REF client_t;
    client8         REF client_t;
    client9         REF client_t;
    client10        REF client_t;
    fact_recue1ref  REF facturerecue_t;
    fact_recue2ref  REF facturerecue_t;
    fact_recue3ref  REF facturerecue_t;
    fact_recue4ref  REF facturerecue_t;
    fact_recue5ref  REF facturerecue_t;
    fact_recue6ref  REF facturerecue_t;
    fact_recue7ref  REF facturerecue_t;
    fact_recue8ref  REF facturerecue_t;
    fact_recue9ref  REF facturerecue_t;
    fact_recue10ref REF facturerecue_t;
    fact_emise1ref  REF factureemise_t;
    fact_emise2ref  REF factureemise_t;
    fact_emise3ref  REF factureemise_t;
    fact_emise4ref  REF factureemise_t;
    fact_emise5ref  REF factureemise_t;
    fact_emise6ref  REF factureemise_t;
    fact_emise7ref  REF factureemise_t;
    fact_emise8ref  REF factureemise_t;
    fact_emise9ref  REF factureemise_t;
    fact_emise10ref REF factureemise_t;
    fact_recue1     facturerecue_t;
    fact_recue2     facturerecue_t;
    fact_recue3     facturerecue_t;
    fact_recue4     facturerecue_t;
    fact_recue5     facturerecue_t;
    fact_recue6     facturerecue_t;
    fact_recue7     facturerecue_t;
    fact_recue8     facturerecue_t;
    fact_recue9     facturerecue_t;
    fact_recue10    facturerecue_t;
    fact_emise1     factureemise_t;
    fact_emise2     factureemise_t;
    fact_emise3     factureemise_t;
    fact_emise4     factureemise_t;
    fact_emise5     factureemise_t;
    fact_emise6     factureemise_t;
    fact_emise7     factureemise_t;
    fact_emise8     factureemise_t;
    fact_emise9     factureemise_t;
    fact_emise10    factureemise_t;
    ligne_ticket1   REF ligneticket_t;
    ligne_ticket2   REF ligneticket_t;
    ligne_ticket3   REF ligneticket_t;
    ligne_ticket4   REF ligneticket_t;
    ligne_ticket5   REF ligneticket_t;
    ligne_ticket6   REF ligneticket_t;
    ligne_ticket7   REF ligneticket_t;
    ligne_ticket8   REF ligneticket_t;
    ligne_ticket9   REF ligneticket_t;
    ligne_ticket10  REF ligneticket_t;
    ligne_ticket11  REF ligneticket_t;
    ligne_ticket12  REF ligneticket_t;
    ligne_ticket13  REF ligneticket_t;
    ligne_ticket14  REF ligneticket_t;
    ligne_ticket15  REF ligneticket_t;
    ligne_ticket16  REF ligneticket_t;
    ligne_ticket17  REF ligneticket_t;
    ligne_ticket18  REF ligneticket_t;
    ligne_ticket19  REF ligneticket_t;
    ligne_ticket20  REF ligneticket_t;
    ligne_ticket21  REF ligneticket_t;
    ligne_ticket22  REF ligneticket_t;
    ligne_ticket23  REF ligneticket_t;
    ligne_ticket24  REF ligneticket_t;
    ligne_ticket25  REF ligneticket_t;
    ligne_ticket26  REF ligneticket_t;
    ligne_ticket27  REF ligneticket_t;
    ligne_ticket28  REF ligneticket_t;
    carte1          REF carte_t;
    carte2          REF carte_t;
    carte3          REF carte_t;
    carte4          REF carte_t;
    carte5          REF carte_t;
BEGIN
    INSERT INTO carte_o c VALUES (
        'bronze',
        0.1,
        listrefclients_t()
    ) RETURNING ref(c) INTO carte1;

    INSERT INTO carte_o c VALUES (
        'silver',
        0.15,
        listrefclients_t()
    ) RETURNING ref(c) INTO carte2;

    INSERT INTO carte_o c VALUES (
        'gold',
        0.20,
        listrefclients_t()
    ) RETURNING ref(c) INTO carte3;

    INSERT INTO carte_o c VALUES (
        'platinum',
        0.25,
        listrefclients_t()
    ) RETURNING ref(c) INTO carte4;

    INSERT INTO carte_o c VALUES (
        'diamond',
        0.30,
        listrefclients_t()
    ) RETURNING ref(c) INTO carte5;

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

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Nice',
        '06100',
        'Avenue Jean Medecin',
        12
    ) RETURNING ref(ad) INTO ad3;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Nice',
        '06100',
        'Valrose',
        15
    ) RETURNING ref(ad) INTO ad4;

    INSERT INTO adresse_o ad VALUES (
        'Italy',
        'Ventimiglia',
        '18039',
        'Bosco dei Bormanni',
        17
    ) RETURNING ref(ad) INTO ad5;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Paris',
        '75000',
        'Champs Elyses',
        1
    ) RETURNING ref(ad) INTO ad6;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Perpignan',
        '66100',
        'Rue Imaginaire',
        45
    ) RETURNING ref(ad) INTO ad7;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Valbonne',
        '06560',
        'Chemin des Collines',
        17
    ) RETURNING ref(ad) INTO ad8;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Cagnes sur Mer',
        '06800',
        'Avenue des Acacias',
        12
    ) RETURNING ref(ad) INTO ad9;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Cagnes sur Mer',
        '06800',
        'Avenue des Acacias',
        13
    ) RETURNING ref(ad) INTO ad10;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Biot',
        '06410',
        'Rue Roumanille',
        20500
    ) RETURNING ref(ad) INTO ad11;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Biot',
        '06410',
        'Rue Roumanille',
        10203
    ) RETURNING ref(ad) INTO ad12;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Nice',
        '06100',
        'Avenue Jean Medecin',
        150
    ) RETURNING ref(ad) INTO ad13;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Nice',
        '06100',
        'Valrose',
        1
    ) RETURNING ref(ad) INTO ad14;

    INSERT INTO adresse_o ad VALUES (
        'Italy',
        'Ventimiglia',
        '18039',
        'Bosco dei Bormanni',
        5
    ) RETURNING ref(ad) INTO ad15;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Paris',
        '75000',
        'Champs Elysés',
        103
    ) RETURNING ref(ad) INTO ad16;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Perpignan',
        '66100',
        'Rue Imaginaire',
        10
    ) RETURNING ref(ad) INTO ad17;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Valbonne',
        '06560',
        'Chemin des Collines',
        23
    ) RETURNING ref(ad) INTO ad18;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Cagnes sur Mer',
        '06800',
        'Avenue des Acacias',
        56
    ) RETURNING ref(ad) INTO ad19;

    INSERT INTO adresse_o ad VALUES (
        'France',
        'Cagnes sur Mer',
        '06800',
        'Avenue des Acacias',
        2
    ) RETURNING ref(ad) INTO ad20;

    INSERT INTO fournisseur_o f VALUES (
        1234,
        'First',
        'Boite',
        ad1,
        TO_DATE('01-02-1990', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn1;

    INSERT INTO fournisseur_o f VALUES (
        5050,
        'Bouchon',
        'Albert',
        ad2,
        TO_DATE('01-02-1970', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn2;

    INSERT INTO fournisseur_o f VALUES (
        4567,
        'Bonaparte',
        'Napoleon',
        ad3,
        TO_DATE('01-02-1983', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn3;

    INSERT INTO fournisseur_o f VALUES (
        1919,
        'Clement',
        'Paul',
        ad4,
        TO_DATE('21-10-1980', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn4;

    INSERT INTO fournisseur_o f VALUES (
        9874,
        'Combe',
        'Sylvie',
        ad5,
        TO_DATE('01-02-1975', 'DD-MM-YYYY'),
        listrefarticles_t()
    ) RETURNING ref(f) INTO fourn5;

    INSERT INTO empl_o e VALUES (
        111111111111,
        'Dupont',
        'Marcello',
        'Caissier',
        ad6,
        TO_DATE('25-12-1999', 'DD-MM-YYYY'),
        TO_DATE('06-05-2020', 'DD-MM-YYYY'),
        1500,
        NULL
    ) RETURNING ref(e) INTO employe1;

    INSERT INTO empl_o e VALUES (
        1111111111112,
        'Dupont',
        'Jean',
        'Caissier',
        ad7,
        TO_DATE('25-12-1999', 'DD-MM-YYYY'),
        TO_DATE('06-05-2020', 'DD-MM-YYYY'),
        1600,
        NULL
    ) RETURNING ref(e) INTO employe2;

    INSERT INTO empl_o e VALUES (
        1111113111111,
        'Peretti',
        'Antoine',
        'Polyvalent',
        ad8,
        TO_DATE('12-01-1970', 'DD-MM-YYYY'),
        TO_DATE('30-10-2015', 'DD-MM-YYYY'),
        2000,
        NULL
    ) RETURNING ref(e) INTO employe3;

    INSERT INTO empl_o e VALUES (
        1111111114111,
        'Mecene',
        'Julie',
        'Polyvalent',
        ad9,
        TO_DATE('25-12-1996', 'DD-MM-YYYY'),
        TO_DATE('15-03-2018', 'DD-MM-YYYY'),
        2000,
        NULL
    ) RETURNING ref(e) INTO employe4;

    INSERT INTO empl_o e VALUES (
        1115111111111,
        'Pilouche',
        'Daniel',
        'Responsable',
        ad10,
        TO_DATE('25-12-1956', 'DD-MM-YYYY'),
        TO_DATE('06-05-1980', 'DD-MM-YYYY'),
        3200,
        NULL
    ) RETURNING ref(e) INTO employe5;

    INSERT INTO empl_o e VALUES (
        1111111116111,
        'Peretti',
        'Cathie',
        'Directeur',
        ad11,
        TO_DATE('25-12-1980', 'DD-MM-YYYY'),
        TO_DATE('06-05-2009', 'DD-MM-YYYY'),
        4200,
        NULL
    ) RETURNING ref(e) INTO employe6;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(1, 0, listrefligneticket_t(), 'autre', NULL, carte1,
                                                   TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn1, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue1ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(2, 0, listrefligneticket_t(), 'espece', NULL, carte2,
                                                   TO_DATE('20-12-2021', 'DD-MM-YYYY'), fourn1, TO_DATE('31-12-2022',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue2ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(3, 0, listrefligneticket_t(), 'espece', NULL, NULL,
                                                   TO_DATE('30-12-2021', 'DD-MM-YYYY'), fourn2, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue3ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(4, 0, listrefligneticket_t(), 'cb', NULL, NULL,
                                                   TO_DATE('15-12-2020', 'DD-MM-YYYY'), fourn3, TO_DATE('27-02-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue4ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(5, 0, listrefligneticket_t(), 'cb', NULL, NULL,
                                                   TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn3, TO_DATE('31-12-2025',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue5ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(6, 0, listrefligneticket_t(), 'cb', NULL, carte3,
                                                   TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn3, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue6ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(7, 0, listrefligneticket_t(), 'cheque', NULL, carte4,
                                                   TO_DATE('15-10-2021', 'DD-MM-YYYY'), fourn4, TO_DATE('30-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue7ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(8, 0, listrefligneticket_t(), 'cheque', NULL, carte2,
                                                   TO_DATE('10-08-2021', 'DD-MM-YYYY'), fourn4, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue8ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(9, 0, listrefligneticket_t(), 'cheque', NULL, NULL,
                                                   TO_DATE('30-12-2021', 'DD-MM-YYYY'), fourn5, TO_DATE('31-12-2023',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue9ref;

    INSERT INTO ticket_o o VALUES ( facturerecue_t(10, 0, listrefligneticket_t(), 'cheque', NULL, NULL,
                                                   TO_DATE('25-12-2018', 'DD-MM-YYYY'), fourn5, TO_DATE('31-12-2020',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue10ref;

    INSERT INTO article_o a VALUES (
        5,
        '1111111111111',
        'ASUS X53S',
        380,
        450,
        fact_recue1ref
    ) RETURNING ref(a) INTO article1;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111112',
        'PREDATOR HELIOS 300',
        800,
        999,
        fact_recue1ref
    ) RETURNING ref(a) INTO article2;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111113',
        'LOGITECH MOUSE GAMING',
        30,
        50,
        fact_recue1ref
    ) RETURNING ref(a) INTO article3;

    INSERT INTO article_o a VALUES (
        50,
        '1111111111114',
        'house protection ordinateur',
        5,
        8,
        fact_recue2ref
    ) RETURNING ref(a) INTO article4;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111115',
        'USB cable',
        2,
        3,
        fact_recue3ref
    ) RETURNING ref(a) INTO article5;

    INSERT INTO article_o a VALUES (
        100,
        '1111111111116',
        'tapis de souris',
        5,
        10,
        fact_recue4ref
    ) RETURNING ref(a) INTO article6;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111117',
        'casque gaming',
        70,
        100,
        fact_recue5ref
    ) RETURNING ref(a) INTO article7;

    INSERT INTO article_o a VALUES (
        5,
        '1111111111118',
        'appareil photo',
        400,
        480,
        fact_recue6ref
    ) RETURNING ref(a) INTO article8;

    INSERT INTO article_o a VALUES (
        3,
        '1111111111119',
        'Macbook',
        700,
        800,
        fact_recue7ref
    ) RETURNING ref(a) INTO article9;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111120',
        'tablette samsung',
        300,
        400,
        fact_recue8ref
    ) RETURNING ref(a) INTO article10;

    INSERT INTO article_o a VALUES (
        8,
        '1111111111121',
        'tablette apple',
        400,
        500,
        fact_recue9ref
    ) RETURNING ref(a) INTO article11;

    INSERT INTO article_o a VALUES (
        40,
        '1111111111122',
        'telephone portable samsung',
        220,
        250,
        fact_recue10ref
    ) RETURNING ref(a) INTO article12;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111123',
        'iphone',
        450,
        500,
        fact_recue10ref
    ) RETURNING ref(a) INTO article13;

    INSERT INTO article_o a VALUES (
        30,
        '1111111111124',
        'telephone portable huawei',
        220,
        250,
        fact_recue10ref
    ) RETURNING ref(a) INTO article14;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111125',
        'imprimante hp',
        80,
        120,
        fact_recue10ref
    ) RETURNING ref(a) INTO article15;

    INSERT INTO ligneticket_o lt VALUES (
        1,
        5,
        article1,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket1;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1234
    ) VALUES ( article1 );

    INSERT INTO ligneticket_o lt VALUES (
        2,
        10,
        article2,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket2;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1234
    ) VALUES ( article2 );

    INSERT INTO ligneticket_o lt VALUES (
        3,
        20,
        article3,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket3;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1234
    ) VALUES ( article3 );

    SELECT
        deref(fact_recue1ref)
    INTO fact_recue1
    FROM
        dual;

    fact_recue1.addligneticket(ligne_ticket1);
    fact_recue1.addligneticket(ligne_ticket2);
    fact_recue1.addligneticket(ligne_ticket3);
    INSERT INTO ligneticket_o lt VALUES (
        4,
        50,
        article4,
        fact_recue2ref
    ) RETURNING ref(lt) INTO ligne_ticket4;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1234
    ) VALUES ( article4 );

    SELECT
        deref(fact_recue2ref)
    INTO fact_recue2
    FROM
        dual;

    fact_recue2.addligneticket(ligne_ticket4);
    INSERT INTO ligneticket_o lt VALUES (
        5,
        20,
        article5,
        fact_recue3ref
    ) RETURNING ref(lt) INTO ligne_ticket5;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 5050
    ) VALUES ( article5 );

    SELECT
        deref(fact_recue3ref)
    INTO fact_recue3
    FROM
        dual;

    fact_recue3.addligneticket(ligne_ticket5);
    INSERT INTO ligneticket_o lt VALUES (
        6,
        5,
        article6,
        fact_recue4ref
    ) RETURNING ref(lt) INTO ligne_ticket6;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 4567
    ) VALUES ( article6 );

    SELECT
        deref(fact_recue4ref)
    INTO fact_recue4
    FROM
        dual;

    fact_recue4.addligneticket(ligne_ticket6);
    INSERT INTO ligneticket_o lt VALUES (
        7,
        5,
        article7,
        fact_recue5ref
    ) RETURNING ref(lt) INTO ligne_ticket7;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 4567
    ) VALUES ( article7 );

    SELECT
        deref(fact_recue5ref)
    INTO fact_recue5
    FROM
        dual;

    fact_recue5.addligneticket(ligne_ticket7);
    INSERT INTO ligneticket_o lt VALUES (
        8,
        5,
        article8,
        fact_recue6ref
    ) RETURNING ref(lt) INTO ligne_ticket8;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 4567
    ) VALUES ( article8 );

    SELECT
        deref(fact_recue6ref)
    INTO fact_recue6
    FROM
        dual;

    fact_recue6.addligneticket(ligne_ticket8);
    INSERT INTO ligneticket_o lt VALUES (
        9,
        5,
        article9,
        fact_recue7ref
    ) RETURNING ref(lt) INTO ligne_ticket9;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1919
    ) VALUES ( article9 );

    SELECT
        deref(fact_recue7ref)
    INTO fact_recue7
    FROM
        dual;

    fact_recue7.addligneticket(ligne_ticket9);
    INSERT INTO ligneticket_o lt VALUES (
        10,
        5,
        article10,
        fact_recue8ref
    ) RETURNING ref(lt) INTO ligne_ticket10;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 1919
    ) VALUES ( article10 );

    SELECT
        deref(fact_recue8ref)
    INTO fact_recue8
    FROM
        dual;

    fact_recue8.addligneticket(ligne_ticket10);
    INSERT INTO ligneticket_o lt VALUES (
        11,
        5,
        article11,
        fact_recue9ref
    ) RETURNING ref(lt) INTO ligne_ticket11;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 9874
    ) VALUES ( article11 );

    SELECT
        deref(fact_recue9ref)
    INTO fact_recue9
    FROM
        dual;

    fact_recue9.addligneticket(ligne_ticket11);
    INSERT INTO ligneticket_o lt VALUES (
        12,
        5,
        article12,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket12;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 9874
    ) VALUES ( article12 );

    INSERT INTO ligneticket_o lt VALUES (
        13,
        5,
        article13,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket13;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 9874
    ) VALUES ( article13 );

    INSERT INTO ligneticket_o lt VALUES (
        14,
        5,
        article14,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket14;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 9874
    ) VALUES ( article14 );

    INSERT INTO ligneticket_o lt VALUES (
        15,
        5,
        article15,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket15;

    INSERT INTO TABLE (
        SELECT
            o.catalogue
        FROM
            fournisseur_o o
        WHERE
            siret = 9874
    ) VALUES ( article15 );

    SELECT
        deref(fact_recue10ref)
    INTO fact_recue10
    FROM
        dual;

    fact_recue10.addligneticket(ligne_ticket12);
    fact_recue10.addligneticket(ligne_ticket13);
    fact_recue10.addligneticket(ligne_ticket14);
    fact_recue10.addligneticket(ligne_ticket15);
    INSERT INTO client_o c VALUES (
        1,
        'Croesi',
        'Elena',
        ad12,
        TO_DATE('07-07-1999', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client1;

    INSERT INTO client_o c VALUES (
        2,
        'Croesi',
        'Enzo',
        ad12,
        TO_DATE('07-07-1996', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client2;

    INSERT INTO client_o c VALUES (
        3,
        'Mecene',
        'Julie',
        ad9,
        TO_DATE('25-12-1996', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client3;

    INSERT INTO client_o c VALUES (
        4,
        'Titus',
        'Xavier',
        ad13,
        TO_DATE('10-09-1970', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client4;

    INSERT INTO client_o c VALUES (
        5,
        'Moulu',
        'Pierre',
        ad14,
        TO_DATE('24-12-1985', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client5;

    INSERT INTO client_o c VALUES (
        6,
        'Croissant',
        'Sophie',
        ad15,
        TO_DATE('07-01-1965', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client6;

    INSERT INTO client_o c VALUES (
        7,
        'Smith',
        'Will',
        ad16,
        TO_DATE('07-07-1965', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client7;

    INSERT INTO client_o c VALUES (
        8,
        'Depardieu',
        'Gerard',
        ad17,
        TO_DATE('13-11-1950', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client8;

    INSERT INTO client_o c VALUES (
        9,
        'Sacquet',
        'Frodon',
        ad18,
        TO_DATE('01-01-1955', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client9;

    INSERT INTO client_o c VALUES (
        10,
        'Fortune',
        'Sarah',
        ad19,
        TO_DATE('12-10-1998', 'DD-MM-YYYY'),
        NULL
    ) RETURNING ref(c) INTO client10;

    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(11, 1, listrefligneticket_t(), 'autre', employe1, carte1,
                                                     TO_DATE('22-12-2021', 'DD-MM-YYYY'), client1, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 0) ) RETURNING ref(fe1) INTO fact_emise1ref;

    INSERT INTO ligneticket_o lt VALUES (
        16,
        4,
        article1,
        fact_emise1ref
    ) RETURNING ref(lt) INTO ligne_ticket16;

    SELECT
        deref(fact_emise1ref)
    INTO fact_emise1
    FROM
        dual;

    fact_emise1.addligneticket(ligne_ticket16);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(12, 1, listrefligneticket_t(), 'autre', employe2, carte1,
                                                     TO_DATE('25-12-2021', 'DD-MM-YYYY'), client2, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise2ref;

    INSERT INTO ligneticket_o lt VALUES (
        17,
        1,
        article2,
        fact_emise2ref
    ) RETURNING ref(lt) INTO ligne_ticket17;

    INSERT INTO ligneticket_o lt VALUES (
        18,
        3,
        article3,
        fact_emise2ref
    ) RETURNING ref(lt) INTO ligne_ticket18;

    SELECT
        deref(fact_emise2ref)
    INTO fact_emise2
    FROM
        dual;

    fact_emise2.addligneticket(ligne_ticket17);
    fact_emise2.addligneticket(ligne_ticket18);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(13, 1, listrefligneticket_t(), 'autre', employe1, carte2,
                                                     TO_DATE('25-12-2021', 'DD-MM-YYYY'), client5, TO_DATE('20-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise3ref;

    INSERT INTO ligneticket_o lt VALUES (
        19,
        5,
        article4,
        fact_emise3ref
    ) RETURNING ref(lt) INTO ligne_ticket19;

    SELECT
        deref(fact_emise3ref)
    INTO fact_emise3
    FROM
        dual;

    fact_emise3.addligneticket(ligne_ticket19);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(14, 1, listrefligneticket_t(), 'autre', employe1, NULL,
                                                     TO_DATE('25-12-2021', 'DD-MM-YYYY'), client8, TO_DATE('20-01-2022',
               'DD-MM-YYYY'), 0) ) RETURNING ref(fe1) INTO fact_emise4ref;

    INSERT INTO ligneticket_o lt VALUES (
        20,
        10,
        article8,
        fact_emise4ref
    ) RETURNING ref(lt) INTO ligne_ticket20;

    SELECT
        deref(fact_emise4ref)
    INTO fact_emise4
    FROM
        dual;

    fact_emise4.addligneticket(ligne_ticket20);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(15, 1, listrefligneticket_t(), 'autre', employe2, NULL,
                                                     TO_DATE('25-10-2021', 'DD-MM-YYYY'), client8, TO_DATE('20-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise5ref;

    INSERT INTO ligneticket_o lt VALUES (
        21,
        5,
        article10,
        fact_emise5ref
    ) RETURNING ref(lt) INTO ligne_ticket21;

    SELECT
        deref(fact_emise5ref)
    INTO fact_emise5
    FROM
        dual;

    fact_emise5.addligneticket(ligne_ticket21);
    /**/
END;
/

COMMIT;
