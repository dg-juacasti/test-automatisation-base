function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com',
    username: 'testuser'
  }
  if (env == 'dev') {
    // customize
    // config.baseUrl = 'http://localhost:8080';
  } else if (env == 'qa') {
    // customize
  }
  return config;
}
