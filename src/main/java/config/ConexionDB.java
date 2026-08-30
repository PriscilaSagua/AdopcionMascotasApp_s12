package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase encargada de gestionar y centralizar la conexión JDBC
 * con la base de datos relacional PostgreSQL.
 */
public class ConexionDB {
    
    // Constantes de configuración de la conexión local
    private static final String URL = "jdbc:postgresql://localhost:5432/postgres";
    private static final String USER = "postgres";
    private static final String PASSWORD = "root";

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
            // Captura de error si no se encuentra el archivo .jar del driver
            System.err.println("Error: Driver de PostgreSQL no encontrado -> " + e.getMessage());
        } catch (SQLException e) {
            // Captura de errores de credenciales o indisponibilidad del servicio
            System.err.println("Error al conectar con la base de datos -> " + e.getMessage());
        }
        return con;
    }
}