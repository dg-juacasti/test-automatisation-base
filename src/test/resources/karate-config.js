function fn() {
  var config = {};
  config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  config.username = 'testuser';
  config.apiPath = '/api/characters';
  config.fullApiUrl = config.baseUrl + '/' + config.username + config.apiPath;
  return config;
}

