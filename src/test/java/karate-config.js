function() {
  var env = karate.env || 'dev';

  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com',
    username: 'trebor006'
  };

  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.baseMarvelCharactersApiUrl = config.baseUrl;

  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.baseMarvelCharactersApiUrl = config.baseUrl;
  }
  else if (env == 'qa') {
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    config.baseMarvelCharactersApiUrl = config.baseUrl;
  }

  return config;
}

