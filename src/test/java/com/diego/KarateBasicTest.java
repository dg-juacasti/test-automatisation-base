package com.diego;

import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {
        //return Karate.run("classpath:karate-test.feature");
        return Karate.run("src/test/java/com/diego");
    }

}