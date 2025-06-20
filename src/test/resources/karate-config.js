function fn() {
    var env = karate.env || 'local'

    var username = "jburgost"


    var config = {
        baseUrl : "http://bp-se-test-cabcd9b246a5.herokuapp.com" + '/' + username + '/api/characters'
    }

    if(env == 'dev' ) {
        username = "jburgost"
        config.baseUrl =  "http://bp-se-test-cabcd9b246a5.herokuapp.com" + '/' + username + '/api/characters'
    }

    if(env == 'qa')  {
        username = "jburgostQA"
        config.baseUrl =  "http://bp-se-test-cabcd9b246a5.herokuapp.com" + '/' + username + '/api/characters'
    }

    if(env == 'prod')  {
        username = "jburgostPROD"
        config.baseUrl =  "http://bp-se-test-cabcd9b246a5.herokuapp.com" + '/' + username + '/api/characters'
    }


    return config;
}