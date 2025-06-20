@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Obtener la lista de personajes disponibles en el API

Background:
  * print '👉 hola'
  * def baseUrl = karate.properties['base.url'] || 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * def testUser = karate.properties['test.user'] || 'testuser'
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'
  * print '👉 baseUrl =', baseUrl
  * print '👉 testUser =', testUser
  * print '👉 endpoint =', endpoint

@id:1.1
Scenario: Obtener todos los personajes registrados exitosamente
  Given url endpoint
  When method GET
  Then status 200
  And match response == '#[{}]'
  And match each response contains {
    id: '#number',
    name: '#string',
    alterego: '#string',
    description: '#string',
    powers: '#[ #string ]'
  }
