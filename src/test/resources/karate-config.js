function fn() {
    var env = karate.env; // get system property 'karate.env'
    karate.log('karate.env system property was:', env);
    if (!env) {
        env = 'dev'; // a default 'dev' environment
    }

    var config = {
        // Variables globales para todas las pruebas
        user: 'jcdelacr',
        baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    };

    // Puedes agregar configuraciones específicas para diferentes entornos aquí
    // if (env == 'staging') {
    //   config.baseUrl = 'http://staging-server.com';
    // }

    // Configuración de la conexión, incluyendo el manejo de SSL como buena práctica
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    karate.configure('ssl', true); // Equivalente a * configure ssl = true

    return config;
}