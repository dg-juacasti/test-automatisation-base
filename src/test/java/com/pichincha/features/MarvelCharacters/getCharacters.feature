@REQ_TPSREM-001 @getCharacters @casoPositivo @testAll
Feature: Obtener todos los personajes Marvel

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api'
    * configure ssl = true

  @id:1 @T-API-TPSREM-001-CA1-ObtenerPersonajesExistentes
  Scenario: Obtener lista de personajes existentes
    Given path 'characters'
    When method GET
    Then status 200
    And match response contains deep
    """
[
    {
        "id": 1,
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius, billionaire, playboy, philanthropist",
        "powers": [
            "Armor",
            "Flight"
        ]
    },
    {
        "id": 11,
        "name": "Delete Mock",
        "alterego": "Mock Ego",
        "description": "This character will be deleted",
        "powers": [
            "MockPower"
        ]
    },
    {
        "id": 12,
        "name": "Spiderman",
        "alterego": "Peter Parker",
        "description": "Friendly neighborhood",
        "powers": [
            "Agility",
            "Spider-sense"
        ]
    }
]
    """
