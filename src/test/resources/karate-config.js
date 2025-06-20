function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  
  // Si no se especifica un ambiente, usamos 'dev' por defecto
  if (!env) {
    env = 'dev';
  }
  
  // Configuración base para todos los entornos
  var config = {
    // URL base para todos los microservicios
    baseUrl: 'http://localhost:8080',
    
    // Función de utilidad para generar nombres aleatorios
    randomString: function() {
      return java.util.UUID.randomUUID() + '';
    },
    
    // Función para crear nombres únicos con prefijo
    uniqueName: function(prefix) {
      return prefix + '-' + java.util.UUID.randomUUID();
    }
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_marvel_characters_api = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
    // Configuraciones específicas para cada ambiente
  if (env === 'dev') {
    // Ambiente de desarrollo (puede apuntar a servicios locales o de dev)
    config.baseUrl = 'https://bp-se-test-cabcd9b246a5.herokuapp.com';
  } else if (env === 'qa') {
    // Ambiente de QA
    config.baseUrl = 'https://bp-se-qa-cabcd9b246a5.herokuapp.com';
  } else if (env === 'staging') {
    // Ambiente de staging/preproducción
    config.baseUrl = 'https://bp-se-staging-cabcd9b246a5.herokuapp.com';
  } else if (env === 'prod') {
    // Ambiente de producción
    config.baseUrl = 'https://bp-se-prod-cabcd9b246a5.herokuapp.com';
  } else if (env === 'local') {
    // Ambiente local (para pruebas con servidor local o mockado)
    config.baseUrl = 'http://localhost:8080';
  } else if (env === 'mock') {
    // Usar un entorno mockado si la API real no está disponible
    config.baseUrl = 'http://localhost:8080/mock';
    config.isMockEnabled = true;
  }
    // Activar SSL para todos los entornos
  karate.configure('ssl', true);
  
  // Configurar timeouts globales para todas las peticiones
  karate.configure('readTimeout', config.readTimeout);
  karate.configure('connectTimeout', config.connectTimeout);
  
  // Activar el reintento automático para errores de red y de servidor
  karate.configure('retry', { count: config.retryCount, interval: config.retryInterval });
  
  // Configuración para manejar errores específicos del servidor
  config.errorHandler = function(response) {
    if (response.status === 500) {
      karate.log('Error 500 detectado, respuesta del servidor:', response.body);
      return response;
    }
    return response;
  };
  
  // Añadir headers globales si son necesarios
  // karate.configure('headers', { 'Content-Type': 'application/json', 'Accept': 'application/json' });
  
  // Monitoreo de conexión
  karate.log('Configuración actual - URL Base:', config.baseUrl);
  karate.log('Configuración actual - Entorno:', config.env);
  
  return config;
}
