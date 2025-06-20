function fn() {
    // El entorno por defecto será 'dev', a menos que se sobrescriba.
    var env = karate.env || 'dev';
    karate.log('karate.env system property was:', env);

    var config = {
        // Variables globales para la API
        user: 'jcdelacr',
        baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    };

    // Configuración global de timeouts y SSL
    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    karate.configure('ssl', true);

    return config;
}