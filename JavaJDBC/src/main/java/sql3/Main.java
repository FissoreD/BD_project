package sql3;

import java.sql.*;
import java.util.Map;

public class Main {

    private final static String username = "Fissore1I2122";
    private final static String password = "Fissore1I212201";
    private final static String path = "FISSORE1I2122";

    public static void main(String[] argv) {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection conn = DriverManager.getConnection(
                    """
                            jdbc:oracle:thin:@(DESCRIPTION =\r
                                (ADDRESS_LIST =\r
                                  (ADDRESS = (PROTOCOL = TCP)(HOST = 134.59.152.120)(PORT = 443))\r
                                )\r
                                (CONNECT_DATA =\r
                                  (SERVER = DEDICATED)\r
                                  (SERVICE_NAME = pdbm1info.unice.fr)\r
                                )\r
                              )""",
                    username, password);

            Statement stmt = conn.createStatement();

            Map<String, Class<?>> mapOraObjType = conn.getTypeMap();

            mapOraObjType.put(path+".ADRESSE_T", Class.forName("sql3.Adresse"));

            String sqlEmp = "SELECT value(ad) FROM adresse_o ad";

            ResultSet resultsetEmp = stmt.executeQuery(sqlEmp);

            System.out.println("*** INFOS ADRESSE ***");
            while (resultsetEmp.next())
                ((Adresse) resultsetEmp.getObject(1, mapOraObjType)).display();


        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Echec du mapping");
            e.printStackTrace();
        }

    }

}
