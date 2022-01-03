package sql3;

import java.sql.*;

public class FactureEmise extends Ticket{
    private Ref client;
    private Date datelimite;
    private int payeounon;

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
        Client client1 = (Client) refClient1.getObject();
        return client1.toString();
    }
}
