@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Validar estructura básica de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
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

Scenario: Validar tipos de propiedades en personajes
  Given url endpoint
  When method GET
  Then status 200
  And match response != null
  And match each response contains { id: '#number', name: '#string', alterego: '#string', description: '#string' }

Scenario: Validar poderes de personajes opcionales
  Given url endpoint
  When method GET
  Then status 200
  And match each response == '#? !_.powers || _.powers instanceof Array'