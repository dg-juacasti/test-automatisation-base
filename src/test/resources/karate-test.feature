@REQ_BIL_1 @marvel
Feature: Test de API de marvel characters

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def path = '/arevelo/api/characters'
  Scenario: T-API-BIL-1-CA1-Verificar que un endpoint público responde 200
    Given url baseUrl + path
    When method get
    Then status 200
    * print response
