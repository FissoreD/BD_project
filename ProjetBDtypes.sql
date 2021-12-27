DROP TABLE empl_o;

DROP TABLE client_o;

DROP TABLE carte_o;

DROP TABLE fournisseur_o;

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

DROP TYPE listrefarticles_t FORCE;

DROP TYPE carte_t FORCE;

DROP TYPE setfacturerecue_t FORCE;

DROP TYPE setfactureemise_t FORCE;

DROP TYPE listrefligneticket_t FORCE;

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

CREATE OR REPLACE TYPE adresse_t AS OBJECT (
    pays       VARCHAR2(30),
    ville      VARCHAR2(60),
    codepostal VARCHAR2(5),
    rue        VARCHAR2(100),
    numero     NUMBER,
    MAP MEMBER FUNCTION compadresse RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE article_t AS OBJECT (
    quantite  NUMBER,
    codebarre VARCHAR2(13),
    nom       VARCHAR(50),
    prix      NUMBER,
    achat     REF facturerecue_t,
    MAP MEMBER FUNCTION comparticle RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE setarticle_t AS
    TABLE OF article_t
/

CREATE OR REPLACE TYPE ligneticket_t AS OBJECT (
    numeroligne  NUMBER,
    quantite     NUMBER,
    article      REF article_t,
    parentticket REF ticket_t,
    MAP MEMBER FUNCTION comparligneticket RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE setligneticket_t AS
    TABLE OF ligneticket_t;
/

CREATE OR REPLACE TYPE listrefclients_t AS
    TABLE OF REF client_t
/

CREATE OR REPLACE TYPE carte_t AS OBJECT (
    nom     VARCHAR2(30),
    remise  NUMBER,
    clients listrefclients_t,
    MAP MEMBER FUNCTION compcarte RETURN NUMBER
);
/

CREATE OR REPLACE TYPE listrefligneticket_t AS
    TABLE OF REF ligneticket_t
/

CREATE OR REPLACE TYPE listrefarticles_t AS
    TABLE OF REF article_t
/

CREATE OR REPLACE TYPE empl_t AS OBJECT (
    numsecu   NUMBER,
    nom       VARCHAR2(30),
    prenom    VARCHAR2(30),
    job       VARCHAR2(30),
    adresse   REF adresse_t,
    naissance DATE,
    embauche  DATE,
    salaire   NUMBER,
    cv        CLOB,
    ORDER MEMBER FUNCTION compemploye (
           emp IN empl_t
       ) RETURN NUMBER
);
/

CREATE OR REPLACE TYPE ticket_t AS OBJECT (
    -- ceci est un boolean
    id               NUMBER,
    estvente         NUMBER,
    ligneticket      listrefligneticket_t,
    paiement         VARCHAR2(30),
    employeemmetteur REF empl_t,
    dateemission     DATE,
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
    payeounon  NUMBER,
    MEMBER FUNCTION is_valid RETURN BOOLEAN
);
/

CREATE OR REPLACE TYPE facturerecue_t UNDER ticket_t (
    fournisseur REF fournisseur_t,
    datelimite  DATE,
    --ceci est un boolean
    payeounon   NUMBER
);
/

CREATE OR REPLACE TYPE setticket_t AS
    TABLE OF ticket_t
/

CREATE OR REPLACE TYPE setfacturerecue_t AS
    TABLE OF facturerecue_t
/

CREATE OR REPLACE TYPE setfactureemise_t AS
    TABLE OF factureemise_t
/

--envoyer au client un mail de joyeux anniversaire
CREATE OR REPLACE TYPE client_t AS OBJECT (
    id        NUMBER,
    nom       VARCHAR2(30),
    prenom    VARCHAR2(30),
    adresse   REF adresse_t,
    naissance DATE,
    carte     REF carte_t,
    MAP MEMBER FUNCTION compclient RETURN VARCHAR2,
    STATIC FUNCTION get_factures_a_encaisser (
           client_id IN NUMBER
       ) RETURN setticket_t
);
/

CREATE OR REPLACE TYPE fournisseur_t AS OBJECT (
    siret     NUMBER,
    nom       VARCHAR2(30),
    prenom    VARCHAR2(30),
    adresse   REF adresse_t,
    naissance DATE,
    catalogue listrefarticles_t,
    MAP MEMBER FUNCTION compfournisseur RETURN VARCHAR2,
    MEMBER FUNCTION get_factures_a_payer RETURN setticket_t
);
/