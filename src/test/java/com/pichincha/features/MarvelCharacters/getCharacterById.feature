@REQ_TPSREM-002 @getCharacterById @testAll
Feature: Obtener personaje Marvel por ID

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api'
    * configure ssl = true

  @id:1 @T-API-TPSREM-002-CA1-ObtenerPersonajeExistente @casoPositivo
  Scenario: Obtener personaje existente por ID
    Given path 'characters/1'
    When method GET
    Then status 200
    And match response ==
    """
    {
      "id": 1,
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius, billionaire, playboy, philanthropist",
      "powers": ["Armor", "Flight"]
    }
    """

  @id:2 @T-API-TPSREM-002-CA2-ObtenerPersonajeNoExiste @casoNegativo
  Scenario: Obtener personaje con ID inexistente
    Given path 'characters/9999'
    When method GET
    Then status 404
    And match response ==
    """
    {
      "error": "Character not found"
    }
    """
