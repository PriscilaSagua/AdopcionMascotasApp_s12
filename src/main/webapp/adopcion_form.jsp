<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Adopción - Colitas Felices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <nav class="navbar navbar-dark bg-dark mb-4 shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="mascotas?action=catalogo">🐾 Colitas Felices</a>
            <a href="mascotas?action=catalogo" class="btn btn-outline-light btn-sm">Volver al Home</a>
        </div>
    </nav>

    <div class="container mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0 rounded-4">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">Solicitud de Adopción Responsable</h4>
                    </div>
                    <div class="card-body p-4">
                        <div class="alert alert-info text-center mb-4">
                            Estás solicitando adoptar a: <strong><%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "la mascota" %></strong>
                        </div>

                        <form action="mascotas" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="procesarAdopcion">
                            <input type="hidden" name="idMascota" value="<%= request.getParameter("id") != null ? request.getParameter("id") : "0" %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nombre Completo del Adoptante:</label>
                                <input type="text" 
                                       name="nombreAdoptante" 
                                       class="form-control" 
                                       placeholder="Ej: Priscila Sagua" 
                                       pattern="[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+" 
                                       required>
                                <div class="invalid-feedback">
                                    Ingresa un nombre válido (solo letras y espacios).
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">RUT / Identificación:</label>
                                <input type="text" 
                                       name="rut" 
                                       class="form-control" 
                                       placeholder="Ej: 19876543-2 o 19.876.543-K" 
                                       minlength="8"
                                       maxlength="12"
                                       required>
                                <div class="invalid-feedback">
                                    Ingresa un RUT válido (mínimo 8 caracteres).
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Correo Electrónico:</label>
                                <input type="email" 
                                       name="correo" 
                                       class="form-control" 
                                       placeholder="correo@ejemplo.cl" 
                                       required>
                                <div class="invalid-feedback">
                                    Ingresa un correo electrónico válido.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Teléfono de Contacto:</label>
                                <input type="tel" 
                                       name="telefono" 
                                       class="form-control" 
                                       placeholder="+56 9 1234 5678" 
                                       pattern="[0-9+\s\-]{8,15}"
                                       required>
                                <div class="invalid-feedback">
                                    Ingresa un número telefónico válido (solo números, mín 8 dígitos).
                                </div>
                            </div>

                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="compromiso" required>
                                <label class="form-check-label small text-muted" for="compromiso">
                                    Me comprometo al cuidado, alimentación, vacunación y tenencia responsable de la mascota.
                                </label>
                                <div class="invalid-feedback">
                                    Debes aceptar el compromiso de tenencia responsable.
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success btn-lg w-100 fw-bold shadow-sm">
                                Confirmar y Formalizar Adopción
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        (() => {
            'use strict';
            const forms = document.querySelectorAll('.needs-validation');
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>

</body>
</html>