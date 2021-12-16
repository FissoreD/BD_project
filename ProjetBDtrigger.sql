drop trigger update_stock_quantity;

CREATE OR REPLACE TRIGGER update_stock_quantity
BEFORE INSERT OR UPDATE on ligneticket_o
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
declare
    article article_t;
BEGIN
    select deref(:new.article) into article from dual;
    update article_o set quantite = quantite + :new.quantite where codebarre = article.codebarre ;
end;
/
