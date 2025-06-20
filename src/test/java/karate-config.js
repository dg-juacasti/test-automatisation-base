function() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api/',
    //Trae la variable de entorno llamada TOKEN configurada en intellij y la guarda en la variable token para los tests
    token: java.lang.System.getenv('TOKEN'),
    baseUrl1005: 'http://tna-msa-dm-orqtransferencias1005.apps.ocptest.uiotest.bpichinchatest.test/api/v1/TransferenciasDirectas/'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}
