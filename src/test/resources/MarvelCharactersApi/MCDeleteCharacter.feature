@REQ_PQBP-639
@id:4
@MarvelCharactersApi
@eliminar-personaje

Feature: Eliminar personaje de la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')

  # Leer id válido desde el JSON generado previamente
  * def fs = Java.type('java.nio.file.Files')
  * def path = Java.type('java.nio.file.Paths').get('target/character.json')
  * def characterInfo = JSON.parse(fs.readString(path))
  * def validId = characterInfo.id
  * def invalidId = 999

Scenario: DeleteCharacterSuccessfullyReturns204NoContent
  Given url baseUrl + '/' + testUser + '/api/characters/' + validId
  When method DELETE
  Then status 204
  And match response == ''

Scenario: DeleteCharacterFailsWhenNonExistentReturns404Error
  Given url baseUrl + '/' + testUser + '/api/characters/' + invalidId
  When method DELETE
  Then status 404
  And match response ==
  """
  {
    error: "Character not found"
  }
  """