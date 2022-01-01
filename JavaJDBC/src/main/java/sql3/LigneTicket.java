package sql3;

import java.sql.*;

public class LigneTicket implements SQLData {
    private String sql_type;
    private int numeroligne;
    private int quantite;
    private Ref article;
    private Ref parentTicket;

    public LigneTicket(){}

    public LigneTicket(String sql_type, int numeroligne, int quantite, Ref article, Ref parentTicket) {
        this.sql_type = sql_type;
        this.numeroligne = numeroligne;
        this.quantite = quantite;
        this.article = article;
        this.parentTicket = parentTicket;
    }

    public int getNumeroligne() {
        return numeroligne;
    }

    public void setNumeroligne(int numeroligne) {
        this.numeroligne = numeroligne;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public Ref getArticle() {
        return article;
    }

    public void setArticle(Ref article) {
        this.article = article;
    }

    public Ref getParentTicket() {
        return parentTicket;
    }

    public void setParentTicket(Ref parentTicket) {
        this.parentTicket = parentTicket;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.numeroligne = stream.readInt();
        this.quantite = stream.readInt();
        this.article = stream.readRef();
        this.parentTicket = stream.readRef();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(numeroligne);
        stream.writeInt(quantite);
        stream.writeRef(article);
        stream.writeRef(parentTicket);
    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         numeroligne = %d
                         quantite = %s
                         article = %s
                        }
                        """, numeroligne, quantite, displayInfoArticleLigneFromRef());
    }

    public String displayInfoArticleLigneFromRef() throws SQLException {
        Ref refArticle1 = this.getArticle();
        Article article1 = (Article) refArticle1.getObject();
        return article1.toString();
    }

    public String displayInfoTicketFromRef() throws SQLException {
        Ref refTicket1= this.getParentTicket();
        Ticket ticket1 = (Ticket) refTicket1.getObject();
        return ticket1.toString();
    }

}
