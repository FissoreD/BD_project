package sql3;

import java.sql.*;

public class Article implements SQLData {

    private String sql_type;
    private int quantite;
    private String codebarre;
    private String nom;
    private float prix_achat;
    private float prix_vente;
    private Ref achat;

    public Article(){}

    public Article(String sql_type, int quantite, String codebarre, String nom, float prix_achat, float prix_vente, Ref achat) {
        this.sql_type = sql_type;
        this.quantite = quantite;
        this.codebarre = codebarre;
        this.nom = nom;
        this.prix_achat = prix_achat;
        this.prix_vente = prix_vente;
        this.achat = achat;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    public String getCodebarre() {
        return codebarre;
    }

    public void setCodebarre(String codebarre) {
        this.codebarre = codebarre;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public float getPrix_achat() {
        return prix_achat;
    }

    public void setPrix_achat(float prix_achat) {
        this.prix_achat = prix_achat;
    }

    public float getPrix_vente() {
        return prix_vente;
    }

    public void setPrix_vente(float prix_vente) {
        this.prix_vente = prix_vente;
    }

    public Ref getAchat() {
        return achat;
    }

    public void setAchat(Ref achat) {
        this.achat = achat;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.quantite = stream.readInt();
        this.codebarre = stream.readString();
        this.nom = stream.readString();
        this.prix_achat = stream.readFloat();
        this.prix_vente = stream.readFloat();
        this.achat = stream.readRef();

    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(quantite);
        stream.writeString(codebarre);
        stream.writeString(nom);
        stream.writeFloat(prix_achat);
        stream.writeFloat(prix_vente);
        stream.writeRef(achat);
    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         quantite = %d
                         codebarre = %s
                         nom = %s
                         prix_vente = %f
                        }
                        """, quantite, codebarre, nom, prix_vente);
    }

    /*public String displayInfoFactureRecueFromRef() throws SQLException {
        Ref refFacture1 = this.getAchat();
        FactureRecue fr1 = (Adresse) refFacture1.getObject();
        return fr.toString();
    }*/
}
