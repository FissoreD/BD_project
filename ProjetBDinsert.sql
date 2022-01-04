ALTER TABLE ticket_o DISABLE ALL TRIGGERS;

DELETE FROM adresse_o;

DELETE FROM fournisseur_o;

DELETE FROM ticket_o;

DELETE FROM empl_o;

DELETE FROM client_o;

DELETE FROM ligneticket_o;

DELETE FROM article_o;

DELETE FROM carte_o;

ALTER TABLE ticket_o ENABLE ALL TRIGGERS;

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
    article1ref     REF article_t;
    article2ref     REF article_t;
    article3ref     REF article_t;
    article4ref     REF article_t;
    article5ref     REF article_t;
    article6ref     REF article_t;
    article7ref     REF article_t;
    article8ref     REF article_t;
    article9ref     REF article_t;
    article10ref    REF article_t;
    article11ref    REF article_t;
    article12ref    REF article_t;
    article13ref    REF article_t;
    article14ref    REF article_t;
    article15ref    REF article_t;
    article1        article_t;
    article2        article_t;
    article3        article_t;
    article4        article_t;
    article5        article_t;
    article6        article_t;
    article7        article_t;
    article8        article_t;
    article9        article_t;
    article10       article_t;
    article11       article_t;
    article12       article_t;
    article13       article_t;
    article14       article_t;
    article15       article_t;
    employe1ref     REF empl_t;
    employe2ref     REF empl_t;
    employe3ref     REF empl_t;
    employe4ref     REF empl_t;
    employe5ref     REF empl_t;
    employe6ref     REF empl_t;
    employe1        empl_t;
    employe2        empl_t;
    employe3        empl_t;
    employe4        empl_t;
    employe5        empl_t;
    employe6        empl_t;
    fourn1ref       REF fournisseur_t;
    fourn2ref       REF fournisseur_t;
    fourn3ref       REF fournisseur_t;
    fourn4ref       REF fournisseur_t;
    fourn5ref       REF fournisseur_t;
    fourn1          fournisseur_t;
    fourn2          fournisseur_t;
    fourn3          fournisseur_t;
    fourn4          fournisseur_t;
    fourn5          fournisseur_t;
    client1ref      REF client_t;
    client2ref      REF client_t;
    client3ref      REF client_t;
    client4ref      REF client_t;
    client5ref      REF client_t;
    client6ref      REF client_t;
    client7ref      REF client_t;
    client8ref      REF client_t;
    client9ref      REF client_t;
    client10ref     REF client_t;
    client1         client_t;
    client2         client_t;
    client3         client_t;
    client4         client_t;
    client5         client_t;
    client6         client_t;
    client7         client_t;
    client8         client_t;
    client9         client_t;
    client10        client_t;
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
    ticket1ref      REF ticket_t;
    ticket1         ticket_t;
    carte1          REF carte_t;
    carte2          REF carte_t;
    carte3          REF carte_t;
    carte4          REF carte_t;
    carte5          REF carte_t;
    carte1dr        carte_t;
    carte2dr        carte_t;
    carte3dr        carte_t;
    carte4dr        carte_t;
    carte5dr        carte_t;
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

    INSERT INTO carte_o c VALUES (
        'VIP',
        0.40,
        listrefclients_t()
    );

    INSERT INTO carte_o c VALUES (
        'VIP+',
        0.50,
        listrefclients_t()
    );

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
        listrefticket_t()
    ) RETURNING ref(f) INTO fourn1ref;

    INSERT INTO fournisseur_o f VALUES (
        5050,
        'Bouchon',
        'Albert',
        ad2,
        TO_DATE('01-02-1970', 'DD-MM-YYYY'),
        listrefticket_t()
    ) RETURNING ref(f) INTO fourn2ref;

    INSERT INTO fournisseur_o f VALUES (
        4567,
        'Bonaparte',
        'Napoleon',
        ad3,
        TO_DATE('01-02-1983', 'DD-MM-YYYY'),
        listrefticket_t()
    ) RETURNING ref(f) INTO fourn3ref;

    INSERT INTO fournisseur_o f VALUES (
        1919,
        'Clement',
        'Paul',
        ad4,
        TO_DATE('21-10-1980', 'DD-MM-YYYY'),
        listrefticket_t()
    ) RETURNING ref(f) INTO fourn4ref;

    INSERT INTO fournisseur_o f VALUES (
        9874,
        'Combe',
        'Sylvie',
        ad5,
        TO_DATE('01-02-1975', 'DD-MM-YYYY'),
        listrefticket_t()
    ) RETURNING ref(f) INTO fourn5ref;

    utl_ref.select_object(fourn1ref, fourn1);
    utl_ref.select_object(fourn2ref, fourn2);
    utl_ref.select_object(fourn3ref, fourn3);
    utl_ref.select_object(fourn4ref, fourn4);
    utl_ref.select_object(fourn5ref, fourn5);
    INSERT INTO empl_o e VALUES (
        111111111111,
        'Dupont',
        'Marcello',
        'Caissier',
        ad6,
        TO_DATE('25-12-1999', 'DD-MM-YYYY'),
        TO_DATE('06-05-2020', 'DD-MM-YYYY'),
        1500,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe1ref;

    INSERT INTO empl_o e VALUES (
        1111111111112,
        'Dupont',
        'Jean',
        'Caissier',
        ad7,
        TO_DATE('25-12-1999', 'DD-MM-YYYY'),
        TO_DATE('06-05-2020', 'DD-MM-YYYY'),
        1600,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe2ref;

    INSERT INTO empl_o e VALUES (
        1111113111111,
        'Peretti',
        'Antoine',
        'Polyvalent',
        ad8,
        TO_DATE('12-01-1970', 'DD-MM-YYYY'),
        TO_DATE('30-10-2015', 'DD-MM-YYYY'),
        2000,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe3ref;

    INSERT INTO empl_o e VALUES (
        1111111114111,
        'Mecene',
        'Julie',
        'Polyvalent',
        ad9,
        TO_DATE('25-12-1996', 'DD-MM-YYYY'),
        TO_DATE('15-03-2018', 'DD-MM-YYYY'),
        2000,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe4ref;

    INSERT INTO empl_o e VALUES (
        1115111111111,
        'Pilouche',
        'Daniel',
        'Responsable',
        ad10,
        TO_DATE('25-12-1956', 'DD-MM-YYYY'),
        TO_DATE('06-05-1980', 'DD-MM-YYYY'),
        3200,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe5ref;

    INSERT INTO empl_o e VALUES (
        1111111116111,
        'Peretti',
        'Cathie',
        'Directeur',
        ad11,
        TO_DATE('25-12-1980', 'DD-MM-YYYY'),
        TO_DATE('06-05-2009', 'DD-MM-YYYY'),
        4200,
        NULL,
        listrefticket_t()
    ) RETURNING ref(e) INTO employe6ref;

    utl_ref.select_object(employe1ref, employe1);
    utl_ref.select_object(employe2ref, employe2);
    utl_ref.select_object(employe3ref, employe3);
    utl_ref.select_object(employe4ref, employe4);
    utl_ref.select_object(employe5ref, employe5);
    utl_ref.select_object(employe6ref, employe6);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(1, 0, listrefligneticket_t(), 'autre', NULL,
                                                   carte1, TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn1ref, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue1ref;

    fourn1.add_facture(fact_recue1ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(2, 0, listrefligneticket_t(), 'espece', NULL,
                                                   carte2, TO_DATE('20-12-2021', 'DD-MM-YYYY'), fourn1ref, TO_DATE('31-12-2022',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue2ref;

    fourn1.add_facture(fact_recue2ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(3, 0, listrefligneticket_t(), 'espece', NULL,
                                                   NULL, TO_DATE('30-12-2021', 'DD-MM-YYYY'), fourn2ref, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue3ref;

    fourn2.add_facture(fact_recue3ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(4, 0, listrefligneticket_t(), 'cb', NULL,
                                                   NULL, TO_DATE('15-12-2020', 'DD-MM-YYYY'), fourn3ref, TO_DATE('27-02-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue4ref;

    fourn3.add_facture(fact_recue4ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(5, 0, listrefligneticket_t(), 'cb', NULL,
                                                   NULL, TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn3ref, TO_DATE('31-12-2025',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue5ref;

    fourn3.add_facture(fact_recue5ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(6, 0, listrefligneticket_t(), 'cb', NULL,
                                                   carte3, TO_DATE('15-12-2021', 'DD-MM-YYYY'), fourn3ref, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue6ref;

    fourn3.add_facture(fact_recue6ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(7, 0, listrefligneticket_t(), 'cheque', NULL,
                                                   carte4, TO_DATE('15-10-2021', 'DD-MM-YYYY'), fourn4ref, TO_DATE('30-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue7ref;

    fourn4.add_facture(fact_recue7ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(8, 0, listrefligneticket_t(), 'cheque', NULL,
                                                   carte2, TO_DATE('10-08-2021', 'DD-MM-YYYY'), fourn4ref, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue8ref;

    fourn4.add_facture(fact_recue8ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(9, 0, listrefligneticket_t(), 'cheque', NULL,
                                                   NULL, TO_DATE('30-12-2021', 'DD-MM-YYYY'), fourn5ref, TO_DATE('31-12-2023',
               'DD-MM-YYYY'), 0) ) RETURNING ref(o) INTO fact_recue9ref;

    fourn5.add_facture(fact_recue9ref);
    INSERT INTO ticket_o o VALUES ( facturerecue_t(10, 0, listrefligneticket_t(), 'cheque', NULL,
                                                   NULL, TO_DATE('25-12-2018', 'DD-MM-YYYY'), fourn5ref, TO_DATE('31-12-2020',
               'DD-MM-YYYY'), 1) ) RETURNING ref(o) INTO fact_recue10ref;

    fourn5.add_facture(fact_recue10ref);
    INSERT INTO article_o a VALUES (
        5,
        '1111111111111',
        'ASUS X53S',
        380,
        450,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article1ref;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111112',
        'PREDATOR HELIOS 300',
        800,
        999,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article2ref;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111113',
        'LOGITECH MOUSE GAMING',
        30,
        50,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article3ref;

    INSERT INTO article_o a VALUES (
        50,
        '1111111111114',
        'house protection ordinateur',
        5,
        8,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article4ref;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111115',
        'USB cable',
        2,
        3,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article5ref;

    INSERT INTO article_o a VALUES (
        100,
        '1111111111116',
        'tapis de souris',
        5,
        10,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article6ref;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111117',
        'casque gaming',
        70,
        100,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article7ref;

    INSERT INTO article_o a VALUES (
        5,
        '1111111111118',
        'appareil photo',
        400,
        480,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article8ref;

    INSERT INTO article_o a VALUES (
        3,
        '1111111111119',
        'Macbook',
        700,
        800,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article9ref;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111120',
        'tablette samsung',
        300,
        400,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article10ref;

    INSERT INTO article_o a VALUES (
        8,
        '1111111111121',
        'tablette apple',
        400,
        500,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article11ref;

    INSERT INTO article_o a VALUES (
        40,
        '1111111111122',
        'telephone portable samsung',
        220,
        250,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article12ref;

    INSERT INTO article_o a VALUES (
        20,
        '1111111111123',
        'iphone',
        450,
        500,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article13ref;

    INSERT INTO article_o a VALUES (
        30,
        '1111111111124',
        'telephone portable huawei',
        220,
        250,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article14ref;

    INSERT INTO article_o a VALUES (
        10,
        '1111111111125',
        'imprimante hp',
        80,
        120,
        listrefligneticket_t()
    ) RETURNING ref(a) INTO article15ref;

    utl_ref.select_object(article1ref, article1);
    utl_ref.select_object(article2ref, article2);
    utl_ref.select_object(article3ref, article3);
    utl_ref.select_object(article4ref, article4);
    utl_ref.select_object(article5ref, article5);
    utl_ref.select_object(article6ref, article6);
    utl_ref.select_object(article7ref, article7);
    utl_ref.select_object(article8ref, article8);
    utl_ref.select_object(article9ref, article9);
    utl_ref.select_object(article10ref, article10);
    utl_ref.select_object(article11ref, article11);
    utl_ref.select_object(article12ref, article12);
    utl_ref.select_object(article13ref, article13);
    utl_ref.select_object(article14ref, article14);
    utl_ref.select_object(article15ref, article15);
    INSERT INTO ligneticket_o lt VALUES (
        1,
        5,
        article1ref,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket1;

    article1.add_ligne_ticket(ligne_ticket1);
    INSERT INTO ligneticket_o lt VALUES (
        2,
        10,
        article2ref,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket2;

    article2.add_ligne_ticket(ligne_ticket2);
    INSERT INTO ligneticket_o lt VALUES (
        3,
        20,
        article3ref,
        fact_recue1ref
    ) RETURNING ref(lt) INTO ligne_ticket3;

    article3.add_ligne_ticket(ligne_ticket3);
    utl_ref.select_object(fact_recue1ref, fact_recue1);
    fact_recue1.addligneticket(ligne_ticket1);
    fact_recue1.addligneticket(ligne_ticket2);
    fact_recue1.addligneticket(ligne_ticket3);
    INSERT INTO ligneticket_o lt VALUES (
        4,
        50,
        article4ref,
        fact_recue2ref
    ) RETURNING ref(lt) INTO ligne_ticket4;

    article4.add_ligne_ticket(ligne_ticket4);
    utl_ref.select_object(fact_recue2ref, fact_recue2);
    fact_recue2.addligneticket(ligne_ticket4);
    INSERT INTO ligneticket_o lt VALUES (
        5,
        20,
        article5ref,
        fact_recue3ref
    ) RETURNING ref(lt) INTO ligne_ticket5;

    article5.add_ligne_ticket(ligne_ticket5);
    utl_ref.select_object(fact_recue3ref, fact_recue3);
    fact_recue3.addligneticket(ligne_ticket5);
    INSERT INTO ligneticket_o lt VALUES (
        6,
        5,
        article6ref,
        fact_recue4ref
    ) RETURNING ref(lt) INTO ligne_ticket6;

    article6.add_ligne_ticket(ligne_ticket6);
    utl_ref.select_object(fact_recue4ref, fact_recue4);
    fact_recue4.addligneticket(ligne_ticket6);
    INSERT INTO ligneticket_o lt VALUES (
        7,
        5,
        article7ref,
        fact_recue5ref
    ) RETURNING ref(lt) INTO ligne_ticket7;

    article7.add_ligne_ticket(ligne_ticket7);
    utl_ref.select_object(fact_recue5ref, fact_recue5);
    fact_recue5.addligneticket(ligne_ticket7);
    INSERT INTO ligneticket_o lt VALUES (
        8,
        5,
        article8ref,
        fact_recue6ref
    ) RETURNING ref(lt) INTO ligne_ticket8;

    article8.add_ligne_ticket(ligne_ticket8);
    utl_ref.select_object(fact_recue6ref, fact_recue6);
    fact_recue6.addligneticket(ligne_ticket8);
    INSERT INTO ligneticket_o lt VALUES (
        9,
        5,
        article9ref,
        fact_recue7ref
    ) RETURNING ref(lt) INTO ligne_ticket9;

    article9.add_ligne_ticket(ligne_ticket9);
    utl_ref.select_object(fact_recue7ref, fact_recue7);
    fact_recue7.addligneticket(ligne_ticket9);
    INSERT INTO ligneticket_o lt VALUES (
        10,
        5,
        article10ref,
        fact_recue8ref
    ) RETURNING ref(lt) INTO ligne_ticket10;

    article10.add_ligne_ticket(ligne_ticket10);
    utl_ref.select_object(fact_recue8ref, fact_recue8);
    fact_recue8.addligneticket(ligne_ticket10);
    INSERT INTO ligneticket_o lt VALUES (
        11,
        5,
        article11ref,
        fact_recue9ref
    ) RETURNING ref(lt) INTO ligne_ticket11;

    article11.add_ligne_ticket(ligne_ticket11);
    utl_ref.select_object(fact_recue9ref, fact_recue9);
    fact_recue9.addligneticket(ligne_ticket11);
    INSERT INTO ligneticket_o lt VALUES (
        12,
        5,
        article12ref,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket12;

    article12.add_ligne_ticket(ligne_ticket12);
    INSERT INTO ligneticket_o lt VALUES (
        13,
        5,
        article13ref,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket13;

    article13.add_ligne_ticket(ligne_ticket13);
    INSERT INTO ligneticket_o lt VALUES (
        14,
        5,
        article14ref,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket14;

    article14.add_ligne_ticket(ligne_ticket14);
    INSERT INTO ligneticket_o lt VALUES (
        15,
        5,
        article15ref,
        fact_recue10ref
    ) RETURNING ref(lt) INTO ligne_ticket15;

    article5.add_ligne_ticket(ligne_ticket15);
    utl_ref.select_object(fact_recue10ref, fact_recue10);
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
        carte1,
        listrefticket_t()
    ) RETURNING ref(c) INTO client1ref;

    INSERT INTO client_o c VALUES (
        2,
        'Croesi',
        'Enzo',
        ad12,
        TO_DATE('07-07-1996', 'DD-MM-YYYY'),
        carte2,
        listrefticket_t()
    ) RETURNING ref(c) INTO client2ref;

    INSERT INTO client_o c VALUES (
        3,
        'Mecene',
        'Julie',
        ad9,
        TO_DATE('25-12-1996', 'DD-MM-YYYY'),
        carte3,
        listrefticket_t()
    ) RETURNING ref(c) INTO client3ref;

    INSERT INTO client_o c VALUES (
        4,
        'Titus',
        'Xavier',
        ad13,
        TO_DATE('10-09-1970', 'DD-MM-YYYY'),
        carte4,
        listrefticket_t()
    ) RETURNING ref(c) INTO client4ref;

    INSERT INTO client_o c VALUES (
        5,
        'Moulu',
        'Pierre',
        ad14,
        TO_DATE('24-12-1985', 'DD-MM-YYYY'),
        carte5,
        listrefticket_t()
    ) RETURNING ref(c) INTO client5ref;

    INSERT INTO client_o c VALUES (
        6,
        'Croissant',
        'Sophie',
        ad15,
        TO_DATE('07-01-1965', 'DD-MM-YYYY'),
        carte5,
        listrefticket_t()
    ) RETURNING ref(c) INTO client6ref;

    INSERT INTO client_o c VALUES (
        7,
        'Smith',
        'Will',
        ad16,
        TO_DATE('07-07-1965', 'DD-MM-YYYY'),
        NULL,
        listrefticket_t()
    ) RETURNING ref(c) INTO client7ref;

    INSERT INTO client_o c VALUES (
        8,
        'Depardieu',
        'Gerard',
        ad17,
        TO_DATE('13-11-1950', 'DD-MM-YYYY'),
        NULL,
        listrefticket_t()
    ) RETURNING ref(c) INTO client8ref;

    INSERT INTO client_o c VALUES (
        9,
        'Sacquet',
        'Frodon',
        ad18,
        TO_DATE('01-01-1955', 'DD-MM-YYYY'),
        NULL,
        listrefticket_t()
    ) RETURNING ref(c) INTO client9ref;

    INSERT INTO client_o c VALUES (
        10,
        'Fortune',
        'Sarah',
        ad19,
        TO_DATE('12-10-1998', 'DD-MM-YYYY'),
        NULL,
        listrefticket_t()
    ) RETURNING ref(c) INTO client10ref;

    utl_ref.select_object(client1ref, client1);
    utl_ref.select_object(client2ref, client2);
    utl_ref.select_object(client3ref, client3);
    utl_ref.select_object(client4ref, client4);
    utl_ref.select_object(client5ref, client5);
    utl_ref.select_object(client6ref, client6);
    utl_ref.select_object(client7ref, client7);
    utl_ref.select_object(client8ref, client8);
    utl_ref.select_object(client9ref, client9);
    utl_ref.select_object(client10ref, client10);
    utl_ref.select_object(carte1, carte1dr);
    carte1dr.addclient(client1ref);
    utl_ref.select_object(carte2, carte2dr);
    carte2dr.addclient(client2ref);
    utl_ref.select_object(carte3, carte3dr);
    carte3dr.addclient(client3ref);
    utl_ref.select_object(carte4, carte4dr);
    carte4dr.addclient(client4ref);
    utl_ref.select_object(carte5, carte5dr);
    carte5dr.addclient(client5ref);
    carte5dr.addclient(client6ref);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(11, 1, listrefligneticket_t(), 'autre', employe1ref,
                                                     carte1, TO_DATE('22-12-2005', 'DD-MM-YYYY'), client1ref, TO_DATE('31-12-2006',
               'DD-MM-YYYY'), 0) ) RETURNING ref(fe1) INTO fact_emise1ref;

    employe1.add_ticket_emis(fact_emise1ref);
    client1.add_facture(fact_emise1ref);
    INSERT INTO ligneticket_o lt VALUES (
        16,
        4,
        article1ref,
        fact_emise1ref
    ) RETURNING ref(lt) INTO ligne_ticket16;

    utl_ref.select_object(fact_emise1ref, fact_emise1);
    fact_emise1.addligneticket(ligne_ticket16);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(12, 1, listrefligneticket_t(), 'autre', employe2ref,
                                                     carte2, TO_DATE('25-12-2021', 'DD-MM-YYYY'), client2ref, TO_DATE('31-12-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise2ref;

    employe2.add_ticket_emis(fact_emise2ref);
    client2.add_facture(fact_emise2ref);
    INSERT INTO ligneticket_o lt VALUES (
        17,
        1,
        article2ref,
        fact_emise2ref
    ) RETURNING ref(lt) INTO ligne_ticket17;

    INSERT INTO ligneticket_o lt VALUES (
        18,
        3,
        article3ref,
        fact_emise2ref
    ) RETURNING ref(lt) INTO ligne_ticket18;

    utl_ref.select_object(fact_emise2ref, fact_emise2);
    fact_emise2.addligneticket(ligne_ticket17);
    fact_emise2.addligneticket(ligne_ticket18);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(13, 1, listrefligneticket_t(), 'autre', employe1ref,
                                                     carte5, TO_DATE('25-12-2021', 'DD-MM-YYYY'), client5ref, TO_DATE('20-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise3ref;

    employe1.add_ticket_emis(fact_emise3ref);
    client5.add_facture(fact_emise3ref);
    INSERT INTO ligneticket_o lt VALUES (
        19,
        5,
        article4ref,
        fact_emise3ref
    ) RETURNING ref(lt) INTO ligne_ticket19;

    utl_ref.select_object(fact_emise3ref, fact_emise3);
    fact_emise3.addligneticket(ligne_ticket19);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(14, 1, listrefligneticket_t(), 'autre', employe1ref,
                                                     NULL, TO_DATE('25-12-2021', 'DD-MM-YYYY'), client8ref, TO_DATE('20-01-2022',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise4ref;

    employe1.add_ticket_emis(fact_emise4ref);
    client8.add_facture(fact_emise4ref);
    INSERT INTO ligneticket_o lt VALUES (
        20,
        10,
        article8ref,
        fact_emise4ref
    ) RETURNING ref(lt) INTO ligne_ticket20;

    utl_ref.select_object(fact_emise4ref, fact_emise4);
    fact_emise4.addligneticket(ligne_ticket20);
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(15, 1, listrefligneticket_t(), 'autre', employe2ref,
                                                     NULL, TO_DATE('25-10-2021', 'DD-MM-YYYY'), client8ref, TO_DATE('20-11-2021',
               'DD-MM-YYYY'), 1) ) RETURNING ref(fe1) INTO fact_emise5ref;

    employe2.add_ticket_emis(fact_emise5ref);
    client8.add_facture(fact_emise5ref);
    INSERT INTO ligneticket_o lt VALUES (
        21,
        5,
        article10ref,
        fact_emise5ref
    ) RETURNING ref(lt) INTO ligne_ticket21;

    utl_ref.select_object(fact_emise5ref, fact_emise5);
    fact_emise5.addligneticket(ligne_ticket21);
    INSERT INTO ticket_o t VALUES (
        16,
        1,
        listrefligneticket_t(),
        'cb',
        employe3ref,
        carte1,
        TO_DATE('05-01-2022', 'DD-MM-YYYY')
    ) RETURN ref(t) INTO ticket1ref;

    utl_ref.select_object(ticket1ref, ticket1);
    employe3.add_ticket_emis(ticket1ref);
    INSERT INTO ligneticket_o lt VALUES (
        22,
        2,
        article6ref,
        ticket1ref
    ) RETURN ref(lt) INTO ligne_ticket1;

    ticket1.addligneticket(ligne_ticket1);
    INSERT INTO ticket_o t VALUES (
        17,
        1,
        listrefligneticket_t(),
        'cb',
        employe2ref,
        carte2,
        TO_DATE('05-01-2010', 'DD-MM-YYYY')
    ) RETURN ref(t) INTO ticket1ref;

    utl_ref.select_object(ticket1ref, ticket1);
    employe2.add_ticket_emis(ticket1ref);
    INSERT INTO ligneticket_o lt VALUES (
        23,
        3,
        article6ref,
        ticket1ref
    ) RETURN ref(lt) INTO ligne_ticket1;

    ticket1.addligneticket(ligne_ticket1);
    /**/
END;
/

COMMIT;