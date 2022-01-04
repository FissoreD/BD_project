/*
	2.1 LES TYPES
*/
DROP TABLE empl_o;

DROP TABLE client_o;

DROP TABLE carte_o;

DROP TABLE fournisseur_o;

DROP TYPE setticket_t FORCE;

DROP TYPE setarticle_t FORCE;

DROP TYPE setfacturerecue_t FORCE;

DROP TYPE setfactureemise_t FORCE;

DROP TABLE ligneticket_o;

DROP TABLE adresse_o;

DROP TABLE article_o;

DROP TABLE ticket_o;

DROP TYPE empl_t FORCE;

DROP TYPE adresse_t FORCE;

DROP TYPE factureemise_t FORCE;

DROP TYPE facturerecue_t FORCE;

DROP TYPE ligneticket_t FORCE;

DROP TYPE article_t FORCE;

DROP TYPE client_t FORCE;

DROP TYPE fournisseur_t FORCE;

DROP TYPE ticket_t FORCE;

DROP TYPE listrefticket_t FORCE;

DROP TYPE carte_t FORCE;

DROP TYPE listrefligneticket_t FORCE;

DROP TYPE listrefclients_t FORCE;

drop type listrefempl_t force;
DROP TYPE listrefarticle_t FORCE;

CREATE OR REPLACE TYPE facturerecue_t
/

CREATE OR REPLACE TYPE factureemise_t
/

CREATE OR REPLACE TYPE carte_t
/

CREATE OR REPLACE TYPE client_t
/

CREATE OR REPLACE TYPE fournisseur_t
/

CREATE OR REPLACE TYPE empl_t
/

CREATE OR REPLACE TYPE ticket_t;
/

CREATE OR REPLACE TYPE article_t;
/

CREATE OR REPLACE TYPE adresse_t AS OBJECT (
    pays       VARCHAR2(30),
    ville      VARCHAR2(60),
    codepostal VARCHAR2(5),
    rue        VARCHAR2(100),
    numero     NUMBER,
    MAP MEMBER FUNCTION compadresse RETURN VARCHAR2
);
/
/**/

CREATE OR REPLACE TYPE ligneticket_t AS OBJECT (
    numeroligne  NUMBER,
    quantite     NUMBER,
    article      REF article_t,
    parentticket REF ticket_t,
    MAP MEMBER FUNCTION comparligneticket RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE listrefligneticket_t AS
    TABLE OF REF ligneticket_t
/

CREATE OR REPLACE TYPE ticket_t AS OBJECT (
    -- ceci est un boolean
    id               NUMBER,
    estvente         NUMBER,
    ligneticket      listrefligneticket_t,
    paiement         VARCHAR2(30),
    employeemmetteur REF empl_t,
    carte_reduction  REF carte_t,
    dateemission     DATE,
    MEMBER FUNCTION print_ticket RETURN VARCHAR2,
    MAP MEMBER FUNCTION compticket RETURN VARCHAR2,
    STATIC FUNCTION getarticles (
           id1 IN NUMBER
       ) RETURN listrefligneticket_t,
    MEMBER FUNCTION gettotal RETURN NUMBER,
    MEMBER PROCEDURE addligneticket (
           ligneticket REF ligneticket_t
       ),
    MEMBER PROCEDURE deleteligneticket (
           ligneticket REF ligneticket_t
       ),
    MEMBER PROCEDURE updateligneticket (
           ligneticket1 REF ligneticket_t,
           ligneticket2 REF ligneticket_t
       )
) NOT FINAL;
/

CREATE OR REPLACE TYPE factureemise_t UNDER ticket_t (
    client     REF client_t,
    datelimite DATE,
    --ceci est un boolean
    payeounon  NUMBER
);
/

CREATE OR REPLACE TYPE facturerecue_t UNDER ticket_t (
    fournisseur REF fournisseur_t,
    datelimite  DATE,
    --ceci est un boolean
    payeounon   NUMBER
);
/

CREATE OR REPLACE TYPE listrefticket_t AS
    TABLE OF REF ticket_t
/

CREATE OR REPLACE TYPE setticket_t AS
    TABLE OF ticket_t
/

CREATE OR REPLACE TYPE article_t AS OBJECT (
    quantite               NUMBER,
    codebarre              VARCHAR2(13),
    nom                    VARCHAR(50),
    prix_achat             NUMBER,
    prix_vente             NUMBER,
    ligne_ticket_avec_this listrefligneticket_t,
    MAP MEMBER FUNCTION comparticle RETURN VARCHAR2,
    MEMBER PROCEDURE add_ligne_ticket (
           ticket REF ligneticket_t
       ),
    MEMBER PROCEDURE delete_ligne_ticket (
           ticket REF ligneticket_t
       ),
    MEMBER PROCEDURE update_ligne_ticket (
           ticket1 REF ligneticket_t,
           ticket2 REF ligneticket_t
       )
);
/

CREATE OR REPLACE TYPE listrefarticle_t AS
    TABLE OF REF article_t
/

CREATE OR REPLACE TYPE empl_t AS OBJECT (
    numsecu     NUMBER,
    nom         VARCHAR2(30),
    prenom      VARCHAR2(30),
    job         VARCHAR2(30),
    adresse     REF adresse_t,
    naissance   DATE,
    embauche    DATE,
    salaire     NUMBER,
    cv          CLOB,
    ticket_emis listrefticket_t,
    ORDER MEMBER FUNCTION compemploye (
           emp IN empl_t
       ) RETURN NUMBER,
    MEMBER PROCEDURE add_ticket_emis (
           ticket REF ticket_t
       ),
    MEMBER PROCEDURE delete_ticket_emis (
           ticket REF ticket_t
       ),
    MEMBER PROCEDURE update_ticket_emis (
           ticket1 REF ticket_t,
           ticket2 REF ticket_t
       )
);
/

CREATE OR REPLACE TYPE setarticle_t AS
    TABLE OF article_t
/

CREATE OR REPLACE TYPE fournisseur_t AS OBJECT (
    siret            NUMBER,
    nom              VARCHAR2(30),
    prenom           VARCHAR2(30),
    adresse          REF adresse_t,
    naissance        DATE,
    facture_du_fourn listrefticket_t,
    MAP MEMBER FUNCTION compfournisseur RETURN VARCHAR2,
    MEMBER FUNCTION get_factures_a_payer RETURN listrefticket_t,
    MEMBER FUNCTION get_catalogue RETURN listrefarticle_t,
    MEMBER PROCEDURE add_facture (
           facture REF ticket_t
       ),
    MEMBER PROCEDURE delete_facture (
           facture REF ticket_t
       ),
    MEMBER PROCEDURE update_facture (
           facture1 REF ticket_t,
           facture2 REF ticket_t
       )
);
/

--envoyer au client un mail de joyeux anniversaire
CREATE OR REPLACE TYPE client_t AS OBJECT (
    id                NUMBER,
    nom               VARCHAR2(30),
    prenom            VARCHAR2(30),
    adresse           REF adresse_t,
    naissance         DATE,
    carte             REF carte_t,
    facture_du_client listrefticket_t,
    MAP MEMBER FUNCTION compclient RETURN VARCHAR2,
    MEMBER FUNCTION get_factures_a_encaisser RETURN listrefticket_t,
    MEMBER PROCEDURE add_facture (
           facture REF ticket_t
       ),
    MEMBER PROCEDURE delete_facture (
           facture REF ticket_t
       ),
    MEMBER PROCEDURE update_facture (
           facture1 REF ticket_t,
           facture2 REF ticket_t
       )
);
/

CREATE OR REPLACE TYPE listrefclients_t AS
    TABLE OF REF client_t
/

CREATE OR REPLACE TYPE carte_t AS OBJECT (
    nom     VARCHAR2(30),
    remise  NUMBER,
    clients listrefclients_t,
    MAP MEMBER FUNCTION compcarte RETURN NUMBER,
    MEMBER PROCEDURE addclient (
           client REF client_t
       ),
    MEMBER PROCEDURE deleteclient (
           client REF client_t
       ),
    MEMBER PROCEDURE updateclient (
           client1 REF client_t,
           client2 REF client_t
       )
);
/

CREATE OR REPLACE TYPE setfacturerecue_t AS
    TABLE OF facturerecue_t
/

CREATE OR REPLACE TYPE setfactureemise_t AS
    TABLE OF factureemise_t
/

create or replace type listrefempl_t as table of ref empl_t;


alter type empl_t add static function get_empl_qui_a_apporte_les_plus_dargent return empl_t cascade;
alter type empl_t add member function get_la_plus_chere_facture_emise return ticket_t cascade;

/**/
/*
	2.2.1 LES TABLES
*/
/*
DROP TABLE empl_o;

DROP TABLE client_o;

DROP TABLE carte_o;

DROP TABLE fournisseur_o;

DROP TABLE adresse_o;

DROP TABLE article_o;

DROP TABLE ticket_o;

DROP TABLE ligneticket_o;
/**/
CREATE TABLE empl_o OF empl_t (
    CONSTRAINT pk_empl_o_numsecu PRIMARY KEY ( numsecu ),
    --CONSTRAINT chk_empl_o_numsecu CHECK ( numsecu BETWEEN power(10, 13) AND power(10, 14) - 1 ),
    --TODO? gerer les differents types de cartes de secu
    CONSTRAINT nnl_empl_o_nom CHECK ( nom IS NOT NULL ),
    CONSTRAINT nnl_empl_o_job CHECK ( job IS NOT NULL ),
    CONSTRAINT chk_empl_o_job CHECK ( job IN ( 'Caissier', 'Polyvalent', 'Responsable', 'Directeur' ) ),
    CONSTRAINT nnl_empl_o_salaire CHECK ( salaire IS NOT NULL ),
    CONSTRAINT chk_empl_o_salaire CHECK ( salaire BETWEEN 1500 AND 15000 ),
    CONSTRAINT nnl_empl_o_naissance CHECK ( naissance IS NOT NULL ),
    CONSTRAINT nnl_empl_o_embauche CHECK ( embauche IS NOT NULL ),
    CONSTRAINT chk_empl_o_embauche CHECK ( embauche > naissance ),
    CONSTRAINT nnl_empl_o_ticket_emis CHECK ( ticket_emis IS NOT NULL )
)
NESTED TABLE ticket_emis STORE AS tablelistrefticketemis;
/

CREATE TABLE client_o OF client_t (
    CONSTRAINT pk_client_o_id PRIMARY KEY ( id ),
    CONSTRAINT nnl_client_o_nom CHECK ( nom IS NOT NULL ),
    CONSTRAINT nnl_client_o_facture_du_client CHECK ( facture_du_client IS NOT NULL ),
    CONSTRAINT nnl_client_o_adresse CHECK ( adresse IS NOT NULL )
)
NESTED TABLE facture_du_client STORE AS listrefticket_du_client;
/

CREATE TABLE carte_o OF carte_t (
    CONSTRAINT pk_carte_o_nom PRIMARY KEY ( nom ),
    CONSTRAINT chk_carte_o_nom CHECK ( nom IN ( 'bronze', 'silver', 'gold', 'platinum', 'diamond',
                                                'VIP', 'VIP+' ) ),
    CONSTRAINT nnl_carte_o_remise CHECK ( remise IS NOT NULL ),
    CONSTRAINT chk_carte_o_remise CHECK ( remise BETWEEN 0.01 AND 0.95 ),
    CONSTRAINT nnl_carte_o_clients CHECK ( clients IS NOT NULL )
)
NESTED TABLE clients STORE AS tablelistrefclients;
/

CREATE TABLE fournisseur_o OF fournisseur_t (
    CONSTRAINT pk_fournisseur_o_siret PRIMARY KEY ( siret ),
    CONSTRAINT nnl_fournisseur_o_facture_du_fourn CHECK ( facture_du_fourn IS NOT NULL ),
    CONSTRAINT nnl_adresse CHECK ( adresse IS NOT NULL )
)
NESTED TABLE facture_du_fourn STORE AS tablelistref_facture_du_fourn;
/

CREATE TABLE adresse_o OF adresse_t (
    CONSTRAINT pk_adresse_o PRIMARY KEY ( codepostal,
                                          rue,
                                          numero,
                                          pays,
                                          ville )
)
/

CREATE TABLE article_o OF article_t (
    CONSTRAINT pk_article_o_codebarre PRIMARY KEY ( codebarre ),
    CONSTRAINT chk_article_o_quantite CHECK ( quantite >= 0 ),
    CONSTRAINT nnl_article_o_quantite CHECK ( quantite IS NOT NULL ),
    CONSTRAINT nnl_article_o_nom CHECK ( nom IS NOT NULL ),
    CONSTRAINT nnl_article_o_prix_achat CHECK ( prix_achat IS NOT NULL ),
    CONSTRAINT nnl_article_o_prix_vente CHECK ( prix_vente IS NOT NULL ),
    CONSTRAINT chk_article_o_prix_vente CHECK ( prix_vente >= prix_achat ),
    CONSTRAINT nnl_article_o_ligne_ticket_avec_this CHECK ( ligne_ticket_avec_this IS NOT NULL )
)
NESTED TABLE ligne_ticket_avec_this STORE AS listref_facture_avec_this;
/

CREATE TABLE ligneticket_o OF ligneticket_t (
    CONSTRAINT pk_ligneticket PRIMARY KEY ( numeroligne ),
    CONSTRAINT chk_ligneticket_o_quantite CHECK ( quantite > 0 ),
    CONSTRAINT nnl_ligneticket_o_quantite CHECK ( quantite IS NOT NULL ),
    CONSTRAINT nnl_ligneticket_o_article CHECK ( article IS NOT NULL ),
    CONSTRAINT nnl_ligneticket_o_parentticket CHECK ( parentticket IS NOT NULL )
);
/

CREATE TABLE ticket_o OF ticket_t (
    CONSTRAINT pk_ticket_o_id PRIMARY KEY ( id ),
    CONSTRAINT chk_ticket_o_estvente CHECK ( estvente BETWEEN 0 AND 1 ),
    CONSTRAINT nnl_ticket_o_ligneticket CHECK ( ligneticket IS NOT NULL ),
    --possible d'avoir un ticket avc une table vide d'article
    CONSTRAINT nnl_ticket_o_paiement CHECK ( paiement IS NOT NULL ),
    CONSTRAINT chk_ticket_o_paiement CHECK ( paiement IN ( 'espece', 'cb', 'cheque', 'autre' ) ),
--    CONSTRAINT nnl_ticket_o_employeemmetteur CHECK ( employeemmetteur IS NOT NULL ),
    CONSTRAINT nnl_ticket_o_dateemission CHECK ( dateemission IS NOT NULL )
    --ajout des contraintes des factures emises
--    CONSTRAINT nnl_factureemise_o_client CHECK ( TREAT(object_value AS factureemise_t).client IS NOT NULL ),
--    CONSTRAINT nnl_factureemise_o_datelimite CHECK ( TREAT(object_value AS factureemise_t).datelimite IS NOT NULL ),
--    CONSTRAINT nnl_factureemise_o_payeounon CHECK ( TREAT(object_value AS factureemise_t).payeounon IS NOT NULL ),
--    CONSTRAINT chk_factureemise_o_payeounon CHECK ( TREAT(object_value AS factureemise_t).payeounon IN ( 0, 1 ) ),
    
    --ajout des contraintes des factures recues
--    CONSTRAINT nnl_facturerecue_o_client CHECK ( TREAT(object_value AS facturerecue_t).fournisseur IS NOT NULL ),
--    CONSTRAINT nnl_facturerecue_o_datelimite CHECK ( TREAT(object_value AS facturerecue_t).datelimite IS NOT NULL ),
--    CONSTRAINT nnl_facturerecue_o_payeounon CHECK ( TREAT(object_value AS facturerecue_t).payeounon IS NOT NULL ),
--    CONSTRAINT chk_facturerecue_o_payeounon CHECK ( TREAT(object_value AS facturerecue_t).payeounon IN ( 0, 1 ) )
)
NESTED TABLE ligneticket STORE AS tablelistrefticketarticles;
/
/*
	2.2.2 LES INDEX
*/
drop index ligneticket_o_article;
drop index ligneticket_o_parentticket;
drop index idx_tablelistrefclients_nested_table_id_column_value;
drop index empl_o_adresse;
drop index idx_tablelistrefticketarticles_nested_table_id_column_value;
drop index idx_ticket_o_employeemmetteur;
drop index idx_ticket_o_carte_reduction;
drop index client_o_adresse;
drop index idx_client_o_carte;
drop index idx_fournisseur_o_adresse;
drop index idx_tablelistrefticketemis_nested_table_id_column_value;

ALTER TABLE ligneticket_o ADD (SCOPE FOR ( article ) IS article_o);
CREATE INDEX ligneticket_o_article
ON ligneticket_o(article);

ALTER TABLE ligneticket_o ADD (SCOPE FOR ( parentticket ) IS ticket_o);
CREATE INDEX ligneticket_o_parentticket
ON ligneticket_o(parentticket);

ALTER TABLE tablelistrefclients ADD (SCOPE FOR ( column_value ) IS client_o);
CREATE UNIQUE INDEX idx_tablelistrefclients_nested_table_id_column_value
ON tablelistrefclients (nested_table_id, column_value);

ALTER TABLE empl_o ADD (SCOPE FOR ( adresse ) IS adresse_o);
CREATE INDEX empl_o_adresse
ON empl_o(adresse);

ALTER TABLE tablelistrefticketarticles ADD (SCOPE FOR ( column_value ) IS ligneticket_o);
CREATE UNIQUE INDEX idx_tablelistrefticketarticles_nested_table_id_column_value
ON tablelistrefticketarticles (nested_table_id, column_value);

ALTER TABLE ticket_o ADD (SCOPE FOR ( employeemmetteur ) IS empl_o);
CREATE INDEX idx_ticket_o_employeemmetteur
ON ticket_o(employeemmetteur);

ALTER TABLE ticket_o ADD (SCOPE FOR ( carte_reduction ) IS carte_o);
CREATE INDEX idx_ticket_o_carte_reduction
ON ticket_o(carte_reduction);

--factureemise_o et facture recue_o n'existe pas! :(

/*ALTER TABLE factureemise_o ADD (SCOPE FOR ( client ) IS client_o);
CREATE INDEX idx_factureemise_o_client
ON factureemise_o(client);

ALTER TABLE facturerecue_o ADD (SCOPE FOR ( fournisseur ) IS fournisseur_o);
CREATE INDEX idx_facturerecue_o_fournisseur
ON facturerecue_o(fournisseur);*/


ALTER TABLE client_o ADD (SCOPE FOR ( adresse ) IS adresse_o);
CREATE INDEX client_o_adresse
ON client_o(adresse);

ALTER TABLE client_o ADD (SCOPE FOR ( carte ) IS carte_o);
CREATE INDEX idx_client_o_carte
ON client_o(carte);

ALTER TABLE fournisseur_o ADD (SCOPE FOR ( adresse ) IS adresse_o);
CREATE INDEX idx_fournisseur_o_adresse
ON fournisseur_o(adresse);

ALTER TABLE tablelistrefticketemis ADD (SCOPE FOR ( column_value ) IS ticket_o);
CREATE UNIQUE INDEX idx_tablelistrefticketemis_nested_table_id_column_value
ON tablelistrefticketemis (nested_table_id, column_value);
/*
	2.X LES TRIGGERS
*/
CREATE OR REPLACE TRIGGER update_stock_quantity BEFORE
    INSERT OR UPDATE ON ligneticket_o
    FOR EACH ROW
DECLARE
    article      article_t;
    parentticket ticket_t;
    ligneticket  REF ligneticket_t;
BEGIN
    SELECT
        deref(:new.article)
    INTO article
    FROM
        dual;

    SELECT
        deref(:new.parentticket)
    INTO parentticket
    FROM
        dual;

    IF updating THEN
        BEGIN
            IF parentticket.estvente = 0 THEN
                article.quantite := article.quantite - :old.quantite;
                UPDATE article_o
                SET
                    quantite = quantite - :old.quantite
                WHERE
                    codebarre = article.codebarre;

            ELSE
                article.quantite := article.quantite + :old.quantite;
                UPDATE article_o
                SET
                    quantite = quantite + :old.quantite
                WHERE
                    codebarre = article.codebarre;

            END IF;

        END;
    END IF;

    IF parentticket.estvente = 0 THEN
        IF article.quantite + :new.quantite < 0 THEN
            raise_application_error(-20001, 'On ne peut pas modifier cette ligne de code, car sinon on aurait vendu plus de ce qu''on aurait achété');
        END IF;

        UPDATE article_o
        SET
            quantite = quantite + :new.quantite
        WHERE
            codebarre = article.codebarre;

    ELSIF article.quantite < :new.quantite THEN
        raise_application_error(-20001, 'The quantity of article '
                                        || article.nom
                                        || ' in line no '
                                        || :new.numeroligne
                                        || ' of ticket '
                                        || parentticket.id
                                        || ' is not available in stock');
    ELSE
        UPDATE article_o
        SET
            quantite = quantite - :new.quantite
        WHERE
            codebarre = article.codebarre;

    END IF;

END;
/
-- on peut supprimer un client que s'il ne possède pas de facture de moins de 10 ans
CREATE OR REPLACE TRIGGER delete_facture_checker BEFORE
    DELETE ON ticket_o
    FOR EACH ROW
DECLARE
    client_id NUMBER := :old.id;
    today     DATE;
BEGIN
    SELECT
        sysdate
    INTO today
    FROM
        dual;

    IF today - :old.dateemission <= 3650 THEN
        raise_application_error(-20001, 'On ne peut pas supprimer ce client parce que il y a une facture emise le '
                                        || :old.dateemission);

    END IF;

END;
/
/*
	2.5 LES INMPLEMENTATIONS DES METHODES
*/
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

    MEMBER PROCEDURE add_ligne_ticket (
        ticket REF ligneticket_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.ligne_ticket_avec_this
            FROM
                article_o ot
            WHERE
                ot.codebarre = self.codebarre
        ) VALUES ( ticket );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE delete_ligne_ticket (
        ticket REF ligneticket_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.ligne_ticket_avec_this
            FROM
                article_o ot
            WHERE
                ot.codebarre = self.codebarre
        ) le
        WHERE
            le.column_value = ticket;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE update_ligne_ticket (
        ticket1 REF ligneticket_t,
        ticket2 REF ligneticket_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.ligne_ticket_avec_this
            FROM
                article_o ot
            WHERE
                ot.codebarre = self.codebarre
        ) le
        SET
            le.column_value = ticket2
        WHERE
            le.column_value = ticket1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
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

    MEMBER FUNCTION get_factures_a_encaisser RETURN listrefticket_t IS
        res listrefticket_t;
    BEGIN
        SELECT
            CAST(COLLECT(value(t)) AS listrefticket_t)
        INTO res
        FROM
            TABLE (
                SELECT
                    self.facture_du_client
                FROM
                    dual
            ) t
        WHERE
            TREAT(deref(t.column_value) AS factureemise_t).payeounon = 0;

        RETURN res;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE add_facture (
        facture REF ticket_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.facture_du_client
            FROM
                client_o ot
            WHERE
                ot.id = self.id
        ) VALUES ( facture );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE delete_facture (
        facture REF ticket_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.facture_du_client
            FROM
                client_o ot
            WHERE
                ot.id = self.id
        ) le
        WHERE
            le.column_value = facture;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE update_facture (
        facture1 REF ticket_t,
        facture2 REF ticket_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.facture_du_client
            FROM
                client_o ot
            WHERE
                ot.id = self.id
        ) le
        SET
            le.column_value = facture2
        WHERE
            le.column_value = facture1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

END;
/

CREATE OR REPLACE TYPE BODY carte_t AS
    MAP MEMBER FUNCTION compcarte RETURN NUMBER IS
    BEGIN
        RETURN remise;
    END;

    MEMBER PROCEDURE addclient (
        client REF client_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.clients
            FROM
                carte_o ot
            WHERE
                ot.nom = self.nom
        ) VALUES ( client );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE deleteclient (
        client REF client_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.clients
            FROM
                carte_o ot
            WHERE
                ot.nom = self.nom
        ) le
        WHERE
            le.column_value = client;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE updateclient (
        client1 REF client_t,
        client2 REF client_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.clients
            FROM
                carte_o ot
            WHERE
                ot.nom = self.nom
        ) le
        SET
            le.column_value = client2
        WHERE
            le.column_value = client1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
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

    MEMBER FUNCTION get_factures_a_payer RETURN listrefticket_t IS
        res listrefticket_t;
    BEGIN
        SELECT
            CAST(COLLECT(value(t)) AS listrefticket_t)
        INTO res
        FROM
            TABLE (
                SELECT
                    self.facture_du_fourn
                FROM
                    dual
            ) t
        WHERE
            TREAT(deref(t.column_value) AS facturerecue_t).payeounon = 0;

        RETURN res;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE add_facture (
        facture REF ticket_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.facture_du_fourn
            FROM
                fournisseur_o ot
            WHERE
                ot.siret = self.siret
        ) VALUES ( facture );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE delete_facture (
        facture REF ticket_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.facture_du_fourn
            FROM
                fournisseur_o ot
            WHERE
                ot.siret = self.siret
        ) le
        WHERE
            le.column_value = facture;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE update_facture (
        facture1 REF ticket_t,
        facture2 REF ticket_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.facture_du_fourn
            FROM
                fournisseur_o ot
            WHERE
                ot.siret = self.siret
        ) le
        SET
            le.column_value = facture2
        WHERE
            le.column_value = facture1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER FUNCTION get_catalogue RETURN listrefarticle_t IS
        x listrefarticle_t;
    BEGIN
        SELECT
            CAST(COLLECT(article) AS listrefarticle_t)
        INTO x
        FROM
            ligneticket_o
        WHERE
            deref(TREAT(deref(parentticket) AS facturerecue_t).fournisseur).siret = 1234;

        RETURN x;
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

    MEMBER PROCEDURE add_ticket_emis (
        ticket REF ticket_t
    ) IS
    BEGIN
        INSERT INTO TABLE (
            SELECT
                ot.ticket_emis
            FROM
                empl_o ot
            WHERE
                ot.numsecu = self.numsecu
        ) VALUES ( ticket );

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE delete_ticket_emis (
        ticket REF ticket_t
    ) IS
    BEGIN
        DELETE FROM TABLE (
            SELECT
                ot.ticket_emis
            FROM
                empl_o ot
            WHERE
                ot.numsecu = self.numsecu
        ) le
        WHERE
            le.column_value = ticket;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    MEMBER PROCEDURE update_ticket_emis (
        ticket1 REF ticket_t,
        ticket2 REF ticket_t
    ) IS
    BEGIN
        UPDATE TABLE (
            SELECT
                ot.ticket_emis
            FROM
                empl_o ot
            WHERE
                ot.numsecu = self.numsecu
        ) le
        SET
            le.column_value = ticket2
        WHERE
            le.column_value = ticket1;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END;

    STATIC FUNCTION get_empl_qui_a_apporte_les_plus_dargent RETURN empl_t IS
        emp empl_t;
    BEGIN
        SELECT
            deref(employeemmetteur)
        INTO emp
        FROM
            ticket_o
        WHERE
            employeemmetteur IS NOT NULL
            AND ROWNUM = 1
        GROUP BY
            deref(employeemmetteur)
        ORDER BY
            COUNT(*) DESC;

        RETURN emp;
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
/*
	2.3 LES INSERT
*/
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
        'Champs ElysÃ©s',
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
    INSERT INTO ticket_o fe1 VALUES ( factureemise_t(12, 1, listrefligneticket_t(), 'autre', employe2,
                                                     carte2, TO_DATE('25-12-2010', 'DD-MM-YYYY'), client2, TO_DATE('31-12-2010',
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
               'DD-MM-YYYY'), 0) ) RETURNING ref(fe1) INTO fact_emise4ref;

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
    /**/
END;
/

COMMIT;
/**/
/*
	2.4 LES REQUETES
*/
SET SERVEROUTPUT OFF;

-- Requetes de consultations
-- 5 requetes impliquant 1 table dont 1 avec un group By et une avec un Order By

-- Les cartes dont la remise est >= a 0.2
SELECT
    oc.nom
FROM
    carte_o oc
WHERE
    oc.remise >= 0.2;

-- Articles dont il en reste plus de 3 et qui coutent 50 euros ou moins
SELECT
    nom
FROM
    article_o
WHERE
        quantite > 3
    AND prix_vente <= 50;

-- Nom et prenom de chaque fournisseur
SELECT
    nom,
    prenom
FROM
    fournisseur_o;

    
-- Requete avec regroupement sur les jobs
SELECT
    job,
    SUM(salaire)
FROM
    empl_o oe
GROUP BY
    job;

-- Requete avec tri utilisant notre methode map
SELECT
    oa.pays,
    oa.ville
FROM
    adresse_o oa
WHERE
    oa.numero = 17000
    OR oa.numero = 19000
    OR oa.numero = 12
ORDER BY
    value(oa);
    
-- La date limite de toutes les factures recues
SELECT
    TREAT(value(ot) AS facturerecue_t).datelimite AS datelimite
FROM
    ticket_o ot
WHERE
    value(ot) IS OF ( facturerecue_t );

-- 5 requetes impliquant 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri
--SELECT *
--FROM
--         empl_o oe
--    INNER JOIN adresse_o oa ON oe.adresse = oa;

-- 5 requetes impliquant plus de 2 tables avec jointures internes dont 1 externe + 1 group by + 1 tri

-- Fournisseur dont les factures que nous avons recues ont ete toutes payees
SELECT
    o.siret AS siret
FROM
    fournisseur_o o
    LEFT JOIN (
        SELECT
            deref(TREAT(deref(t.column_value) AS facturerecue_t).fournisseur).siret AS ss
        FROM
            TABLE (
                SELECT
                    b.get_factures_a_payer()
                FROM
                    fournisseur_o b
                WHERE
                    b.siret = 1234
            ) t
    ) ON o.siret = ss
WHERE
    ss IS NULL;

-- Requetes de mise a jour
-- 2 requetes impliquant 1 table

    -- mdofication de la quantite de la ligne d'un ticket
    -- le trigger mets a jour les quantite sur l'article tout
    -- en verifiant qu'il n'y ait pas des probleme de manquement 
    -- dans le stock
UPDATE ligneticket_o
SET
    quantite = 5
WHERE
    numeroligne = 2;
    
    -- les employes qui travaillent depuis le 15/10/2000 recoivent
    -- un augmentation de salaire
UPDATE empl_o
SET
    salaire = salaire + 1000
WHERE
    embauche > TO_DATE('15-10-2000', 'DD-MM-YYYY');

-- 2 requetes impliquant 2 tables

    -- les employï¿½s qui n'habitent pas ï¿½ Nice recoivent
    -- 10 euro de salaire en plus pour payer l'essance
UPDATE empl_o
SET
    salaire = salaire + 10
WHERE
    deref(adresse).ville != 'Nice';

    -- les employï¿½s qui ont ï¿½mis plus de 500 euro de ticket,
    -- recoivent un bonus de 50 euro dans leur salaire
UPDATE empl_o
SET
    salaire = salaire + 50
WHERE
    numsecu IN (
        SELECT
            deref(employeemmetteur).numsecu
        FROM
            ticket_o t
        WHERE
            t.gettotal() > 500
    );

-- 2 requetes impliquant plus de 2 tables

    -- tous les articles dans le catalogue du fournisseur 1234
    -- subissent 2% d'augmentation de prix
UPDATE article_o art
SET
    art.prix_vente = art.prix_vente * 1.02
WHERE
    codebarre IN (
        SELECT
            lre.column_value.codebarre
        FROM
            TABLE (
                SELECT
                    f.get_catalogue()
                FROM
                    fournisseur_o f
                WHERE
                    siret = 1234
            ) lre
    );
    
    -- tous les articles prï¿½sents dans la facture d'achat 1
    -- subissent une reduction du prix de vente du 5%
UPDATE article_o art
SET
    art.prix_vente = art.prix_vente * 0.95
WHERE
    codebarre IN (
        SELECT
            lre.column_value.article.codebarre
        FROM
            TABLE (
                SELECT
                    ligneticket
                FROM
                    ticket_o
                WHERE
                    id = 1
            ) lre
    );
    


-- Requetes de suppression 
-- 2 requetes impliquant 1 table

-- ici on sait que le client 7 n'a ni de carte ni de facture
DELETE FROM client_o
WHERE
    id = 7;

-- ici on sait que ces cartes ne sont affectees a aucun client
DELETE FROM carte_o
WHERE
    remise > 0.35;

-- 2 requetes impliquant 2 tables

-- on supprime un carte et supprime le pointeur des clients vers celle-ci
DELETE FROM carte_o
WHERE
    nom = 'gold';

UPDATE client_o clt
SET
    clt.carte = NULL
WHERE
    carte IS DANGLING;

-- suppression d'un employe et ses tickets emis

DELETE FROM empl_o
WHERE numsecu = 1111111111112;

DELETE FROM ticket_o
WHERE employeemmetteur IS DANGLING;

-- 2 requetes impliquant plus de 2 tables

-- on supprime le client 1 qui a une carte et sur lequel on a emis une facture
-- 1. on met ï¿½ jour donc listrefclients_t dans la carte du client 1
-- 2. on supprime les factures emises sur ce client
-- (Attention au trigger delete_facture_checker car on ne peut pas supprimer des factures de moins de 10 ans)
DECLARE
    ref_client REF client_t;
    carte      carte_t;
    ref_fact_e setfactureemise_t;
    client_id  NUMBER := 1;
BEGIN
    SELECT
        deref(v.carte),
        ref(v)
    INTO
        carte,
        ref_client
    FROM
        client_o v
    WHERE
        v.id = client_id;

    carte.deleteclient(ref_client);
    DELETE FROM client_o c
    WHERE
        id = 1;

    SELECT
        CAST(COLLECT(TREAT(value(t) AS factureemise_t)) AS setfactureemise_t)
    INTO ref_fact_e
    FROM
        ticket_o t
    WHERE
        TREAT(value(t) AS factureemise_t).client IS
dangling;

FOR i IN ref_fact_e.first..ref_fact_e.last LOOP
    DELETE FROM ticket_o t
    WHERE
        value(t) = ref_fact_e(i);

END LOOP;

end;
/

ROLLBACK;
-- Here code
/*
	2.X OTHER
*/
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
