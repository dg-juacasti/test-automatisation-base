@REQ_TPSREM-6623 @HU6623 @characterManagement @marvelCharactersApi @Agente2 @E2 @iniciativaMarvel
Feature: TPSREM-6623 - Gestión de Personajes de Marvel

  Background:
    * url baseMarvelCharactersApiUrl
    * path '/' + username + '/api/characters'
    * def headers = { "Content-Type": "application/json" }
    * headers headers
    * def random = Math.floor(Math.random() * (999999 - 100 + 1)) + 100

  @id:1 @createCharacter @solicitudExitosa201
  Scenario: T-API-TPSREM-6623-CA02-Crear un nuevo personaje exitosamente 201 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.name = requestBody.name + random
    * set requestBody.alterego = requestBody.alterego + random
    Given request requestBody
    When method POST
    Then status 201
    And match response.id != null
    And match response.name == requestBody.name
    * def characterId = response.id

  @id:2 @createCharacterCSV @solicitudExitosa201
  Scenario Outline: T-API-TPSREM-6623-CA02-Crear personaje desde CSV <name> - karate
    * def requestBody =
      """
      {
        "name": "<name>",
        "alterego": "<alterego>",
        "description": "<description>",
        "powers": []
      }
      """
    * set requestBody.name = requestBody.name + ' ' + random
    * set requestBody.alterego = requestBody.alterego + ' ' + random
    * set requestBody.powers = '<powers>'.split('/')

    Given request requestBody
    When method POST
    Then status 201
    And match response.id != null
    And match response.name == requestBody.name

    Examples:
      | read('classpath:data/marvelCharacters/archivosCSV/marvelCharacters.csv') |

  @id:3 @createDuplicateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con nombre duplicado 409 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    Given request requestBody
    When method POST
    Then status 400
    And match response.error == "Character name already exists"

  @id:4 @failOnCreateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con todos los campos faltantes 400 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.name = ""
    * set requestBody.alterego = ""
    * set requestBody.description = ""
    * set requestBody.powers = []
    Given request requestBody
    When method POST
    Then status 400
    And match response.name == "Name is required"
    And match response.alterego == "Alterego is required"
    And match response.description == "Description is required"
    And match response.powers == "Powers are required"

  @id:5 @failOnCreateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con el campo name faltante 400 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.name = ""
    Given request requestBody
    When method POST
    Then status 400
    And match response.name == "Name is required"

  @id:6 @failOnCreateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con el campo alterego faltante 400 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.alterego = ""
    Given request requestBody
    When method POST
    Then status 400
    And match response.alterego == "Alterego is required"

  @id:7 @failOnCreateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con el campo description faltante 400 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.description = ""
    Given request requestBody
    When method POST
    Then status 400
    And match response.description == "Description is required"

  @id:8 @failOnCreateCharacter @errorValidacion400
  Scenario: T-API-TPSREM-6623-CA06-Intentar crear personaje con el campo powers vacio 400 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/createCharacterRequest.json')
    * set requestBody.powers = []
    Given request requestBody
    When method POST
    Then status 400
    And match response.powers == "Powers are required"
