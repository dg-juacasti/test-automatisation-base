@REQ_PQBP-638
@id:3
@MarvelCharactersApi
@actualizar-personaje

Feature: Actualizar personaje existente en la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def validId = 1
  * def invalidId = 999
  * def updatePayload =
  """
  {
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Updated description",
    "powers": ["Armor", "Flight"]
  }
  """

Scenario: Actualizar personaje existente correctamente
  Given url baseUrl + '/' + testUser + '/api/characters/' + validId
  And request updatePayload
  When method PUT
  Then status 200
  And match response ==
  """
  {
    id: 1,
    name: "Iron Man",
    alterego: "Tony Stark",
    description: "Updated description",
    powers: ["Armor", "Flight"]
  }
  """

Scenario: Intentar actualizar personaje inexistente
  Given url baseUrl + '/' + testUser + '/api/characters/' + invalidId
  And request updatePayload
  When method PUT
  Then status 404
  And match response ==
  """
  {
    error: "Character not found"
  }
  """
