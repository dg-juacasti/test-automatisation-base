function fn() {
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/arevelo',

    // Funciones helper para compartir datos entre escenarios usando Java static class
    saveCharacterData: function(characterData) {
      Java.type('DataManager').saveCharacterData(characterData);
      karate.log('Character data saved globally:', characterData);
      return characterData;
    },

    getCharacterData: function() {
      var data = Java.type('DataManager').getCharacterData();
      karate.log('Getting character data:', data);
      return data;
    },

    clearCharacterData: function() {
      Java.type('DataManager').clearCharacterData();
      karate.log('Character data cleared');
    }
  };

  return config;
}