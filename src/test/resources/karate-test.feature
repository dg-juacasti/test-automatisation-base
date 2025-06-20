@REQ_TCN-001  @characters

Feature: Test de API characters

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'

  @id:1 @consultarPersonajes
  Scenario: Consultar todos los personajes
    * header content-type = 'application/json'
    Given path 'characters'
    When method GET
    Then status 200

  @id:2 @consultarPersonajePorId
  Scenario: Obtener un personaje con ID
    Given path 'characters', '843'
    When method GET
    Then status 200

  @id:3 @crearPersonaje
  Scenario: Crear nuevo personaje
    Given path 'characters'
    And request
    """
    {
      "name": "Gomez Cabrera Franklin",
      "alterego": "Foundation",
      "description": "Genius Single",
      "powers": ["Developer", "soft-skills", "Frontend"]
    }
    """
    When method POST
    Then status 201

  @id:4 @actualizarPersonaje
  Scenario: Actualizar personaje con ID
    Given path 'characters', 843
    And request
    """
    {
      "name": "Franky2 Gómez C",
      "alterego": "Frank  Gómez 2",
      "description": "Foundation Power",
      "powers": ["Dev", "soft-skills", "QA"]
    }
    """
    When method PUT
    Then status 200


  @id:5 @eliminarPersonaje
  Scenario: Eliminar personaje con ID
    Given path 'characters', 990
    When method delete
    Then status 204
