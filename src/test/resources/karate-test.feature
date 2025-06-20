@Evaluacion @Feature1
Feature: Test del Api de personajes

  Background:
    * configure ssl = true

  Scenario: Verificar que el servicio de personajes está activo
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    When method get
    Then status 200

  Scenario: Verificar que cree un personaje
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And request { "name": "Diego1 Iron Man", "alterego": "Tony Stark Diego", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method post
    Then status 201
    And match response.name == 'Diego1 Iron Man'
    And match response.alterego == 'Tony Stark Diego'
    * def responseId = response.id
    * print 'Personaje creado:', responseId

    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/' + responseId
    When method delete
    Then status 204

  Scenario: Verificar que se actualice un personaje existente
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    And request { "name": "Diego3 Iron Man", "alterego": "Tony Stark Diego", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method post
    Then status 201
    And match response.name == 'Diego3 Iron Man'
    And match response.alterego == 'Tony Stark Diego'
    * def responseIdPut = response.id
    * print 'Personaje creado:', responseIdPut

    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/' + responseIdPut
    And request { "name": "DiegoCambiado3 Iron Man", "alterego": "Tony Stark Diego", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method put
    Then status 200

    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/' + responseIdPut
    When method get
    Then status 200
    And match response.name == 'DiegoCambiado3 Iron Man'