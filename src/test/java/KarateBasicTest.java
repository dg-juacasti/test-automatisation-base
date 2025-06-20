import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }

    @Karate.Test
    Karate runAllTest() {
        return Karate.run(
                registrarPersonajesTest(),
                obtenerPersonajesTest(),
                actualizarPersonajesTest(),
                eliminarPersonajesTest()
        );
    }

    String registrarPersonajesTest() {
        return "classpath:registrarPersonajes.feature";
    }

    String obtenerPersonajesTest() {
        return "classpath:obtenerPersonajes.feature";
    }

    String actualizarPersonajesTest() {
        return "classpath:actualizarPersonajes.feature";
    }

    String eliminarPersonajesTest() {
        return "classpath:eliminarPersonajes.feature";
    }

}
