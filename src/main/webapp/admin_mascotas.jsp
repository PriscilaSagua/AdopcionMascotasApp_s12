<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Mascota"%>
<%@page import="model.Usuario"%>
<%
    Usuario user = (Usuario) session.getAttribute("usuarioSesion");
    boolean esAdmin = (user != null && user.esAdminTotal());
    Mascota mEdit = (Mascota) request.getAttribute("mascotaEditar");
    boolean esEdicion = (mEdit != null);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración - Colitas Felices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Barra de Navegación -->
    <nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="mascotas?action=catalogo">Administración - Colitas Felices</a>
            <div class="d-flex align-items-center">
                <span class="badge <%= esAdmin ? "bg-danger" : "bg-info text-dark" %> me-3 py-2 px-3">
                     <%= user != null ? user.getNombre() : "Usuario" %> (<%= esAdmin ? "Admin" : "Modificador" %>)
                </span>
                <a href="mascotas?action=catalogo" class="btn btn-outline-light btn-sm me-2">Home</a>
                <a href="mascotas?action=logout" class="btn btn-outline-danger btn-sm">Cerrar Sesión</a>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <% if (request.getParameter("errorPermiso") != null) { %>
            <div class="alert alert-warning alert-dismissible fade show text-center" role="alert">
                ⚠️ <strong>Permiso Denegado:</strong> Tu perfil solo tiene autorización para agregar y modificar mascotas, no para eliminarlas.
            </div>
        <% } %>

        <div class="row">
            <!-- Formulario Crear / Editar -->
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header <%= esEdicion ? "bg-warning text-dark" : "bg-primary text-white" %> fw-bold d-flex justify-content-between align-items-center">
                        <span><%= esEdicion ? "✏️ Editar Mascota #" + mEdit.getIdMascota() : "➕ Registrar Mascota" %></span>
                        <% if (esEdicion) { %>
                            <a href="mascotas?action=admin" class="btn btn-sm btn-outline-dark">Cancelar</a>
                        <% } %>
                    </div>
                    <div class="card-body">
                        <form action="mascotas" method="POST">
                            <input type="hidden" name="action" value="<%= esEdicion ? "actualizar" : "agregar" %>">
                            <% if (esEdicion) { %>
                                <input type="hidden" name="idMascota" value="<%= mEdit.getIdMascota() %>">
                            <% } %>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nombre:</label>
                                <input type="text" name="nombre" class="form-control" placeholder="Ej: Rocky" value="<%= esEdicion ? mEdit.getNombre() : "" %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Especie:</label>
                                <select name="especie" class="form-select" required>
                                    <option value="Perro" <%= esEdicion && "Perro".equalsIgnoreCase(mEdit.getEspecie()) ? "selected" : "" %>>Perro</option>
                                    <option value="Gato" <%= esEdicion && "Gato".equalsIgnoreCase(mEdit.getEspecie()) ? "selected" : "" %>>Gato</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Edad (Meses):</label>
                                <input type="number" name="edadMeses" class="form-control" min="1" placeholder="Ej: 18" value="<%= esEdicion ? mEdit.getEdadMeses() : "" %>" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nombre de Imagen o URL:</label>
                                <input type="text" name="imagen" class="form-control" placeholder="Ej: gato_05.jpg o https://..." value="<%= esEdicion && mEdit.getImagen() != null ? mEdit.getImagen() : "perro_01.jpg" %>" required>
                                <div class="form-text small text-muted">
                                    Coloca el nombre del archivo en <code>img/</code> (ej: <code>gato_05.jpg</code>) o una URL web.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Estado:</label>
                                <select name="estado" class="form-select">
                                    <option value="DISPONIBLE" <%= esEdicion && "DISPONIBLE".equalsIgnoreCase(mEdit.getEstado()) ? "selected" : "" %>>DISPONIBLE</option>
                                    <option value="ADOPTADO" <%= esEdicion && "ADOPTADO".equalsIgnoreCase(mEdit.getEstado()) ? "selected" : "" %>>ADOPTADO</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Descripción:</label>
                                <textarea name="descripcion" class="form-control" rows="3" placeholder="Descripción física y de comportamiento" required><%= esEdicion ? mEdit.getDescripcion() : "" %></textarea>
                            </div>

                            <button type="submit" class="btn <%= esEdicion ? "btn-warning text-dark" : "btn-success" %> w-100 fw-bold">
                                <%= esEdicion ? "Guardar Cambios" : "Guardar en Base de Datos" %>
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Tabla de Gestión -->
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-header bg-dark text-white fw-bold">Inventario de Mascotas</div>
                    <div class="card-body p-0 table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-secondary">
                                <tr>
                                    <th>ID</th>
                                    <th>Foto</th>
                                    <th>Nombre</th>
                                    <th>Especie</th>
                                    <th>Edad</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Mascota> lista = (List<Mascota>) request.getAttribute("mascotas");
                                    if (lista != null && !lista.isEmpty()) {
                                        for (Mascota m : lista) {
                                            String foto = m.getImagen();
                                            if (foto == null || foto.trim().isEmpty()) {
                                                foto = "Perro".equalsIgnoreCase(m.getEspecie()) ? "perro_01.jpg" : "gato_01.jpg";
                                            }
                                            String rutaImg = (foto.startsWith("http://") || foto.startsWith("https://")) ? foto : ("img/" + foto);
                                %>
                                    <tr>
                                        <td><%= m.getIdMascota() %></td>
                                        <td>
                                            <img src="<%= rutaImg %>" class="rounded-circle" style="width: 42px; height: 42px; object-fit: cover;" alt="<%= m.getNombre() %>" onerror="this.src='img/perro_01.jpg'">
                                        </td>
                                        <td class="fw-bold text-dark"><%= m.getNombre() %></td>
                                        <td>
                                            <span class="badge <%= "Perro".equalsIgnoreCase(m.getEspecie()) ? "bg-warning text-dark" : "bg-info text-dark" %>">
                                                <%= m.getEspecie() %>
                                            </span>
                                        </td>
                                        <td><%= m.getEdadMeses() %> m</td>
                                        <td>
                                            <a href="mascotas?action=cambiarEstado&id=<%= m.getIdMascota() %>&estado=<%= m.getEstado() %>" 
                                               class="badge text-decoration-none <%= "DISPONIBLE".equals(m.getEstado()) ? "bg-success" : "bg-secondary" %>"
                                               title="Clic para alternar estado">
                                                <%= m.getEstado() %>
                                            </a>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="mascotas?action=editar&id=<%= m.getIdMascota() %>" class="btn btn-outline-primary">
                                                    Editar
                                                </a>
                                                <% if (esAdmin) { %>
                                                    <!-- Botón visible SOLO para Admin Total -->
                                                    <a href="mascotas?action=eliminar&id=<%= m.getIdMascota() %>" 
                                                       class="btn btn-outline-danger"
                                                       onclick="return confirm('¿Seguro que deseas eliminar a <%= m.getNombre() %>?')">
                                                        Borrar
                                                    </a>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                <%
                                        }
                                    } else {
                                %>
                                    <tr>
                                        <td colspan="7" class="text-center text-muted py-3">No hay registros en la base de datos.</td>
                                    </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>