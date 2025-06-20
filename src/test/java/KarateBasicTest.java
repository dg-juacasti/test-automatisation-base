import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    
    @Karate.Test
    Karate testMarvelCharactersApi() {
        return Karate.run("classpath:marvel").relativeTo(getClass());
    }
}
