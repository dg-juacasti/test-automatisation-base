@REQ_UH-0001
Feature: Obtener todos los personajes

  Background:
    * configure ssl = true
    * header Content-Type = 'application/json'
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'


@id:1 @MarvelCharactersAPI  @ObtenerTodosLosPersonajes
  Scenario: T-API-UH-0001-CA1 Obtener todos los personajes
    Given url baseUrl
    When method get
    Then status 200
    And print response
