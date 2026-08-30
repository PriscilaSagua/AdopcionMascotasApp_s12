<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Mascota"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colitas Felices - Tu nuevo mejor amigo a un click</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .pet-card {
            transition: transform 0.25s ease, box-shadow 0.25s ease;
            border-radius: 14px;
            overflow: hidden;
            border: none;
        }
        .pet-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.12) !important;
        }
        .pet-img {
            height: 210px;
            width: 100%;
            object-fit: cover;
        }
        .badge-especie {
            font-size: 0.8rem;
            padding: 0.4em 0.7em;
            border-radius: 8px;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Barra de Navegación Limpia -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4 text-white text-decoration-none" href="mascotas?action=catalogo">🐾 Colitas Felices</a>
            <div>
                <a href="mascotas?action=catalogo" class="btn btn-outline-light btn-sm me-2">Home</a>
                <% if (session.getAttribute("usuarioSesion") != null) { %>
                    <a href="mascotas?action=admin" class="btn btn-warning btn-sm text-dark fw-bold me-2">Administración</a>
                    <a href="mascotas?action=logout" class="btn btn-outline-danger btn-sm">Salir</a>
                <% } else { %>
                    <a href="mascotas?action=admin" class="btn btn-warning btn-sm text-dark fw-bold">Iniciar Sesión</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Encabezado -->
    <div class="container mb-5">
        <div class="text-center mb-5">
            <h1 class="fw-bold text-dark display-5">Colitas Felices</h1>
            <p class="text-muted fs-5">Tu nuevo mejor amigo a un click</p>
        </div>

        <!-- Grilla de Mascotas -->
        <div class="row g-4">
            <%
                List<Mascota> lista = (List<Mascota>) request.getAttribute("mascotas");
                if (lista != null && !lista.isEmpty()) {
                    for (Mascota m : lista) {
                        String foto = m.getImagen();
                        if (foto == null || foto.trim().isEmpty()) {
                            foto = "Perro".equalsIgnoreCase(m.getEspecie()) ? "perro_01.jpg" : "gato_01.jpg";
                        }
                        String imgSrc = (foto.startsWith("http://") || foto.startsWith("https://")) ? foto : ("img/" + foto);
                        boolean disponible = "DISPONIBLE".equalsIgnoreCase(m.getEstado());
            %>
                <div class="col-12 col-md-6 col-lg-3">
                    <div class="card h-100 shadow-sm pet-card bg-white">
                        <img src="<%= imgSrc %>" class="pet-img" alt="<%= m.getNombre() %>" onerror="this.src='img/perro_01.jpg'">
                        <div class="card-body d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h5 class="card-title fw-bold mb-0 text-dark"><%= m.getNombre() %></h5>
                                <span class="badge badge-especie <%= "Perro".equalsIgnoreCase(m.getEspecie()) ? "bg-warning text-dark" : "bg-info text-dark" %>">
                                    <%= m.getEspecie() %>
                                </span>
                            </div>
                            <h6 class="card-subtitle mb-2 text-muted small"><%= m.getEdadMeses() %> meses de edad</h6>
                            <p class="card-text text-secondary small flex-grow-1"><%= m.getDescripcion() %></p>
                        </div>
                        <div class="card-footer bg-white border-0 pt-0 pb-3">
                            <span class="badge <%= disponible ? "bg-success" : "bg-secondary" %> w-100 mb-2 py-2">
                                <%= m.getEstado() %>
                            </span>
                            <% if (disponible) { %>
                                <a href="mascotas?action=formAdopcion&id=<%= m.getIdMascota() %>&nombre=<%= java.net.URLEncoder.encode(m.getNombre(), "UTF-8") %>" 
                                   class="btn btn-primary btn-sm w-100 fw-semibold">
                                    Solicitar Adopción
                                </a>
                            <% } else { %>
                                <button class="btn btn-outline-secondary btn-sm w-100" disabled>
                                    Ya Adoptado
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="col-12 text-center text-muted py-5">
                    <h5>No hay mascotas registradas por ahora</h5>
                </div>
            <%
                }
            %>
        </div>
    </div>

</body>
</html>