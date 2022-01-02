DROP TABLE empl_o;

DROP TABLE client_o;

DROP TABLE carte_o;

DROP TABLE fournisseur_o;

DROP TABLE adresse_o;

DROP TABLE article_o;

DROP TABLE ticket_o;

DROP TABLE ligneticket_o;

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
    CONSTRAINT chk_empl_o_embauche CHECK ( embauche > naissance )
)
/

CREATE TABLE client_o OF client_t (
    CONSTRAINT pk_client_o_id PRIMARY KEY ( id ),
    CONSTRAINT nnl_client_o_nom CHECK ( nom IS NOT NULL )
)
/

CREATE TABLE carte_o OF carte_t (
    CONSTRAINT pk_carte_o_nom PRIMARY KEY ( nom ),
    CONSTRAINT chk_carte_o_nom CHECK ( nom IN ( 'bronze', 'silver', 'gold', 'platinum', 'diamond', 'VIP', 'VIP+' ) ),
    CONSTRAINT nnl_carte_o_remise CHECK ( remise IS NOT NULL ),
    CONSTRAINT chk_carte_o_remise CHECK ( remise BETWEEN 0.01 AND 0.95 )
)
NESTED TABLE clients STORE AS tablelistrefclients;
/

CREATE TABLE fournisseur_o OF fournisseur_t (
    CONSTRAINT pk_fournisseur_o_siret PRIMARY KEY ( siret )
)
NESTED TABLE catalogue STORE AS tablelistreffournisseurarticles;
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
    CONSTRAINT chk_article_o_prix_vente CHECK ( prix_vente >= prix_achat )
)
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