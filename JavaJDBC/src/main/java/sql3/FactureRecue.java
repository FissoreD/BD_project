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

