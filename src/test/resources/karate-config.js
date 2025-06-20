function fn() {
    var env = karate.env || 'dev';
    karate.log('karate.env system property was:', env);

    var config = {
        user: 'jcdelacr',
        baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    };

    karate.configure('connectTimeout', 5000);
    karate.configure('readTimeout', 5000);
    karate.configure('ssl', true);

    return config;
}