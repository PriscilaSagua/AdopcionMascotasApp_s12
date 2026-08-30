/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config;

import dao.MascotaDAO;
import model.Mascota;
import java.util.List;

public class Test {
    public static void main(String[] args) {
        MascotaDAO dao = new MascotaDAO();
        List<Mascota> lista = dao.listarMascotas();
        
        System.out.println("--- TOTAL MASCOTAS EN BD: " + lista.size() + " ---");
        for (Mascota m : lista) {
            System.out.println(m.getIdMascota() + " | " + m.getNombre() + " (" + m.getEspecie() + ") - " + m.getEstado());
        }
    }
}
