package sql3;

import java.sql.*;

public class Fournisseur implements SQLData {

    private String sql_type;
    private int siret;
    private String nom;
    private String prenom;
    private Ref adresse;
    private Date naissance;

    public Fournisseur(){
    }

    public Fournisseur(String sql_type, int siret, String nom, String prenom, Ref adresse, Date naissance) {
        this.sql_type = sql_type;
        this.siret = siret;
        this.nom = nom;
        this.prenom = prenom;
        this.adresse = adresse;
        this.naissance = naissance;
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

    public Date getNaissance() {
        return naissance;
    }

    public Ref getAdresse() {
        return adresse;
    }

    public void setAdresse(Ref adresse) {
        this.adresse = adresse;
    }

    public void setNaissance(Date naissance) {
        this.naissance = naissance;
    }

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
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(siret);
        stream.writeString(nom);
        stream.writeString(prenom);
        stream.writeRef(adresse);
        stream.writeDate(naissance);
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

    @Override
    public String toString() {
        return "Fournisseur{" +
                "siret=" + siret +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                '}';
    }
}
