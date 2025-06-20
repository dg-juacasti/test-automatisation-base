function fn() {
    var uuid = java.util.UUID.randomUUID() + '';
    
    var DataGenerator = Java.type('helpers.DataGenerator');
    
    var config = {
        baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/josuntax/api',
        username: 'josuntax'
    };
    
    var data = {
        randomHeroName: function() {
            return DataGenerator.randomHeroName();
        },
        randomAlterEgo: function() {
            return DataGenerator.randomAlterEgo();
        },
        randomDescription: function() {
            return DataGenerator.randomDescription();
        },
        randomPowers: function() {
            return DataGenerator.randomPowers();
        },
        randomInvalidId: function() {
            return DataGenerator.randomInvalidId();
        },
        generateValidCharacter: function() {
            return {
                name: DataGenerator.randomHeroName(),
                alterego: DataGenerator.randomAlterEgo(),
                description: DataGenerator.randomDescription(),
                powers: DataGenerator.randomPowers()
            };
        },
        generateInvalidCharacter: function() {
            return {
                name: "",
                alterego: "",
                description: "",
                powers: []
            };
        }
    };
    
    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);
    
    return { config: config, data: data };
}
