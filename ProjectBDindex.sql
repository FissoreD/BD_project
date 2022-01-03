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