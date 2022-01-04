SET SERVEROUTPUT ON

DECLARE
    fourn1          fournisseur_t;
    client1         client_t;
    factures_recues listrefticket_t;
    factures_emises listrefticket_t;
    ref_articles    listrefarticle_t;
    article         article_t;
    ticket_ref      REF ticket_t;
    ticket_temp     ticket_t;
    client_nb       client_o.id%TYPE := 1;
    fourn_nb        fournisseur_o.siret%TYPE := 1234;
    empl            empl_t;
BEGIN
    SELECT
        value(f)
    INTO fourn1
    FROM
        fournisseur_o f
    WHERE
        siret = fourn_nb;

    dbms_output.put_line('     TEST SUR LA METHODE get_factures_a_payer de fournisseur_t');
    dbms_output.put_line('On cherche les facture a payer au fournisseur ' || fourn_nb);
    factures_recues := fourn1.get_factures_a_payer;
    FOR i IN factures_recues.first..factures_recues.last LOOP
        ticket_ref := factures_recues(i);
        utl_ref.select_object(ticket_ref, ticket_temp);
        dbms_output.put_line('La facture '
                             || ticket_temp.id
                             || ' est a payer');
    END LOOP;

    SELECT
        value(f)
    INTO client1
    FROM
        client_o f
    WHERE
        id = client_nb;

    dbms_output.put_line('     TEST SUR LA METHODE get_factures_a_encaisser de client_t');
    dbms_output.put_line('On cherche les factures que le client '
                         || client_nb
                         || ' doit encore nous payer');
    factures_emises := client1.get_factures_a_encaisser;
    FOR i IN factures_emises.first..factures_emises.last LOOP
        utl_ref.select_object(factures_emises(i), ticket_temp);
        dbms_output.put_line('La facture '
                             || ticket_temp.id
                             || ' est a encaisser');
    END LOOP;

    dbms_output.put_line('     TEST SUR LA METHODE get_catalogue de fournisseur_t');
    dbms_output.put_line('Les articles que nous avons achete du fournisseur ' || fourn_nb);
    ref_articles := fourn1.get_catalogue();
    FOR i IN ref_articles.first..ref_articles.last LOOP
        utl_ref.select_object(ref_articles(i), article);
        dbms_output.put_line(article.nom);
    END LOOP;

    dbms_output.put_line('     TEST SUR LA METHODE get_factures_a_encaisser de client_t');
    dbms_output.put_line('Le client '
                         || client_nb
                         || ' a apporte '
                         || client1.get_argent_apporte_en_entreprise
                         || ' euros en entreprise');

    dbms_output.put_line('     TEST SUR LA METHODE get_empl_qui_a_apporte_les_plus_dargent de empl_t');
    empl := empl_t.get_empl_qui_a_apporte_les_plus_dargent();
    dbms_output.put_line('L''employe qui a emis la facture la plus chere est '
                         || empl.nom
                         || ' '
                         || empl.prenom);

    dbms_output.put_line('     TEST SUR LA METHODE get_quantite_achetee et get_quantite_vendue de article_t');
    ticket_temp := empl.get_la_plus_chere_facture_emise();
    dbms_output.put_line('La facture la plus chere est la numero : ' || ticket_temp.id);
    dbms_output.put_line('     TEST SUR LA METHODE get_la_plus_chere_facture_emise de article_t');
    dbms_output.put_line('On a achete '
                         || article.get_quantite_achetee()
                         || ' exemplaires de l''article '
                         || article.nom
                         || ' et en a vendu '
                         || article.get_quantite_vendue()
                         || ' exemplaires');

END;
/

DECLARE
    res1 ticket_t;
    str  VARCHAR2(500);
BEGIN
    SELECT
        value(f)
    INTO res1
    FROM
        ticket_o f
    WHERE
        id = 12;

    dbms_output.put_line('     TESTS SUR LA METHODE print_ticket et gettotal de ticket_t');
    str := res1.print_ticket();
    dbms_output.put_line(str);
    dbms_output.put_line('La facture vaut : '
                         || res1.gettotal()
                         || ' euro');
    dbms_output.put_line('');
    SELECT
        value(f)
    INTO res1
    FROM
        ticket_o f
    WHERE
        id = 14;

    str := res1.print_ticket();
    dbms_output.put_line(str);
    dbms_output.put_line('La facture vaut : '
                         || res1.gettotal()
                         || ' euro');
END;
/

DECLARE
    most_used_card listrefcarte_t;
    carte          carte_t;
    carte_nom      VARCHAR(50) := 'bronze';
BEGIN
    dbms_output.put_line('     TEST SUR LA METHODE get_most_used_card de carte_t');
    most_used_card := carte_t.get_most_used_card();
    dbms_output.put_line('Les cartes les plus vendues sont : ');
    FOR i IN most_used_card.first..most_used_card.last LOOP
        utl_ref.select_object(most_used_card(i), carte);
        dbms_output.put_line('La carte ' || carte.nom);
    END LOOP;

    dbms_output.put_line('');
    dbms_output.put_line('     TEST SUR LA METHODE get_nb_of_cl_from_nom');
    dbms_output.put_line('La carte '
                         || carte_nom
                         || ' est possedee par '
                         || carte_t.get_nb_of_cl_from_nom(carte_nom)
                         || ' clients');

END;