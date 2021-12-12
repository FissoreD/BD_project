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
               || prix
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

END;
/

CREATE OR REPLACE TYPE BODY emplo_t AS
    ORDER MEMBER FUNCTION compemploye (
        emp IN emplo_t
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

END;
/