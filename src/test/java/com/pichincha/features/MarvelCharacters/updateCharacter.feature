Feature: Actualización de personajes Marvel

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api/characters'
    * configure ssl = true

  @id:1 @REQ_TPSREM-006 @updateCharacter @casoPositivo @testAll
  Scenario: T-API-TPSREM-006-CA16-Actualizar personaje exitosamente
    Given url baseUrl + '/1'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius, billionaire, playboy, philanthropist",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 200
    * match response.id == 1
    * match response.name == "Iron Man"
    * match response.alterego == "Tony Stark"
    * match response.description == "Genius, billionaire, playboy, philanthropist"
    * match response.powers contains ["Armor", "Flight"]

  @id:2 @REQ_TPSREM-006 @updateCharacter @casoNegativo @testAll
  Scenario: T-API-TPSREM-006-CA17-No se puede actualizar personaje inexistente
    Given url baseUrl + '/999'
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Genius, billionaire, playboy, philanthropist",
      "powers": ["Armor", "Flight"]
    }
    """
    When method put
    Then status 404
    * match response.error == "Character not found"
