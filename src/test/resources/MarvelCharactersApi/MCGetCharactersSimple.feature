@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Prueba simple para obtener personajes

Background:
  * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * def testUser = 'testuser'
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'

Scenario: Obtener personajes - test simple
  Given url endpoint
  When method GET
  Then status 200
  And match response != null
