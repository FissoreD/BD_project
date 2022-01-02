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
            raise_application_error(-20001, 'On ne peut pas modifier cette ligne de code, car sinon on aurait vendu plus de ce qu''on aurait ach�t�');
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
-- on peut supprimer un client que s'il ne poss�de pas de facture de moins de 10 ans
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