package com.marvel.api.characters;

import com.intuit.karate.junit5.Karate;

class CharactersRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run().path("classpath:com/marvel/api/characters").tags("~@ignore");
    }
}