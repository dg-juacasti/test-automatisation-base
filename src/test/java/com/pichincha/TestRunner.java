package com.pichincha;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.BeforeAll;

public class TestRunner {

    @BeforeAll
    static void beforeAll() {
        System.setProperty("karate.ssl", "true");
    }

    @Karate.Test
    Karate testAllFeatures() {
        return Karate.run().relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testConsultarPersonajes() {
        return Karate.run("marvelCharactersApi.feature").tags("@consultarPersonajes").relativeTo(getClass());
    }
    
    @Karate.Test
    Karate testCrearPersonaje() {
        return Karate.run("marvelCharactersApi.feature").tags("@crearPersonaje").relativeTo(getClass());
    }
}

