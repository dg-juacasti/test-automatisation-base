@REQ_PQBP-638
@id:3
@MarvelCharactersApi
@actualizar-personaje

Feature: Actualizar personaje existente en la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def invalidId = 999
  * def fs = Java.type('java.nio.file.Files')
  * def path = Java.type('java.nio.file.Paths').get('target/character.json')
  * def characterInfo = JSON.parse(fs.readString(path))
  * def validId = characterInfo.id
  * def timestamp = new Date().getTime()
  * def updatedDescription = 'Updated description ' + timestamp

  # Payload dinámico basado en characterInfo, solo actualizamos description para simular cambio
  * def updatePayload =
    """
    {
      "name": "#(characterInfo.name)",
      "alterego": "Tony Stark",
      "description": "#(updatedDescription)",
      "powers": ["Armor", "Flight"]
    }
    """

Scenario: Actualizar personaje existente correctamente
  Given url baseUrl + '/' + testUser + '/api/characters/' + validId
  And request updatePayload
  When method PUT
  Then status 200
  And match response.id == validId
  And match response.name == '#string'
  And match response.description == updatedDescription
  And match response.alterego == 'Tony Stark'
  And match response.powers == ["Armor", "Flight"]

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
