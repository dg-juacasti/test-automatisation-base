function fn() {
  var env = karate.env; // obtener el environment de java -Dkarate.env=xxx
  karate.log('karate.env system property was:', env);
  
  if (!env) {
    env = 'dev';
  }
  
  var config = {
    env: env,
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters',
    username: 'testuser',
    timeout: 30000
  }
  
  // Configuración específica por environment
  if (env == 'dev') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters';
  } else if (env == 'test') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters';
  } else if (env == 'local') {
    config.baseUrl = 'http://localhost:8080/testuser/api/characters';
  }
  
  // Configuraciones globales
  karate.configure('connectTimeout', config.timeout);
  karate.configure('readTimeout', config.timeout);
  karate.configure('ssl', false);
  
  karate.log('Configuration loaded for environment:', env);
  karate.log('Base URL:', config.baseUrl);
  
  return config;
}
