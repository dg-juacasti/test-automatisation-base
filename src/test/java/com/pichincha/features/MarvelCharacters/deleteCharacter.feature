Feature: Eliminar personaje por ID

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api'
    * def characterPayload =
    """
    {
      "name": "Mock Hero",
      "alterego": "Test Alterego",
      "description": "This is a mock character",
      "powers": ["Testing"]
    }
    """

  @id:1 @deleteCharacterPositive @casoPositivo @deleteCharacterAll
  Scenario: T-API-TPSREM-000-CA9-Eliminar personaje existente
    Given path '/characters'
    And request characterPayload
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    * def createdId = response.id

    Given path '/characters/' + createdId
    When method delete
    Then status 204

    Given path '/characters/' + createdId
    When method get
    Then status 404

  @id:2 @deleteCharacterNegative @casoNegativo @deleteCharacterAll
  Scenario: T-API-TPSREM-000-CA9-Eliminar personaje inexistente
    Given path '/characters/999999999'
    When method delete
    Then status 404
    * match response.error == 'Character not found'