package sql3;

import java.sql.*;

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

    public void display() throws SQLException {
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
        Empl empl1 = (Empl) refEmpl1.getObject();
        return empl1.toString();
    }

    public String displayInfoCarteReductionFromRef() throws SQLException {
        Ref refCarte1 = this.getCarte_reduction();
        Carte carte1 = (Carte) refCarte1.getObject();
        return carte1.toString();
    }
}
