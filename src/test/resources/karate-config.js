function fn() {
  // Objeto global para compartir datos
  var globals = {
    sharedData: {}
  };

  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/arevelo',
    globals: globals,

    // Funciones helper
    saveCharacterData: function(characterData) {
      globals.sharedData.character = characterData;
      karate.log('Character data saved globally:', characterData);
    },

    getCharacterData: function() {
      karate.log('Getting character data:', globals.sharedData.character);
      return globals.sharedData.character;
    }
  };

  return config;
}