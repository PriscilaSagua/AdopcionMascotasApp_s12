package model;

public class Mascota {
    private int idMascota;
    private String nombre;
    private String especie;
    private int edadMeses;
    private String descripcion;
    private String estado;
    private String imagen;

    public Mascota() {}

    public Mascota(int idMascota, String nombre, String especie, int edadMeses, String descripcion, String estado, String imagen) {
        this.idMascota = idMascota;
        this.nombre = nombre;
        this.especie = especie;
        this.edadMeses = edadMeses;
        this.descripcion = descripcion;
        this.estado = estado;
        this.imagen = (imagen != null && !imagen.trim().isEmpty()) ? imagen : ("Perro".equalsIgnoreCase(especie) ? "perro_01.jpg" : "gato_01.jpg");
    }

    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }

    public int getEdadMeses() { return edadMeses; }
    public void setEdadMeses(int edadMeses) { this.edadMeses = edadMeses; }

    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getImagen() { return imagen; }
    public void setImagen(String imagen) { this.imagen = imagen; }
}