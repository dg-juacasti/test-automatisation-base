function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
	  apiUrl: 'https://conduit-api.bondaracademy.com/api/',
    port_marvel_characters_api: 'http://bp-se-test-cabcd9b246a5.herokuapp.com/',
    marvel_username: 'testuser'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  return config;
}
