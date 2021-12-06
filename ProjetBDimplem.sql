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
    MAP MEMBER FUNCTION comparticle RETURN VARCHAR2 IS
    BEGIN
        RETURN nom
               || prenom
               || id;
    END;

END;
/

CREATE OR REPLACE TYPE carte_t AS OBJECT (
    nom     VARCHAR2(30),
    remise  NUMBER,
    clients listrefclients_t
);
/

CREATE OR REPLACE TYPE BODY carte_t AS
    MAP MEMBER FUNCTION comparticle RETURN VARCHAR2 IS
    BEGIN
        RETURN remise;
    END;

END;
/

CREATE OR REPLACE TYPE fournisseur_t AS OBJECT (
    siret     NUMBER,
    nnm       VARCHAR2(30),
    prenom    VARCHAR2(30),
    adresse   adresse_t,
    naissance DATE,
    catalogue listrefarticles_t
);
/

CREATE OR REPLACE TYPE BODY carte_t AS
    MAP MEMBER FUNCTION compcarte RETURN VARCHAR2 IS
    BEGIN
        RETURN remise;
    END;

END;
/

CREATE OR REPLACE TYPE BODY employe_t AS
    ORDER MEMBER FUNCTION compemploye (
        emp IN employe_t
    ) RETURN NUMBER IS

        pos1    NUMBER := 0;
        pos2    NUMBER := 0;
        empself VARCHAR2(60) := self.ename || self.empno;
        emppar  VARCHAR2(60) := emp.ename || emp.empno;
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

CREATE OR REPLACE TYPE ticket_t AS OBJECT (
    articles         listrefarticles_t,
    paiement         VARCHAR2(30),
    employeemmetteur employe_t,
    dateemission     DATE
);
/

CREATE OR REPLACE TYPE BODY ticket_t AS
    ORDER MEMBER FUNCTION compticket (
        ticket IN ticket_t
    ) RETURN NUMBER IS
    --emp ref employe_t := ticket.employeemmetteur;
    BEGIN
    /*
        IF self.dateemission = ticket.dateemission THEN
            RETURN 0;--self.employeemmetteur.compemploye(emp);
        ELSE return self.dateemission < ticket.dateemission;
        end if;
        */
        IF self.dateemission < ticket.dateemission THEN
            RETURN 1;
        ELSE
            RETURN -1;
        END IF;
    END;

END;
/