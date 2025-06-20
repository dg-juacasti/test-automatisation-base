@REQ_PQBP-639
@id:4
@MarvelCharactersApi
@eliminar-personaje

Feature: Eliminar personaje de la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def validId = 2
  * def invalidId = 999

Scenario: Eliminar personaje inexistente devuelve 404
  Given url baseUrl + '/' + testUser + '/api/characters/' + invalidId
  When method DELETE
  Then status 404
  And match response ==
  """
  {
    error: "Character not found"
  }
  """

Scenario: Eliminar personaje existente devuelve 204 sin contenido
  Given url baseUrl + '/' + testUser + '/api/characters/' + validId
  When method DELETE
  Then status 204
  And match response == ''
