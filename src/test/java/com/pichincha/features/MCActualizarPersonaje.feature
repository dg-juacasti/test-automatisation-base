@REQ_UH-0004
Feature: Actualizar personaje

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/'
    * def character = read('classpath:../MarvelCharacters/ActualizarPersonaje.json')


@id:1 @MarvelCharactersAPI  @ActualizarPersonajeExitoso
  Scenario: T-API-UH-0004-CA1 Actualizar personaje (exitoso)
    Given url baseUrl
    And path '50'
    And request character
    When method put
    Then status 200
    And match response.id == 50
    And match response.alterego == "Tony Stark"
    And print response

@id:2 @MarvelCharactersAPI  @ActualizarPersonajeNoExiste
  Scenario: T-API-UH-0004-CA2 Actualizar personaje (no existe)
    Given url baseUrl
    And path '99999999'
    And request character
    When method put
    Then status 404
    And match response.error == "Character not found"
    And print response
