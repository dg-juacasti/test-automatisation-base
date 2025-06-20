@REQ_TPSREM-6623 @HU6623 @characterManagement @marvelCharactersApi @Agente2 @E2 @iniciativaMarvel
Feature: TPSREM-6623 - Gestión de Personajes de Marvel

  Background:
    * url baseMarvelCharactersApiUrl
    * path '/' + username + '/api/characters'
    * def headers = { "Content-Type": "application/json" }
    * headers headers

  @id:1 @deleteCharacter @solicitudExitosa204
  Scenario: T-API-TPSREM-6623-CA05-Eliminar un personaje exitosamente 204 - karate
    * def characters = call read('classpath:obtenerPersonajes.feature@getAllCharacters')
    * def characterId = characters.response[0].id
    Given path '/' + characterId
    When method DELETE
    Then status 204

  @id:2 @deleteNonExistentCharacter @errorNoEncontrado404
  Scenario: T-API-TPSREM-6623-CA09-Intentar eliminar un personaje que no existe 404 - karate
    Given path '/-999'
    When method DELETE
    Then status 404
    And match response.error == "Character not found"
