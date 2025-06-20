function fn() {
  var config = {};
  config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  karate.log('karate-config.js loaded, port_marvel_characters_api:', config.port_marvel_characters_api);
  return config;
}
