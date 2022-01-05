package sql3;

import java.sql.*;

/**
 *
 * @author mondi
 */
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
