Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

  Scenario: Consultar todos los personajes
    * header content-type = 'application/json'
    Given path 'characters'
    When method GET
    Then status 200

  Scenario: Obtener un personaje con ID
    Given path 'characters', '123'
    When method GET
    Then status 200

  Scenario: Crear nuevo personaje
    Given path 'characters'
    And request
    """
    {
      "name": "Thanor",
      "alterego": "Jack Doson",
      "description": "Genius Power",
      "powers": ["Armor", "Flight"]
    }
    """
    When method POST
    Then status 201
