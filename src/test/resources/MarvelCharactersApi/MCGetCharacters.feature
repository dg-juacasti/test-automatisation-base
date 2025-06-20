@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Validar estructura básica de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'

  # Leer personaje creado desde archivo JSON
  * def fs = Java.type('java.nio.file.Files')
  * def path = Java.type('java.nio.file.Paths').get('target/character.json')
  * def characterInfo = JSON.parse(fs.readString(path))
  * def createdId = characterInfo.id
  * def createdName = characterInfo.name

Scenario: GetCharacterValidateBasicStructureOfCharacterList
  Given url endpoint
  When method GET
  Then status 200
  And match response == '#[]'
  * assert response.length > 0
  And match each response contains { id: '#notnull' }
  And match each response contains { name: '#string' }
  And match each response contains { alterego: '#string' }

Scenario: GetCharacterValidateCharacterPropertiesTypes
  Given url endpoint
  When method GET
  Then status 200
  And match response != null
  And match each response contains { id: '#number', name: '#string', alterego: '#string', description: '#string' }

Scenario: GetCharacterValidateOptionalPowers
  Given url endpoint
  When method GET
  Then status 200
  And match each response == '#? !_.powers || _.powers instanceof Array'

Scenario: GetCharacterVerifyCreatedCharacterIsPresentInList
  Given url endpoint
  When method GET
  Then status 200

  * def expectedCharacter =
    """
    {
      id: '#number',
      name: '#(characterInfo.name)',
      alterego: '#string',
      description: '#string',
      powers: '#[]'
    }
    """
  * match response contains expectedCharacter

Scenario: GetErrorFailToGetNonExistentCharacterReturns404Error
  * def characterId = 999
  * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

  Given url endpoint
  When method GET
  Then status 404
  And match response ==
    """
    {
      error: "Character not found"
    }
    """

Scenario: GetExistingCharacterById3Successfully
  * def characterId = 3
  * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

  Given url endpoint
  When method GET
  Then status 200
  And match response ==
    """
    {
      id: 3,
      name: "Iron Man",
      alterego: "Tony Stark",
      description: "Genius billionaire",
      powers: ["Armor", "Flight"]
    }
    """
  And match response.name == "Iron Man"

Scenario: GetExistingCharacterByDynamicIdCreatedInMCPostNewCharacterFeature
  * def characterId = characterInfo.id
  * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

  Given url endpoint
  When method GET
  Then status 200
  And match response ==
    """
    {
      id: '#number',
      name: '#(characterInfo.name)',
      alterego: '#string',
      description: '#string',
      powers: '#[]'
    }
    """
  And match response.name == characterInfo.name
