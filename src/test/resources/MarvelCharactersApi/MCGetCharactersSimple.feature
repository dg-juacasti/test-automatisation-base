@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Validar estructura básica de personajes

Background:
  * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * def testUser = 'testuser'
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'

Scenario: Obtener personajes y validar estructura básica
  Given url endpoint
  When method GET
  Then status 200
  And match response == '#[]'
  * assert response.length > 0
  And match each response contains { id: '#notnull' }
  And match each response contains { name: '#string' }
  And match each response contains { alterego: '#string' }
