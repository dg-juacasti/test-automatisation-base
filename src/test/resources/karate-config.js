function fn() {
  var config = {};

  // Leer desde propiedades de sistema o poner valores por defecto
  config.baseUrl = karate.properties['baseUrlConf'] || 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  config.testUser = karate.properties['testUserConf'] || 'jivillac';

  return config;
}
