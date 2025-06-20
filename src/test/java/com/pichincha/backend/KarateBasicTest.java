package com.pichincha.backend;

import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }

    @Karate.Test
    Karate fullCharacterLifecycleTest() {
        return Karate.run("classpath:full-character-lifecycle.feature");
    }

    @Karate.Test
    Karate retrieveAllCharactersTest() {
        return Karate.run("classpath:retrieve-all-characters.feature");
    }

    @Karate.Test
    Karate duplicatedNameCreationTest() {
        return Karate.run("classpath:duplicated-name-creation.feature");
    }

    @Karate.Test
    Karate missingFieldsCreationTest() {
        return Karate.run("classpath:missing-fields-creation.feature");
    }

    @Karate.Test
    Karate notExistsCharacterUpdate() {
        return Karate.run("classpath:not-exists-character-update.feature");
    }

    @Karate.Test
    Karate notExistsCharacterDelete() {
        return Karate.run("classpath:not-exists-character-delete.feature");
    }

}
