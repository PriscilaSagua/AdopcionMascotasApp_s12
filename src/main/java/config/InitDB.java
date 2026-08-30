package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class InitDB {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://dpg-daabou942hec73a2rstg-a.oregon-postgres.render.com/adopcion_db_hcma?sslmode=require";
        String user = "adopcion_db_hcma_user";
        String pass = "yaLNv2GfHiiARh6faFRQvyFXKSVg5ESZ";

        String ddl = """
            CREATE TABLE IF NOT EXISTS roles (
                id_rol SERIAL PRIMARY KEY,
                nombre VARCHAR(50) NOT NULL
            );

            CREATE TABLE IF NOT EXISTS usuarios (
                id_usuario SERIAL PRIMARY KEY,
                nombre VARCHAR(100) NOT NULL,
                correo VARCHAR(100) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                id_rol INT REFERENCES roles(id_rol)
            );

            CREATE TABLE IF NOT EXISTS mascotas (
                id_mascota SERIAL PRIMARY KEY,
                nombre VARCHAR(100) NOT NULL,
                especie VARCHAR(50) NOT NULL,
                edad_meses INT NOT NULL,
                descripcion TEXT,
                estado VARCHAR(50) NOT NULL,
                imagen VARCHAR(255)
            );

            INSERT INTO roles (id_rol, nombre) VALUES (1, 'Admin Total'), (2, 'Solo Lectura') ON CONFLICT DO NOTHING;

            INSERT INTO usuarios (nombre, correo, password_hash, id_rol) 
            VALUES ('Administrador', 'admin@adopciones.cl', 'admin123', 1) 
            ON CONFLICT DO NOTHING;

            INSERT INTO mascotas (nombre, especie, edad_meses, descripcion, estado, imagen) VALUES 
            ('Luna', 'Perro', 24, 'Perrita mestiza muy cariñosa y juguetona.', 'Disponible', 'perro_01.jpg'),
            ('Milo', 'Gato', 12, 'Gatito sociable y acostumbrado a departamento.', 'Disponible', 'gato_01.jpg')
            ON CONFLICT DO NOTHING;
        """;

        try {
            Class.forName("org.postgresql.Driver");
            try (Connection con = DriverManager.getConnection(url, user, pass);
                 Statement st = con.createStatement()) {
                st.execute(ddl);
                System.out.println(" TABLAS CREADA EN RENDER");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}