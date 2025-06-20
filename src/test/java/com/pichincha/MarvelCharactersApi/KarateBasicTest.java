package com.pichincha.MarvelCharactersApi;
import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {
//        Ejecutar tests en orden secuencial usando un test suite
//            return Karate.run("classpath:MarvelCharactersApi/MasterSuite.feature");
        return Karate.run(
                "classpath:MarvelCharactersApi/MCPostNewCharacter.feature",
                "classpath:MarvelCharactersApi/MCGetCharacters.feature",
                "classpath:MarvelCharactersApi/MCPutUpdateCharacter.feature",
                "classpath:MarvelCharactersApi/MCDeleteCharacter.feature"
        ).relativeTo(getClass());
    }

}
