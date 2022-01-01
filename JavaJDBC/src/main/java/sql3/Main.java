package sql3;

import java.sql.*;
import java.util.Map;

public class Main {

    private final static String username = "Fissore1I2122";
    private final static String password = "Fissore1I212201";
    private final static String path = "FISSORE1I2122";
    private final static  String adressIP = "144.21.67.201";
    private final static String serviceName = "pdbm1inf.631174089.oraclecloud.internal";
    private final static int numPort = 1521;
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
                              )""", adressIP,numPort, serviceName),
                    username, password);

            stmt = conn.createStatement();

            mapOraObjType = conn.getTypeMap();

            for (Types t: Types.values()) {
                mapOraObjType.put(t.typePath, Class.forName("sql3." + t.className));
                t.loop();
            }

        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }

    }

    private enum Types{
        ADRESSE, CARTE, CLIENT, EMPL, FOURNISSEUR, TICKET;
        public final String className = this.toString().charAt(0) + this.toString().substring(1).toLowerCase();
        public final String typePath = path + "." + this + "_T";
        public void loop() throws SQLException {
            String query = String.format("SELECT value(c) FROM %s_o c", this);

            ResultSet queryResult = stmt.executeQuery(query);

            System.out.printf("*************** INFOS %s ***************%n", this);
            while (queryResult.next())
                switch (this){
                    case CARTE -> ((Carte) queryResult.getObject(1, mapOraObjType)).display();
                    case ADRESSE -> ((Adresse) queryResult.getObject(1, mapOraObjType)).display();
                    case CLIENT -> ((Client) queryResult.getObject(1, mapOraObjType)).display();
                }
        }
    }
}
