<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso al Sistema - Colitas Felices</title>
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="min-height: 100vh;">

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-4">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-dark text-white text-center py-3">
                        <h5 class="mb-0 fw-bold"> Iniciar Sesión</h5>
                    </div>
                    <div class="card-body p-4">
                        <% if (request.getParameter("error") != null) { %>
                            <div class="alert alert-danger py-2 small text-center" role="alert">
                                Correo o contraseña incorrectos.
                            </div>
                        <% } %>

                        <form action="mascotas" method="POST" autocomplete="off">
                            <input type="hidden" name="action" value="loginAdmin">
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold small">Correo Electrónico:</label>
                                <input type="email" 
                                       name="usuarioAdmin" 
                                       class="form-control" 
                                       placeholder="tu_usuario@adopta.cl" 
                                       autocomplete="off"
                                       required 
                                       autofocus>
                            </div>

                            <!-- Campo de contraseña con placeholder genérico -->
                            <div class="mb-4">
                                <label class="form-label fw-semibold small">Contraseña:</label>
                                <div class="input-group">
                                    <input type="password" 
                                           id="inputPassword" 
                                           name="claveAdmin" 
                                           class="form-control" 
                                           placeholder="tu_clave" 
                                           autocomplete="new-password"
                                           required>
                                    <button class="btn btn-outline-secondary" 
                                            type="button" 
                                            id="btnTogglePass" 
                                            title="Mostrar / Ocultar contraseña">
                                        <i class="bi bi-eye" id="eyeIcon"></i>
                                    </button>
                                </div>
                                <div class="form-text small text-muted">
                                    Haz clic en el ojo para verificar lo ingresado
                                </div>
                            </div>

                            <button type="submit" class="btn btn-warning w-100 fw-bold text-dark mb-2 shadow-sm">
                                Iniciar Sesión
                            </button>
                            
                            <a href="mascotas?action=catalogo" class="btn btn-outline-secondary btn-sm w-100">
                                Volver al Home
                            </a>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const btnToggle = document.getElementById('btnTogglePass');
        const passInput = document.getElementById('inputPassword');
        const eyeIcon = document.getElementById('eyeIcon');

        btnToggle.addEventListener('click', function () {
            if (passInput.type === 'password') {
                passInput.type = 'text';
                eyeIcon.classList.remove('bi-eye');
                eyeIcon.classList.add('bi-eye-slash');
            } else {
                passInput.type = 'password';
                eyeIcon.classList.remove('bi-eye-slash');
                eyeIcon.classList.add('bi-eye');
            }
        });
    </script>

</body>
</html>