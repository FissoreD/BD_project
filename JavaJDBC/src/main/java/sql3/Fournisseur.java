package sql3;

import java.sql.*;

public class Fournisseur implements SQLData {

    private String sql_type;
    private int siret;
    private String nom;
    private String prenom;
    private Ref adresse;
    private Date naissance;
    private Array factureFourn;

    public Fournisseur(){}

    public Fournisseur(String sql_type, int siret, String nom, String prenom, Ref adresse, Date naissance, Array factureFourn) {
        this.sql_type = sql_type;
        this.siret = siret;
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.naissance = naissance;
        this.factureFourn = factureFourn;
    }

    public int getSiret() {
        return siret;
    }

    public void setSiret(int siret) {
        this.siret = siret;
    }

    public String getNom() {
        return nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public Ref getAdresse() {
        return adresse;
    }

    public void setAdresse(Ref adresse) {
        this.adresse = adresse;
    }

    public Date getNaissance() {
        return naissance;
    }

    public void setNaissance(Date naissance) {
        this.naissance = naissance;
    }

    public Array getFactureFourn() { return factureFourn; }

    public void setFactureFourn(Array factureFourn) { this.factureFourn = factureFourn; }

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.siret = stream.readInt();
        this.nom = stream.readString();
        this.prenom = stream.readString();
        this.adresse = stream.readRef();
        this.naissance = stream.readDate();
        this.factureFourn = stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(siret);
        stream.writeString(nom);
        stream.writeString(prenom);
        stream.writeRef(adresse);
        stream.writeDate(naissance);
        stream.writeArray(factureFourn);
    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         siret = %d
                         nom = %s
                         prenom = %s
                         adresse = %s
                         naissance =  %s
                        }
                        """, siret, nom, prenom, displayInfoAdresseFournisseurFromRef(), naissance);
    }

    public String displayInfoAdresseFournisseurFromRef() throws SQLException {
        Ref refAdresse1 = this.getAdresse();
        Adresse adresse1 = (Adresse) refAdresse1.getObject(Main.getMapOraObjType());
        return adresse1.toString();
    }

    public void displayInfoAllFactures() throws SQLException {
        // affichage des factures du fournisseur
        Ref[] refFacts = (Ref[]) this.getFactureFourn().getArray();
        System.out.println("<Factures:");
        for (Ref refFact : refFacts) {
            FactureRecue fr1 = (FactureRecue) refFact.getObject(Main.getMapOraObjType());
            System.out.println("   [idFacture=" + fr1.getId() + " dateEmmission=" + fr1.getDateemission() + " dateLimite=" + fr1.getDatelimite() + "]");

        }
        System.out.println(">");
    }

    @Override
    public String toString() {
        return "Fournisseur{" +
                "siret=" + siret +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                '}';
    }
}
