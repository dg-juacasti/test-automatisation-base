function fn() {
    var base = "bp-se-test-cabcd9b246a5.herokuapp.com";
    var namespace = "josdrodr"
    var protocol = 'http';
    var notFoundId = 999;
    var prefix = 'api'
    var endpoint = 'characters';
    var url = protocol + "://" + base + "/" + namespace + "/" + prefix + "/" + endpoint;
    var config = { url, notFoundId };
    return config;
}
