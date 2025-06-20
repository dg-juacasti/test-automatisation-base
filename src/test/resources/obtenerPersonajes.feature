@REQ_TPSREM-6623 @HU6623 @characterManagement @marvelCharactersApi @Agente2 @E2  @iniciativaMarvel
Feature: TPSREM-6623 - Gestión de Personajes de Marvel

  Background:
    * url baseMarvelCharactersApiUrl
    * path '/' + username + '/api/characters'
    * def headers = { "Content-Type": "application/json" }
    * headers headers

  @id:1 @getAllCharacters @solicitudExitosa200
  Scenario: T-API-TPSREM-6623-CA01-Obtener todos los personajes - karate
    When method GET
    Then status 200
     And match response == '#array'
     And match each response == { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#array' }

  @id:2 @getCharacterById @solicitudExitosa200
  Scenario: T-API-TPSREM-6623-CA03-Obtener personaje por ID exitosamente 200 - karate
    # Assuming a character has been created and characterId is available
    * def createdCharacter = call read('classpath:registrarPersonajes.feature@createCharacter')
    Given path '/' + createdCharacter.characterId
    When method GET
    Then status 200
     And match response.id == createdCharacter.characterId
     And match response.name == createdCharacter.requestBody.name

  @id:3 @getNonExistentCharacter @errorNoEncontrado404
  Scenario: T-API-TPSREM-6623-CA07-Intentar obtener un personaje que no existe 404 - karate
    Given path '/-999'
    When method GET
    Then status 404
     And match response.error == "Character not found"

