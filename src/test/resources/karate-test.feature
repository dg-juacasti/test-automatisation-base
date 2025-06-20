Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def path = '/testuser/api/characters'
  Scenario: Verificar que un endpoint público responde 200
    Given url baseUrl + path
    When method get
    Then status 200
    * print response
