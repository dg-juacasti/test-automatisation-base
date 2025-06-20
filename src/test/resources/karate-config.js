function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  
  // Si no se especifica un ambiente, usamos 'dev' por defecto
  if (!env) {
    env = 'dev';
  }
    // Configuración base que será usada por todos los ambientes
  var config = {
    env: env,
    // URL base para la Marvel Characters API
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com',
    username: 'testuser',
    
    // Función de utilidad para generar nombres aleatorios
    randomString: function() {
      return java.util.UUID.randomUUID() + '';
    },
    
    // Función para crear nombres únicos con prefijo
    uniqueName: function(prefix) {
      return prefix + '-' + java.util.UUID.randomUUID();
    },
    
    // Timeout para peticiones HTTP (en milisegundos)
    readTimeout: 60000,
    connectTimeout: 60000,
    
    // Configuración para manejo de errores
    retryCount: 3,
    retryInterval: 5000
  };
  // Configuraciones específicas para cada ambiente
  if (env === 'dev') {
    // Ambiente de desarrollo (puede apuntar a servicios locales o de dev)
    config.baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com';
  } else if (env === 'qa') {
    // Ambiente de QA
    config.baseUrl = 'http://bp-se-qa-cabcd9b246a5.herokuapp.com';  } else if (env === 'staging') {
    // Ambiente de staging/preproducción
    config.baseUrl = 'http://bp-se-staging-cabcd9b246a5.herokuapp.com';
  } else if (env === 'prod') {
    // Ambiente de producción
    config.baseUrl = 'http://bp-se-prod-cabcd9b246a5.herokuapp.com';
  } else if (env === 'local') {
    // Ambiente local (para pruebas con servidor local o mockado)
    config.baseUrl = 'http://localhost:8080';
  } else if (env === 'mock') {
    // Usar un entorno mockado si la API real no está disponible
    config.baseUrl = 'http://localhost:8080/mock';
    config.isMockEnabled = true;
  }
  // Desactivar SSL ya que usamos HTTP
  karate.configure('ssl', false);
  
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
