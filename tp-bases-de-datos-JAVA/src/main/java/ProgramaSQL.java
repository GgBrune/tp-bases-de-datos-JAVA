import java.sql.*;

/**
 * Title: ProgramaSQL
 * Description: Java program that modifies table 'Proveedor' from 'calzados_sa' database.
 * Copyright: Copyright (c) 2026
 * @author kgonzalez; purbano; bgagliardo
 * @version 1.0
 */

public class ProgramaSQL {


  public static void main(String[] args) {

    try {
        // Connection to the MySQL database.
        String driver = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/calzados_sa";
        String username = "root";
        String password = "clave";

        // Load database driver if not already loaded.
        Class.forName(driver);
        // Establish network connection to database.
        Connection connection =
            DriverManager.getConnection(url, username, password);

        // INSERT QUERY ------------------------------------------------------------------------------------------------
        String queryINSERT = "INSERT INTO Proveedor (cuit, direccion, tfono_fijo, razon_social) VALUES (?, ?, ?, ?)";
        PreparedStatement stntINSERT = connection.prepareStatement(queryINSERT);
        stntINSERT.setString(1, "30-90237610-5");
        stntINSERT.setString(2, "Brasil 2470");
        stntINSERT.setInt(3, 464089);
        stntINSERT.setString(4, "Pantuflines S.R.L.");


        // Print results.
        int insertedRows = stntINSERT.executeUpdate();
        System.out.print("Inserted rows: " + insertedRows);



        // DELETE QUERY ------------------------------------------------------------------------------------------------
        // Definition of the cuit to delete.
        String cuit = "33-45891234-5";

        String queryDELETE = "DELETE FROM Proveedor WHERE cuit = ?";
        PreparedStatement stntDELETE = connection.prepareStatement(queryDELETE);
        stntDELETE.setString(1, cuit);
        

        // Print results.
        int deletedRows = stntDELETE.executeUpdate();
        // Shows if the value is deleted.
        if (deletedRows > 0) {
            System.out.println("Deleted.");
        } else {
            System.out.println("Invalid CUIT.");
        }


        // SELECT QUERY ------------------------------------------------------------------------------------------------
        // Selection of all the values of the atribute.
        String querySELECT = "SELECT * FROM Proveedor";
        PreparedStatement stntSELECT = connection.prepareStatement(querySELECT);
        ResultSet resultSet = stntSELECT.executeQuery();

        // Print results.
        // Shows on screen the list.
        while(resultSet.next()) {
            System.out.print("CUIT: " + resultSet.getString("cuit"));
            System.out.print("; Dirección: " + resultSet.getString("direccion")) ;
            System.out.print("; Teléfono: " + resultSet.getString("tfono_fijo")) ;
            System.out.print("; Razón Social: "+ resultSet.getString("razon_social"));
            System.out.print("\n   ");
        }


        // Send query to database and store results.
      
    } catch(ClassNotFoundException cnfe) {
        System.err.println("Error loading driver: " + cnfe);
        cnfe.printStackTrace();
    } catch(SQLException sqle) {
        sqle.printStackTrace();
        System.err.println("Error connecting: " + sqle);
    } catch(Exception sqle) {
        sqle.printStackTrace();
        System.err.println("Error connecting: " + sqle);
    }
  
  }

}