function () {
    var env = karate.env;
    karate.log('karate.env system property was:', env);
    if (!env) {
        env = 'dev';
    }
    var config = {
        env: env,
        baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser',
    }
    return config;
}
