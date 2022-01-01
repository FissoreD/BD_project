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

    public Array getListRefClients() {
        return listRefClients;
    }

    public float getRemise() {
        return remise;
    }

    public String getNom() {
        return nom;
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
        // affichage des prénoms
        Ref[] lesRefDesEmployes = (Ref[]) this.getListRefClients().getArray();
        //System.out.println("Prenoms = "+this.getPrenoms().stringValue());
        System.out.println("<Clients:");
        for (Ref lesRefDesEmploye : lesRefDesEmployes) {
            Client client1 = (Client) lesRefDesEmploye.getObject();
            System.out.println("   [clientId=" + client1.getId() + " ename=" + client1.getName() + "]");

        }
        System.out.println(">");
    }
}
