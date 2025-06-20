function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_test_automatisation_base_ltgomez = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  // Agrega todos los microservicios que utiliza tu proyecto
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'https://api-dev.empresa.com';
    config.port_test_automatisation_base_ltgomez = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    // Actualiza las URLs para cada microservicio en este entorno
  } 
  else if (env == 'qa') {
    config.baseUrl = 'https://api-qa.empresa.com';
    config.port_test_automatisation_base_ltgomez = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    // Actualiza las URLs para cada microservicio en este entorno
  }

  karate.configure('ssl', true);
  return config;
}
