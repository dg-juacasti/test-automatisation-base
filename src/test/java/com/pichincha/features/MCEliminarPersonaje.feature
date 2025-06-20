@REQ_UH-0005
Feature: Eliminar personaje

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/'


@id:1 @MarvelCharactersAPI  @EliminarPersonajeExitoso
  Scenario: T-API-UH-0005-CA1 Eliminar personaje (exitoso)
    Given url baseUrl
    And path '502'
    When method delete
    Then status 204
    And print response

@id:2 @MarvelCharactersAPI  @EliminarPersonajeNoExiste
  Scenario: T-API-UH-0005-CA1 Eliminar personaje (no existe)
    Given url baseUrl
    And path '999'
    When method delete
    Then status 404
    And match response.error == "Character not found"
    And print response