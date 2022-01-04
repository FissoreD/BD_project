SET SERVEROUTPUT ON

DECLARE
    fourn1          fournisseur_t;
    client1         client_t;
    factures_recues listrefticket_t;
    factures_emises listrefticket_t;
    ticket_ref      REF ticket_t;
    ticket_temp     ticket_t;
BEGIN
    SELECT
        value(f)
    INTO fourn1
    FROM
        fournisseur_o f
    WHERE
        siret = 1234;

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
        id = 1;

    factures_emises := client1.get_factures_a_encaisser;
    FOR i IN factures_emises.first..factures_emises.last LOOP
        ticket_ref := factures_emises(i);
        utl_ref.select_object(ticket_ref, ticket_temp);
        dbms_output.put_line('La facture '
                             || ticket_temp.id
                             || ' est a encaisser');
    END LOOP;

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

    str := res1.print_ticket();
    dbms_output.put_line(str);
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
END;
/