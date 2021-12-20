DROP TRIGGER update_stock_quantity;

CREATE OR REPLACE TRIGGER update_stock_quantity BEFORE
    INSERT OR UPDATE ON ligneticket_o
    FOR EACH ROW
DECLARE
    article      article_t;
    parentticket ticket_t;
    ligneticket  REF ligneticket_t;
    quantite_exception EXCEPTION;
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

    IF parentticket.estvente = 0 THEN
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