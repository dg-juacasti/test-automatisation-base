function fn() {
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
    defaultTimeout: 5000,
  };

  Karate.log('Base URL:', config.baseUrl);
  return config;
}