package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada de gestionar y centralizar la conexión JDBC
 * con la base de datos relacional PostgreSQL alojada en Render.
 */
public class ConexionDB {
    
    // Constantes de configuración apuntando a Render Cloud
    private static final String URL = "jdbc:postgresql://dpg-daabou942hec73a2rstg-a.oregon-postgres.render.com/adopcion_db_hcma?sslmode=require";
    private static final String USER = "adopcion_db_hcma_user";
    private static final String PASSWORD = "yaLNv2GfHiiARh6faFRQvyFXKSVg5ESZ";

    /**
     * Establece y retorna una conexión activa hacia la base de datos.
     * 
     * @return Objeto Connection activo, o null en caso de error.
     */
    public static Connection getConnection() {
        Connection con = null;
        try {
            // Carga explícita del driver de PostgreSQL en memoria
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.err.println("Error: Driver de PostgreSQL no encontrado -> " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error al conectar con la base de datos en Render -> " + e.getMessage());
        }
        return con;
    }
}