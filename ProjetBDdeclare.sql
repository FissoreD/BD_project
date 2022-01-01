SET SERVEROUTPUT ON

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