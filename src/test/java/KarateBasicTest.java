import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:karate-test.feature");
    }
    
    @Karate.Test
    Karate testMarvelCharacters() {
        return Karate.run("classpath:marvelCharactersApi.feature");
    }

    @Karate.Test
    Karate testMarvelE2E() {
        return Karate.run("classpath:marvelE2e.feature");
    }

    // Método para ejecutar todas las pruebas
    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:").tags("~@ignore");
    }
}
