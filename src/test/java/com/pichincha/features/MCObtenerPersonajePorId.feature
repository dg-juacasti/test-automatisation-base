@REQ_BAN-0002
Feature: Obtener personaje por ID

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/'


@id:1 @MarvelCharactersAPI  @ObtenerPersonajePorIdExitoso
  Scenario: T-API-BAN-0002-CA1 Obtener personaje por ID (exitoso)
    Given url baseUrl
    And path '50'
    When method get
    Then status 200
    And match response.id == 50
    And print response

@id:2 @MarvelCharactersAPI  @ObtenerPersonajePorIdNoexiste
  Scenario: T-API-BAN-0002-CA2 Obtener personaje por ID (no existe)
    Given url baseUrl
    And path '999'
    When method get
    Then status 404
    And match response.error == "Character not found"
    And print response
