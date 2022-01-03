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
                              )""", adressIP2, numPort2, serviceName2),
                    username2, password2);

            stmt = conn.createStatement();

            mapOraObjType = conn.getTypeMap();

            for (Types t: Types.values()) {
                mapOraObjType.put(t.typePath, Class.forName("sql3." + t.className));
                t.loop();
            }

        } catch (ClassNotFoundException | SQLException | IOException e) {
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }

    }

    private enum Types{
        ADRESSE, CARTE, CLIENT, EMPL, FOURNISSEUR, ARTICLE, LIGNETICKET, FACTUREEMISE, FACTURERECUE, TICKET;
        public final String className = Objects.equals(this.toString(), "LIGNETICKET") ? "LigneTicket" : this.toString().equals("FACTUREEMISE") ? "FactureEmise" : this.toString().equals("FACTURERECUE") ? "FactureRecue" : this.toString().charAt(0) + this.toString().substring(1).toLowerCase();
        public final String typePath = path2 + "." + this + "_T";

        public void loop() throws SQLException, IOException {
            String query = String.format("SELECT value(c) FROM %s_o c", this == FACTUREEMISE ? TICKET : this == FACTURERECUE ? TICKET : this);

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
                    //case TICKET -> ((Ticket) queryResult.getObject(1, mapOraObjType)).display();
                    case LIGNETICKET -> ((LigneTicket) queryResult.getObject(1, mapOraObjType)).display();
                    //case FACTUREEMISE -> ((FactureEmise) queryResult.getObject(1, mapOraObjType)).display();
                    //case FACTURERECUE -> ((FactureRecue) queryResult.getObject(1, mapOraObjType)).display();
                }
        }
    }
}
