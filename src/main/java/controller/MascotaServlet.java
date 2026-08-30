package controller;

import dao.MascotaDAO;
import model.Mascota;
import model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MascotaServlet", urlPatterns = {"/mascotas"})
public class MascotaServlet extends HttpServlet {

    private final MascotaDAO mascotaDAO = new MascotaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "catalogo";
        }
        
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioSesion");

        switch (action) {
            case "formAdopcion":
                request.getRequestDispatcher("/adopcion_form.jsp").forward(request, response);
                break;

            case "login":
                request.getRequestDispatcher("/admin_login.jsp").forward(request, response);
                break;

            case "logout":
                session.invalidate();
                response.sendRedirect("mascotas?action=catalogo");
                break;

            case "admin":
                if (usuarioActual == null) {
                    response.sendRedirect("mascotas?action=login");
                    return;
                }
                request.setAttribute("mascotas", mascotaDAO.listarMascotas());
                request.getRequestDispatcher("/admin_mascotas.jsp").forward(request, response);
                break;

            case "editar":
                if (usuarioActual == null) {
                    response.sendRedirect("mascotas?action=login");
                    return;
                }
                int idEditar = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("mascotaEditar", mascotaDAO.obtenerPorId(idEditar));
                request.setAttribute("mascotas", mascotaDAO.listarMascotas());
                request.getRequestDispatcher("/admin_mascotas.jsp").forward(request, response);
                break;
                
            case "eliminar":
                if (usuarioActual == null) {
                    response.sendRedirect("mascotas?action=login");
                    return;
                }
                // Control RBAC: Solo rol 1 (Admin Total) puede eliminar
                if (!usuarioActual.esAdminTotal()) {
                    response.sendRedirect("mascotas?action=admin&errorPermiso=1");
                    return;
                }
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                mascotaDAO.eliminarMascota(idEliminar);
                response.sendRedirect("mascotas?action=admin");
                break;

            case "cambiarEstado":
                if (usuarioActual == null) {
                    response.sendRedirect("mascotas?action=login");
                    return;
                }
                int idEstado = Integer.parseInt(request.getParameter("id"));
                String estadoActual = request.getParameter("estado");
                String nuevoEstado = "DISPONIBLE".equalsIgnoreCase(estadoActual) ? "ADOPTADO" : "DISPONIBLE";
                mascotaDAO.actualizarEstado(idEstado, nuevoEstado);
                response.sendRedirect("mascotas?action=admin");
                break;
                
            case "catalogo":
            default:
                request.setAttribute("mascotas", mascotaDAO.listarMascotas());
                request.getRequestDispatcher("/catalogo.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Usuario usuarioActual = (Usuario) session.getAttribute("usuarioSesion");

        if ("loginAdmin".equals(action)) {
            String correo = request.getParameter("usuarioAdmin");
            String pass = request.getParameter("claveAdmin");

            Usuario usuario = mascotaDAO.validarUsuario(correo, pass);

            if (usuario != null) {
                session.setAttribute("usuarioSesion", usuario);
                session.setAttribute("adminLogueado", usuario.getCorreo());
                response.sendRedirect("mascotas?action=catalogo");
            } else {
                response.sendRedirect("mascotas?action=login&error=1");
            }

        } else if ("procesarAdopcion".equals(action)) {
            String strId = request.getParameter("idMascota");
            if (strId != null && !strId.trim().isEmpty() && !"0".equals(strId)) {
                int idMascota = Integer.parseInt(strId);
                mascotaDAO.actualizarEstado(idMascota, "ADOPTADO");
            }
            response.sendRedirect("mascotas?action=catalogo");
            
        } else if ("agregar".equals(action)) {
            if (usuarioActual == null) {
                response.sendRedirect("mascotas?action=login");
                return;
            }

            String nombre = request.getParameter("nombre");
            String especie = request.getParameter("especie");
            int edadMeses = Integer.parseInt(request.getParameter("edadMeses"));
            String descripcion = request.getParameter("descripcion");
            String estado = request.getParameter("estado");
            String imagen = request.getParameter("imagen");

            if (imagen == null || imagen.trim().isEmpty()) {
                imagen = "Perro".equalsIgnoreCase(especie) ? "perro_01.jpg" : "gato_01.jpg";
            }

            Mascota nueva = new Mascota(0, nombre, especie, edadMeses, descripcion, estado, imagen.trim());
            mascotaDAO.agregarMascota(nueva);

            response.sendRedirect("mascotas?action=admin");

        } else if ("actualizar".equals(action)) {
            if (usuarioActual == null) {
                response.sendRedirect("mascotas?action=login");
                return;
            }

            int idMascota = Integer.parseInt(request.getParameter("idMascota"));
            String nombre = request.getParameter("nombre");
            String especie = request.getParameter("especie");
            int edadMeses = Integer.parseInt(request.getParameter("edadMeses"));
            String descripcion = request.getParameter("descripcion");
            String estado = request.getParameter("estado");
            String imagen = request.getParameter("imagen");

            if (imagen == null || imagen.trim().isEmpty()) {
                imagen = "Perro".equalsIgnoreCase(especie) ? "perro_01.jpg" : "gato_01.jpg";
            }

            Mascota mod = new Mascota(idMascota, nombre, especie, edadMeses, descripcion, estado, imagen.trim());
            mascotaDAO.actualizarMascota(mod);

            response.sendRedirect("mascotas?action=admin");
        }
    }
}