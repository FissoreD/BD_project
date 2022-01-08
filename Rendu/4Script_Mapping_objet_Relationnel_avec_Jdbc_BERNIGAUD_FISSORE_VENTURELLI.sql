
/*
	The Main.java file
*/
package sql3;

import java.io.IOException;
import java.sql.*;
import java.util.Map;
import java.util.Objects;

public class Main {

    private final static String username = "Fissore1I2122";
    private final static String password = "Fissore1I212201";
    private final static String path = "FISSORE1I2122";
    private final static  String adressIP = "144.21.67.201";
    private final static String serviceName = "pdbm1inf.631174089.oraclecloud.internal";
    private final static int numPort = 1521;
    private final static String username2 = "Venturelli1I2122";
    private final static String password2 = "Venturelli1I212201";
    private final static String path2 = "VENTURELLI1I2122";
    private final static  String adressIP2 = "134.59.152.120";
    private final static String serviceName2 = "pdbm1info.unice.fr";
    private final static int numPort2 = 443;
    private static Map<String, Class<?>> mapOraObjType;
    private static Statement stmt;

    public static void main(String[] argv) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection conn = DriverManager.getConnection(
                    String.format("""
                            jdbc:oracle:thin:@(DESCRIPTION =\r
                                (ADDRESS_LIST =\r
                                  (ADDRESS = (PROTOCOL = TCP)(HOST = %s)(PORT = %d))\r
                                )\r
                                (CONNECT_DATA =\r
                                  (SERVER = DEDICATED)\r
                                  (SERVICE_NAME = %s)\r
                                )\r
                              )""", adressIP, numPort, serviceName),
                    username2, password2);

            stmt = conn.createStatement();

            mapOraObjType = conn.getTypeMap();

            //2 boucles indépendantes nécessaires car on doit construire en entier le dictionnaire avant de faire les requêtes
            //car par exemple pour tester Article on doit connaître LigneTicket
            for (Types t: Types.values()) {
                mapOraObjType.put(t.typePath, Class.forName("sql3." + t.className));
            }

            for (Types t: Types.values()) {
                t.loop();
            }

        } catch (ClassNotFoundException | SQLException | IOException e) {
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }

    }

    public enum Types{
        ADRESSE, CARTE, CLIENT, EMPL, FOURNISSEUR, ARTICLE, LIGNETICKET, TICKET, FACTUREEMISE, FACTURERECUE;
        public final String className = Objects.equals(this.toString(), "LIGNETICKET") ? "LigneTicket" : this.toString().equals("FACTUREEMISE") ? "FactureEmise" : this.toString().equals("FACTURERECUE") ? "FactureRecue" : this.toString().charAt(0) + this.toString().substring(1).toLowerCase();
        public final String typePath = path2 + "." + this + "_T";

        public void loop() throws SQLException, IOException, ClassNotFoundException {

            String query = String.format("SELECT value(c) FROM %s_o c", this);
            if (this == FACTUREEMISE){
                query =  "SELECT value(c) FROM ticket_o c WHERE value(c) IS OF ( factureemise_t )";
            }
            if (this == FACTURERECUE) {
                query =  "SELECT value(c) FROM ticket_o c WHERE value(c) IS OF ( facturerecue_t )";
            }
            if (this == TICKET) {
                query = "SELECT value(c) FROM ticket_o c WHERE NOT value(c) IS OF ( factureemise_t ) AND NOT value(c) IS OF ( facturerecue_t )";
            }
            ResultSet queryResult = stmt.executeQuery(query);

            System.out.printf("*************** INFOS %s ***************%n", this);
            while (queryResult.next())
                switch (this){
                    case CARTE -> ((Carte) queryResult.getObject(1, mapOraObjType)).display();
                    case ADRESSE -> ((Adresse) queryResult.getObject(1, mapOraObjType)).display();
                    case CLIENT -> ((Client) queryResult.getObject(1, mapOraObjType)).display();
                    case ARTICLE -> ((Article) queryResult.getObject(1, mapOraObjType)).display();
                    case EMPL -> ((Empl) queryResult.getObject(1, mapOraObjType)).display();
                    case FOURNISSEUR -> ((Fournisseur) queryResult.getObject(1, mapOraObjType)).display();
                    case TICKET -> ((Ticket) queryResult.getObject(1, mapOraObjType)).display();
                    case LIGNETICKET -> ((LigneTicket) queryResult.getObject(1, mapOraObjType)).display();
                    case FACTUREEMISE -> ((FactureEmise) queryResult.getObject(1, mapOraObjType)).display();
                    case FACTURERECUE -> ((FactureRecue) queryResult.getObject(1, mapOraObjType)).display();
                }
        }
    }

    public static Map<String, Class<?>> getMapOraObjType() {
        return mapOraObjType;
    }
}


/*
	The Adresse.java file
*/
package sql3;

import java.sql.*;

public class Adresse implements SQLData {

    private String sql_type;
    private String pays;
    private String ville;
    private String codepostal;
    private String rue;
    private int numero;

    public Adresse() {}

    public Adresse(String sql_type, String pays, String ville, String codepostal, String rue, int numero) {
        this.sql_type = sql_type;
        this.pays = pays;
        this.ville = ville;
        this.codepostal = codepostal;
        this.rue = rue;
        this.numero = numero;
    }


    /**
     * @return the deptno
     */
    public String getPays() {
        return pays;
    }

    /**
     * @param pays the deptno to set
     */
    public void setPays(String pays) {
        this.pays = pays;
    }

    public String getRue() {
        return rue;
    }

    public void setRue(String rue) {
        this.rue = rue;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    /**
     * @return the dname
     */
    public String getVille() {
        return ville;
    }

    /**
     * @param ville the dname to set
     */
    public void setVille(String ville) {
        this.ville = ville;
    }

    /**
     * @return the loc
     */
    public String getCodepostal() {
        return codepostal;
    }

    /**
     * @param codepostal the loc to set
     */
    public void setCodepostal(String codepostal) {
        this.codepostal = codepostal;
    }


    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    /**
     Lire dans le flot dans l'ordre.

     */
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.pays = stream.readString();
        this.ville = stream.readString();
        this.codepostal = stream.readString();
        this.rue = stream.readString();
        this.numero = stream.readInt();
    }

    /**
        Ecrire dans le flot dans l'ordre.
    */
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeString(pays);
        stream.writeString(ville);
        stream.writeString(codepostal);
        stream.writeString(rue);
        stream.writeInt(numero);
    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         pays = %s
                         ville = %s
                         code postal = %s
                         rue = %s
                         numero = %d
                        }
                        """, pays, ville, codepostal, rue, numero);
    }

    @Override
    public String toString() {
        return String.format(
                "%d, rue %s, %s",
                numero, rue, ville
        );
    }
}


/*
	The Article.java file
*/
package sql3;

import java.sql.*;

public class Article implements SQLData {

    private String sql_type;
    private int quantite;
    private String codebarre;
    private String nom;
    private float prix_achat;
    private float prix_vente;
    private Array ligneTicketAvecThis;

    public Article(){}

    public Article(String sql_type, int quantite, String codebarre, String nom, float prix_achat, float prix_vente, Array ligneTicketAvecThis) {
        this.sql_type = sql_type;
        this.quantite = quantite;
        this.codebarre = codebarre;
        this.nom = nom;
        this.prix_achat = prix_achat;
        this.prix_vente = prix_vente;
        this.ligneTicketAvecThis = ligneTicketAvecThis;
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

    public Array getLigneTicketAvecThis() {
        return ligneTicketAvecThis;
    }

    public void setLigneTicketAvecThis(Array ligneTicketAvecThis) {
        this.ligneTicketAvecThis = ligneTicketAvecThis;
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
        this.ligneTicketAvecThis = stream.readArray();

    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(quantite);
        stream.writeString(codebarre);
        stream.writeString(nom);
        stream.writeFloat(prix_achat);
        stream.writeFloat(prix_vente);
        stream.writeArray(ligneTicketAvecThis);
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

    @Override
    public String toString() {
        return "Article{" +
                "codebarre='" + codebarre + '\'' +
                ", nom='" + nom + '\'' +
                ", prix_vente=" + prix_vente +
                '}';
    }

    public void displayInfoAllLigneTicket() throws SQLException {
        //affichage des lignes des tickets
        Ref[] refLigneTickets = (Ref[]) this.getLigneTicketAvecThis().getArray();
        System.out.println("<Lignes des tickets où est présent l'article:");
        for (Ref refLigneTicket : refLigneTickets) {
            LigneTicket lt1 = (LigneTicket) refLigneTicket.getObject(Main.getMapOraObjType());
            System.out.println(lt1.toString());

        }
        System.out.println(">");
    }
}


/*
	The Carte.java file
*/
package sql3;

import java.sql.*;

public class Carte implements SQLData {
    private String sql_type;
    private String nom;
    private float remise;
    private Array listRefClients;

    public Carte(){}

    public Carte(String sql_type, String nom, float remise, Array listRefClients){
        this.sql_type = sql_type;
        this.nom = nom;
        this.remise = remise;
        this.listRefClients = listRefClients;
    }
    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public float getRemise() {
        return remise;
    }

    public void setRemise(float remise) {
        this.remise = remise;
    }

    public Array getListRefClients() {
        return listRefClients;
    }

    public void setListRefClients(Array listRefClients) {
        this.listRefClients = listRefClients;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.nom = stream.readString();
        this.remise = stream.readFloat();
        this.listRefClients = (Array) stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeString(nom);
        stream.writeFloat(remise);
        stream.writeArray(listRefClients);

    }

    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         nom = %s
                         remise = %f
                        }
                        """, nom, remise);
    }

    public void displayInfoAllClientsCarte() throws SQLException {
        // affichage du nom des clients
        Ref[] refClients = (Ref[]) this.getListRefClients().getArray();
        System.out.println("<Clients:");
        for (Ref clientRef : refClients) {
            Client client1 = (Client) clientRef.getObject(Main.getMapOraObjType());
            System.out.println("   [idClient" + client1.getId() + " nomClient=" + client1.getNom() + "]");

        }
        System.out.println(">");
    }

    @Override
    public String toString() {
        return "Carte{" +
                "nom='" + nom + '\'' +
                ", remise=" + remise +
                '}';
    }
}


/*
	The Client.java file
*/
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


/*
	The Empl.java file
*/
package sql3;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.*;

public class Empl implements SQLData {

    private String sql_type;
    private long numsecu;
    private String nom;
    private String prenom;
    private String job;
    private Ref adresse;
    private Date naissance;
    private Date embauche;
    private float salaire;
    private Clob cv;
    private Array ticketEmis;

    public Empl(){}

    public Empl(String sql_type, long numsecu, String nom, String prenom, String job, Ref adresse, Date naissance, Date embauche, float salaire, Clob cv, Array ticketEmis) {
        this.sql_type = sql_type;
        this.numsecu = numsecu;
        this.nom = nom;
        this.prenom = prenom;
        this.job = job;
        this.adresse = adresse;
        this.naissance = naissance;
        this.embauche = embauche;
        this.salaire = salaire;
        this.cv = cv;
        this.ticketEmis = ticketEmis;
    }

    public long getNumsecu() {
        return numsecu;
    }

    public void setNumsecu(long numsecu) {
        this.numsecu = numsecu;
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

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
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

    public Date getEmbauche() {
        return embauche;
    }

    public void setEmbauche(Date embauche) {
        this.embauche = embauche;
    }

    public float getSalaire() {
        return salaire;
    }

    public void setSalaire(float salaire) {
        this.salaire = salaire;
    }

    public Clob getCv() {
        return cv;
    }

    public void setCv(Clob cv) {
        this.cv = cv;
    }

    public Array getTicketEmis() {
        return ticketEmis;
    }

    public void setTicketEmis(Array ticketEmis) {
        this.ticketEmis = ticketEmis;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.numsecu = stream.readLong();
        this.nom = stream.readString();
        this.prenom = stream.readString();
        this.job = stream.readString();
        this.adresse = stream.readRef();
        this.naissance = stream.readDate();
        this.embauche = stream.readDate();
        this.salaire = stream.readFloat();
        this.cv = stream.readClob();
        this.ticketEmis = stream.readArray();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeLong(numsecu);
        stream.writeString(nom);
        stream.writeString(prenom);
        stream.writeString(job);
        stream.writeRef(adresse);
        stream.writeDate(naissance);
        stream.writeDate(embauche);
        stream.writeFloat(salaire);
        stream.writeClob(cv);
        stream.writeArray(ticketEmis);
    }

    public void display() throws SQLException, IOException {
        System.out.printf(
                """
                        
                        {
                         numsecu = %d
                         nom = %s
                         prenom = %s
                         job = %s
                         adresse = %s
                         naissance =  %s
                         embauche = %s
                         salaire = %f
                         cv = %s
                        }
                        """, numsecu, nom, prenom, job, displayInfoAdresseEmplFromRef(), naissance, embauche, salaire, displayCV());
    }

    public String displayInfoAdresseEmplFromRef() throws SQLException {
        Ref refAdresse1 = this.getAdresse();
        Adresse adresse1 = (Adresse) refAdresse1.getObject(Main.getMapOraObjType());
        return adresse1.toString();
    }

    public String displayCV() throws java.sql.SQLException, java.io.IOException {
        StringBuilder sb = new StringBuilder("");
        sb.append("\n\n[ <CV/ ");
        BufferedReader clobReader;
        if (cv != null) {
            clobReader = new BufferedReader(this.getCv().getCharacterStream());
            String ligne;
            while ((ligne = clobReader.readLine()) != null) {
                sb.append("   ").append(ligne);
            }
        }
        sb.append("\n /CV>] \n");
        return sb.toString();
    }

    public void displayInfoAllTicketEmis() throws SQLException {
        // affichage des tickets que l'employe a emis
        Ref[] refTickets = (Ref[]) this.getTicketEmis().getArray();
        System.out.println("<Tickets:");
        for (Ref refTicket : refTickets) {
            Ticket ticket1 = (Ticket) refTicket.getObject(Main.getMapOraObjType());
            System.out.println(ticket1.toString());

        }
        System.out.println(">");
    }

    @Override
    public String toString() {
        return "Empl{" +
                "numsecu=" + numsecu +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", job='" + job + '\'' +
                '}';
    }
}


/*
	The FactureEmise.java file
*/
package sql3;

import java.sql.*;

public class FactureEmise extends Ticket{
    private Ref client;
    private Date datelimite;
    private int payeounon;

    public FactureEmise(){}

    public FactureEmise(String sql_type, int id, int estvente, Array ligneticket, String paiement, Ref employeemmetteur, Ref carte_reduction, Date dateemission, Ref client, Date datelimite, int payeounon) {
        super(sql_type, id, estvente, ligneticket, paiement, employeemmetteur, carte_reduction, dateemission);
        this.client = client;
        this.datelimite = datelimite;
        this.payeounon = payeounon;
    }

    public Ref getClient() {
        return client;
    }

    public void setClient(Ref client) {
        this.client = client;
    }

    public Date getDatelimite() {
        return datelimite;
    }

    public void setDatelimite(Date datelimite) {
        this.datelimite = datelimite;
    }

    public int getPayeounon() {
        return payeounon;
    }

    public void setPayeounon(int payeounon) {
        this.payeounon = payeounon;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return super.getSQLTypeName();
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        super.readSQL(stream, typeName);
        this.client = stream.readRef();
        this.datelimite = stream.readDate();
        this.payeounon = stream.readInt();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        super.writeSQL(stream);
        stream.writeRef(client);
        stream.writeDate(datelimite);
        stream.writeInt(payeounon);
    }

    @Override
    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         client = %s
                         id = %d
                         estvente = %d
                         paiement = %s
                         dateemission = %s
                         datelimite = %s
                         payeounon = %d
                        }
                        """, displayInfoClientFromRef(), getId(), getEstvente(), getPaiement(), getDateemission(), datelimite, payeounon);
    }

    public String displayInfoClientFromRef() throws SQLException {
        Ref refClient1 = this.getClient();
        Client client1 = (Client) refClient1.getObject(Main.getMapOraObjType());
        return client1.toString();
    }
}


/*
	The FactureRecue.java file
*/
package sql3;

import java.sql.*;

public class FactureRecue extends Ticket{
    private Ref fournisseur;
    private Date datelimite;
    private int payeounon;

    public FactureRecue(){}

    public FactureRecue(String sql_type, int id, int estvente, Array ligneticket, String paiement, Ref employeemmetteur, Ref carte_reduction, Date dateemission, Ref fournisseur, Date datelimite, int payeounon){
        super(sql_type, id, estvente, ligneticket, paiement, employeemmetteur, carte_reduction, dateemission);
        this.fournisseur = fournisseur;
        this.datelimite = datelimite;
        this.payeounon = payeounon;
    }

    public Ref getFournisseur() {
        return fournisseur;
    }

    public void setFournisseur(Ref fournisseur) {
        this.fournisseur = fournisseur;
    }

    public Date getDatelimite() {
        return datelimite;
    }

    public void setDatelimite(Date datelimite) {
        this.datelimite = datelimite;
    }

    public int getPayeounon() {
        return payeounon;
    }

    public void setPayeounon(int payeounon) {
        this.payeounon = payeounon;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return super.getSQLTypeName();
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        super.readSQL(stream, typeName);
        this.fournisseur = stream.readRef();
        this.datelimite = stream.readDate();
        this.payeounon = stream.readInt();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        super.writeSQL(stream);
        stream.writeRef(fournisseur);
        stream.writeDate(datelimite);
        stream.writeInt(payeounon);
    }

    @Override
    public void display() throws SQLException {
        System.out.printf(
                """
                        
                        {
                         fournisseur = %s
                         id = %d
                         estvente = %d
                         paiement = %s
                         dateemission = %s
                         datelimite = %s
                         payeounon = %d
                        }
                        """, displayInfoFournisseurFromRef(), getId(), getEstvente(), getPaiement(), getDateemission(), datelimite, payeounon);
    }

    public String displayInfoFournisseurFromRef() throws SQLException {
        Ref refFournisseur1 = this.getFournisseur();
        Fournisseur fournisseur1 = (Fournisseur) refFournisseur1.getObject(Main.getMapOraObjType());
        return fournisseur1.toString();
    }
}



/*
	The Fournisseur.java file
*/
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


/*
	The LigneTicket.java file
*/
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


    @Override
    public String toString() {
        String res = null;
        try {
            res = "LigneTicket{" +
                    "numeroligne=" + numeroligne +
                    ", nom article=" + ((Article) article.getObject(Main.getMapOraObjType())).getNom() +
                    ", quantite=" + quantite +
                    ", parentTicketId=" + ((Ticket) parentTicket.getObject(Main.getMapOraObjType())).getId() +
                    '}';
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }
}


/*
	The Ticket.java file
*/
package sql3;

import java.sql.*;
import java.util.Map;
import java.util.Objects;

public class Ticket implements SQLData {

    private String sql_type;
    private int id;
    private int estvente;
    private Array ligneticket;
    private String paiement;
    private Ref employeemmetteur;
    private Ref carte_reduction;
    private Date dateemission;

    public Ticket(){}

    public Ticket(String sql_type, int id, int estvente, Array ligneticket, String paiement, Ref employeemmetteur, Ref carte_reduction, Date dateemission) {
        this.sql_type = sql_type;
        this.id = id;
        this.estvente = estvente;
        this.ligneticket = ligneticket;
        this.paiement = paiement;
        this.employeemmetteur = employeemmetteur;
        this.carte_reduction = carte_reduction;
        this.dateemission = dateemission;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEstvente() {
        return estvente;
    }

    public void setEstvente(int estvente) {
        this.estvente = estvente;
    }

    public Array getLigneticket() {
        return ligneticket;
    }

    public void setLigneticket(Array ligneticket) {
        this.ligneticket = ligneticket;
    }

    public String getPaiement() {
        return paiement;
    }

    public void setPaiement(String paiement) {
        this.paiement = paiement;
    }

    public Ref getEmployeemmetteur() {
        return employeemmetteur;
    }

    public void setEmployeemmetteur(Ref employeemmetteur) {
        this.employeemmetteur = employeemmetteur;
    }

    public Ref getCarte_reduction() {
        return carte_reduction;
    }

    public void setCarte_reduction(Ref carte_reduction) {
        this.carte_reduction = carte_reduction;
    }

    public Date getDateemission() {
        return dateemission;
    }

    public void setDateemission(Date dateemission) {
        this.dateemission = dateemission;
    }

    @Override
    public String getSQLTypeName() throws SQLException {
        return sql_type;
    }

    @Override
    public void readSQL(SQLInput stream, String typeName) throws SQLException {
        this.sql_type = typeName;
        this.id = stream.readInt();
        this.estvente = stream.readInt();
        this.ligneticket = (Array) stream.readArray();
        this.paiement = stream.readString();
        this.employeemmetteur = stream.readRef();
        this.carte_reduction = stream.readRef();
        this.dateemission = stream.readDate();
    }

    @Override
    public void writeSQL(SQLOutput stream) throws SQLException {
        stream.writeInt(id);
        stream.writeInt(estvente);
        stream.writeArray(ligneticket);
        stream.writeString(paiement);
        stream.writeRef(employeemmetteur);
        stream.writeRef(carte_reduction);
        stream.writeDate(dateemission);

    }

    public void display() throws SQLException, ClassNotFoundException {
        System.out.printf(
                """
                        
                        {
                         id = %d
                         estvente = %d
                         paiement = %s
                         dateemission = %s
                        }
                        """, id, estvente, paiement, dateemission);
    }

    public String displayInfoEmployeEmmetteurFromRef() throws SQLException {
        Ref refEmpl1 = this.getEmployeemmetteur();
        Empl empl1 = (Empl) refEmpl1.getObject(Main.getMapOraObjType());
        return empl1.toString();
    }

    public String displayInfoCarteReductionFromRef() throws SQLException {
        Ref refCarte1 = this.getCarte_reduction();
        Carte carte1 = (Carte) refCarte1.getObject(Main.getMapOraObjType());
        return carte1.toString();
    }

    public void displayInfoAllLigneTicket() throws SQLException {
        //affichage des lignes de ticket
        Ref[] refLigneTickets = (Ref[]) this.getLigneticket().getArray();
        System.out.println("<Lignes de tickets:");
        for (Ref refLigneTicket : refLigneTickets) {
            LigneTicket lt1 = (LigneTicket) refLigneTicket.getObject(Main.getMapOraObjType());
            System.out.println(lt1.toString());

        }
        System.out.println(">");
    }

    @Override
    public String toString() {
        return "Ticket{" +
                "id=" + id +
                ", estvente=" + estvente +
                ", paiement='" + paiement + '\'' +
                ", dateemission=" + dateemission +
                '}';
    }
}

