CREATE OR REPLACE TYPE BODY adresse_t AS
    MAP MEMBER FUNCTION compadresse RETURN VARCHAR2 IS
    BEGIN
        RETURN pays
               || codepostal
               || rue
               || numero;
    END;

END;
/

CREATE OR REPLACE TYPE BODY article_t AS
    MAP MEMBER FUNCTION comparticle RETURN VARCHAR2 IS
    BEGIN
        RETURN nom
               || prix_vente
               || codebarre;
    END;

END;
/

CREATE OR REPLACE TYPE BODY client_t AS
    MAP MEMBER FUNCTION compclient RETURN VARCHAR2 IS
    BEGIN
        RETURN nom
               || prenom
               || id;
    END;

    STATIC FUNCTION get_factures_a_encaisser (
        client_id IN NUMBER
    ) RETURN setticket_t IS
        res setticket_t;
    BEGIN
        SELECT
            CAST(COLLECT(value(f)) AS setticket_t)
        INTO res
        FROM
            ticket_o f
        WHERE
                deref(TREAT(value(f) AS factureemise_t).client).id = client_id
            AND TREAT(value(f) AS factureemise_t).payeounon = 0;

        RETURN res;
    END;

END;
/

CREATE OR REPLACE TYPE BODY carte_t AS
    MAP MEMBER FUNCTION compcarte RETURN NUMBER IS
    BEGIN
        RETURN remise;
    END;

END;
/

CREATE OR REPLACE TYPE BODY fournisseur_t AS
    MAP MEMBER FUNCTION compfournisseur RETURN VARCHAR2 IS
    BEGIN
        RETURN nom
               || prenom
               || siret;
    END;

    MEMBER FUNCTION get_factures_a_payer RETURN setticket_t IS
        res setticket_t;
    BEGIN
        SELECT
            CAST(COLLECT(value(f)) AS setticket_t)
        INTO res
        FROM
            ticket_o f
        WHERE
                deref(TREAT(value(f) AS facturerecue_t).fournisseur).siret = self.siret
            AND TREAT(value(f) AS facturerecue_t).payeounon = 0;

        RETURN res;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

END;
/

CREATE OR REPLACE TYPE BODY empl_t AS
    ORDER MEMBER FUNCTION compemploye (
        emp IN empl_t
    ) RETURN NUMBER IS

        pos1    NUMBER := 0;
        pos2    NUMBER := 0;
        empself VARCHAR2(60) := self.nom || self.numsecu;
        emppar  VARCHAR2(60) := emp.nom || emp.numsecu;
    BEGIN
        CASE self.job
            WHEN 'Directeur' THEN
                pos1 := 1;
            WHEN 'Responsable' THEN
                pos1 := 2;
            WHEN 'Caissier' THEN
                pos1 := 3;
            WHEN 'Polyvalent' THEN
                pos1 := 4;
        END CASE;

        CASE emp.job
            WHEN 'Directeur' THEN
                pos2 := 1;
            WHEN 'Responsabe' THEN
                pos2 := 2;
            WHEN 'Caissier' THEN
                pos2 := 3;
            WHEN 'Polyvalent' THEN
                pos2 := 4;
        END CASE;

        empself := pos1 || empself;
        emppar := pos2 || emppar;
        IF empself = emppar THEN
            RETURN 0;
        ELSIF empself > emppar THEN
            RETURN 1;
        ELSIF empself < emppar THEN
            RETURN -1;
        END IF;

    END;

END;
/

CREATE OR REPLACE TYPE BODY ticket_t AS
    MAP MEMBER FUNCTION compticket RETURN VARCHAR2 IS
    BEGIN
        RETURN dateemission || id;
    END;

    STATIC FUNCTION getarticles (
        id1 IN NUMBER
    ) RETURN listrefligneticket_t IS
        listreflignes listrefligneticket_t;
    BEGIN
        SELECT
            ligneticket
        INTO listreflignes
        FROM
            ticket_o ot
        WHERE
            ot.id = id1;

        RETURN listreflignes;
    END;

    MEMBER FUNCTION gettotal RETURN NUMBER IS

        accum         NUMBER := 0;
        articletemp   article_t;
        quantitetemp  NUMBER;
        listreflignes listrefligneticket_t := ticket_t.getarticles(self.id);
        carte         carte_t;
    BEGIN
        FOR i IN listreflignes.first..listreflignes.last LOOP
            SELECT
                deref(deref(listreflignes(i)).article),
                deref(listreflignes(i)).quantite
            INTO
                articletemp,
                quantitetemp
            FROM
                dual;

            IF self.estvente = 0 THEN
                accum := accum + articletemp.prix_achat * quantitetemp;
            ELSE
                accum := accum + articletemp.prix_vente * quantitetemp;
            END IF;

        END LOOP;

        SELECT
            deref(self.carte_reduction)
        INTO carte
        FROM
            dual;

        IF carte IS NOT NULL THEN
            accum := accum * ( 1 - carte.remise );
        END IF;

        RETURN accum;
    END;

    MEMBER PROCEDURE addligneticket (
        ligneticket REF ligneticket_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.ligneticket
            FROM
                ticket_o ot
            WHERE
                ot.id = self.id
        ) VALUES ( ligneticket );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE deleteligneticket (
        ligneticket REF ligneticket_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.ligneticket
            FROM
                ticket_o ot
            WHERE
                ot.id = self.id
        ) le
        WHERE
            le.column_value = ligneticket;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE updateligneticket (
        ligneticket1 REF ligneticket_t,
        ligneticket2 REF ligneticket_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.ligneticket
            FROM
                ticket_o ot
            WHERE
                ot.id = self.id
        ) le
        SET
            le.column_value = ligneticket2
        WHERE
            le.column_value = ligneticket1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER FUNCTION print_ticket RETURN VARCHAR2 IS

        listarticles listrefligneticket_t;
        quantite     NUMBER;
        articletemp  article_t;
        txt          VARCHAR(20);
        carte        carte_t;
        res          VARCHAR2(500);
    BEGIN
        listarticles := ticket_t.getarticles(self.id);
        IF self.estvente = 1 THEN
            txt := 'de vente';
        ELSE
            txt := 'd''achat';
        END IF;

        res := res
               || 'Le ticket '
               || txt
               || ' numero '
               || self.id
               || ' contient les articles suivants :';

        FOR i IN listarticles.first..listarticles.last LOOP
            SELECT
                deref(deref(listarticles(i)).article),
                deref(listarticles(i)).quantite
            INTO
                articletemp,
                quantite
            FROM
                dual;

            res := res
                   || chr(13)
                   || chr(10)
                   || 'Article n.'
                   || i
                   || ' : '
                   || articletemp.nom
                   || ' (quantite = '
                   || quantite
                   || ', prix_vente = '
                   || articletemp.prix_vente
                   || ', prix_achat = '
                   || articletemp.prix_achat
                   || ')';

        END LOOP;

        SELECT
            deref(self.carte_reduction)
        INTO carte
        FROM
            dual;

        IF carte IS NOT NULL THEN
            res := res
                   || chr(13)
                   || chr(10)
                   || 'sur ce ticket il y a une reduction de '
                   || carte.remise
                   || ' %';
        END IF;

        res := res
               || chr(13)
               || chr(10)
               || 'prix totale '
               || id
               || ' : '
               || self.gettotal();

        RETURN res;
    END;

END;
/