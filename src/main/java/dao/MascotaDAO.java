package dao;

import config.ConexionDB;
import model.Mascota;
import model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MascotaDAO {

    // 1. Listar todas las mascotas
    public List<Mascota> listarMascotas() {
        List<Mascota> lista = new ArrayList<>();
        String sql = "SELECT id_mascota, nombre, especie, edad_meses, descripcion, estado, imagen FROM mascotas ORDER BY id_mascota ASC";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Mascota m = new Mascota(
                    rs.getInt("id_mascota"),
                    rs.getString("nombre"),
                    rs.getString("especie"),
                    rs.getInt("edad_meses"),
                    rs.getString("descripcion"),
                    rs.getString("estado"),
                    rs.getString("imagen")
                );
                lista.add(m);
            }
        } catch (SQLException e) {
            System.err.println("Error al listar mascotas: " + e.getMessage());
        }
        return lista;
    }

    // 2. Obtener mascota por ID para editar
    public Mascota obtenerPorId(int idMascota) {
        String sql = "SELECT id_mascota, nombre, especie, edad_meses, descripcion, estado, imagen FROM mascotas WHERE id_mascota = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idMascota);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Mascota(
                        rs.getInt("id_mascota"),
                        rs.getString("nombre"),
                        rs.getString("especie"),
                        rs.getInt("edad_meses"),
                        rs.getString("descripcion"),
                        rs.getString("estado"),
                        rs.getString("imagen")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al buscar por ID: " + e.getMessage());
        }
        return null;
    }

    // 3. Crear nueva mascota
    public boolean agregarMascota(Mascota m) {
        String sql = "INSERT INTO mascotas (nombre, especie, edad_meses, descripcion, estado, imagen) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, m.getNombre());
            ps.setString(2, m.getEspecie());
            ps.setInt(3, m.getEdadMeses());
            ps.setString(4, m.getDescripcion());
            ps.setString(5, m.getEstado());
            ps.setString(6, m.getImagen());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al agregar: " + e.getMessage());
            return false;
        }
    }

    // 4. Actualizar datos completos
    public boolean actualizarMascota(Mascota m) {
        String sql = "UPDATE mascotas SET nombre = ?, especie = ?, edad_meses = ?, descripcion = ?, estado = ?, imagen = ? WHERE id_mascota = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, m.getNombre());
            ps.setString(2, m.getEspecie());
            ps.setInt(3, m.getEdadMeses());
            ps.setString(4, m.getDescripcion());
            ps.setString(5, m.getEstado());
            ps.setString(6, m.getImagen());
            ps.setInt(7, m.getIdMascota());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar: " + e.getMessage());
            return false;
        }
    }

    // 5. Actualizar solo estado
    public boolean actualizarEstado(int idMascota, String nuevoEstado) {
        String sql = "UPDATE mascotas SET estado = ? WHERE id_mascota = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idMascota);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    // 6. Eliminar registro
    public boolean eliminarMascota(int idMascota) {
        String sql = "DELETE FROM mascotas WHERE id_mascota = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idMascota);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    // 7. AUTH: Validar credenciales y retornar el Usuario con su rol
    public Usuario validarUsuario(String correo, String clave) {
        if (correo == null || clave == null) return null;
        String cleanCorreo = correo.trim().toLowerCase();
        String cleanClave = clave.trim();

        // 1. Consulta en PostgreSQL
        String sql = "SELECT id_usuario, nombre, correo, password_hash, id_rol FROM usuarios WHERE LOWER(TRIM(correo)) = ? AND TRIM(password_hash) = ?";
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, cleanCorreo);
            ps.setString(2, cleanClave);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
                        rs.getInt("id_usuario"),
                        rs.getString("nombre"),
                        rs.getString("correo"),
                        rs.getString("password_hash"),
                        rs.getInt("id_rol")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Consulta usuarios BD: " + e.getMessage());
        }

        // 2. Respaldo administrativo por código
        if ("admin@adopta.cl".equals(cleanCorreo) && "admin2026".equals(cleanClave)) {
            return new Usuario(1, "Administrador General", "admin@adopta.cl", "admin2026", 1);
        } else if ("mod@adopta.cl".equals(cleanCorreo) && "mod2026".equals(cleanClave)) {
            return new Usuario(2, "Usuario Modificador", "mod@adopta.cl", "mod2026", 2);
        }

        return null;
    }
}