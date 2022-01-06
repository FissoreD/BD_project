package sql3;

import java.sql.*;

public class Client implements SQLData {

    private String sql_type;
    private int id;
    private String nom;
    private String prenom;
    private Ref refAdresse;
    private Date naissance;
    private Ref refCarte;
    private Array factureClient;

    public Client(){}

    public Client(String sql_type, int id, String nom, String prenom, Ref refAdresse, Date naissance, Ref refCarte, Array factureClient){
        this.sql_type = sql_type;
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.refAdresse = refAdresse;
        this.naissance = naissance;
        this.refCarte = refCarte;
        this.factureClient = factureClient;
    }
    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Ref getRefAdresse() {
        return refAdresse;
    }

    public void setRefAdresse(Ref refAdresse) {
        this.refAdresse = refAdresse;
    }

    public Date getNaissance() {
        return naissance;
    }

    public void setNaissance(Date naissance) {
        this.naissance = naissance;
    }

    public Ref getRefCarte() {
        return refCarte;
    }

    public void setRefCarte(Ref refCarte) {
        this.refCarte = refCarte;
    }

    public Array getFactureClient() { return factureClient; }

    public void setFactureClient(Array factureClient) { this.factureClient = factureClient; }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.id = stream.readInt();
        this.nom = stream.readString();
        this.prenom = stream.readString();
        setRefAdresse((Ref) stream.readRef());
        this.naissance = stream.readDate();
        setRefCarte((Ref) stream.readRef());
        this.factureClient = stream.readArray();

    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeString(nom);
        stream.writeString(prenom);
        stream.writeRef(refAdresse);
        stream.writeDate(naissance);
        stream.writeRef(refCarte);
        stream.writeArray(factureClient);

    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         id = %d
                         nom = %s
                         prenom = %s
                         adresse = %s
                         naissance =  %s
                         carte = %s
                        }
                        """, id, nom, prenom, displayInfoAdresseClientFromRef() , getNaissance(), displayInfoCarteClientFromRef());
    }

    public String displayInfoAdresseClientFromRef() throws SQLException {
        Ref refAdresse1 = this.getRefAdresse();
        Adresse adresse1 = (Adresse) refAdresse1.getObject(Main.getMapOraObjType());
        return adresse1.toString();
    }

    public String displayInfoCarteClientFromRef() throws SQLException {
        String carte_type = "Ce client n'a pas de carte";
        if (refCarte != null) {
            Ref refCarte1 = this.getRefCarte();
            Carte carte1 = (Carte) refCarte1.getObject(Main.getMapOraObjType());
            carte_type = carte1.getNom();
        }
        return carte_type;
    }

    public void displayInfoAllFactures() throws SQLException {
        // affichage des factures du client
        Ref[] refFacts = (Ref[]) this.getFactureClient().getArray();
        System.out.println("<Factures:");
        for (Ref refFact : refFacts) {
            FactureEmise fr1 = (FactureEmise) refFact.getObject(Main.getMapOraObjType());
            System.out.println("   [idFacture=" + fr1.getId() + " dateEmmission=" + fr1.getDateemission() + " dateLimite=" + fr1.getDatelimite() + "]");

        }
        System.out.println(">");
    }

    @Override
    public String toString() {
        return "Client{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                '}';
    }
}
