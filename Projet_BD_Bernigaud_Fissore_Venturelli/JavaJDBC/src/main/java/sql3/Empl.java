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
