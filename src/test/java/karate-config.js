function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_bp_se_test_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api';
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.port_bp_se_test_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.port_bp_se_test_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api';
  }
  
  return config;
}
