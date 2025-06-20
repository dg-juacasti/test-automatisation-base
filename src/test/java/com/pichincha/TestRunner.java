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
        return Karate.run("classpath:com/pichincha/features/marvelCharactersApi.feature");
    }
    
    @Karate.Test
    Karate testConsultarPersonajes() {
        return Karate.run("classpath:com/pichincha/features/marvelCharactersApi.feature")
                .tags("@consultarPersonajes");
    }
    
    @Karate.Test
    Karate testCrearPersonaje() {
        return Karate.run("classpath:com/pichincha/features/marvelCharactersApi.feature")
                .tags("@crearPersonaje");
    }
}

