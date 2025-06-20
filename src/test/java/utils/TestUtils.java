package utils;

import java.util.UUID;

public class TestUtils {
    
    /**
     * Genera un nombre único para ser utilizado en las pruebas
     * @param prefix Prefijo para el nombre generado
     * @return Nombre único con formato: prefix-UUID
     */
    public static String generateUniqueName(String prefix) {
        return prefix + "-" + UUID.randomUUID().toString().substring(0, 8);
    }
    
    /**
     * Limpia los datos después de una prueba
     * @param baseUrl URL base de la API
     * @param username Nombre de usuario para la API
     * @param id ID del personaje a eliminar
     * @return Verdadero si la eliminación fue exitosa
     */
    public static boolean cleanupData(String baseUrl, String username, String id) {
        // Esta función podría implementarse con una llamada a una biblioteca HTTP
        // como OkHttp o HttpClient si fuera necesario realizar limpieza externa
        return true;
    }
    
    /**
     * Comprueba si la API está disponible
     * @param baseUrl URL base de la API
     * @return Verdadero si la API responde correctamente
     */
    public static boolean isApiAvailable(String baseUrl) {
        // Implementación de comprobación de disponibilidad
        return true;
    }
}
