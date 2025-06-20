package com.pichincha.MarvelCharactersApi;
import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {

//        return Karate.run().relativeTo(getClass());
//        return Karate.run("classpath:karate-test.feature");
//        return Karate.run("get-characters").relativeTo(getClass());
//        return Karate.run("classpath:MarvelCharactersApi/MCGetCharacters.feature"); //OK
//        return Karate.run("classpath:MarvelCharactersApi/MCPostNewCharacter.feature"); //OK
        return Karate.run("classpath:MarvelCharactersApi/MCPutUpdateCharacter.feature"); //OK

    }

}
