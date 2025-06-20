@REQ_TPSREM-6623 @HU6623 @characterManagement @marvelCharactersApi @Agente2 @E2 @iniciativaMarvel
Feature: TPSREM-6623 - Gestión de Personajes de Marvel

  Background:
    * url baseMarvelCharactersApiUrl
    * path '/' + username + '/api/characters'
    * def headers = { "Content-Type": "application/json" }
    * headers headers
    * def random = Math.floor(Math.random() * (999999 - 100 + 1)) + 100

  @id:1 @updateCharacter @solicitudExitosa200
  Scenario: T-API-TPSREM-6623-CA04-Actualizar un personaje exitosamente 200 - karate
    * def characters = call read('classpath:obtenerPersonajes.feature@getAllCharacters')
    * def characterList = characters.response
    * def randomIndex = Math.floor(Math.random() * characterList.length)
    * def characterId = characterList[randomIndex].id
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/updateCharacterRequest.json')
    * set requestBody.name = requestBody.name + random
    * set requestBody.alterego = requestBody.alterego + random
    Given path '/' + characterId
    And request requestBody
    When method PUT
    Then status 200
    And match response.name == requestBody.name
    And match response.description == requestBody.description

  @id:2 @updateNonExistentCharacter @errorNoEncontrado404
  Scenario: T-API-TPSREM-6623-CA08-Intentar actualizar un personaje que no existe 404 - karate
    * def requestBody = read('classpath:data/marvelCharacters/archivosJson/updateCharacterRequest.json')
    Given path '/-999'
    And request requestBody
    When method PUT
    Then status 404
    And match response.error == "Character not found"
