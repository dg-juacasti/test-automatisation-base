import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {
         return Karate.run("classpath:").tags("@characters");
        // return Karate.run("classpath:obtenerPersonajes.feature");
        // return Karate.run("classpath:eliminarPersonajes.feature");
    }

}
