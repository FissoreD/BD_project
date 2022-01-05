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
            Client client1 = (Client) clientRef.getObject();
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
