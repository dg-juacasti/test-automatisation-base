function fn() {
  var config = {
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  };
  
  // Configuración básica
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 30000);
  karate.configure('ssl', true);
  
  return config;
}
