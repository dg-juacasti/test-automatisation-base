@RED_BIL-10 @get-characters
Feature: API para la obtención de personajes

  Background:
    * def path = '/characters'

  @id:1
  Scenario: @RED_BIL-10-CA1 Obtener personaje por id guardado
    * def id = karate.readAsString('file:target/id.txt')
    Given url baseUrl + path + '/' + id
    When method GET
    Then status 200
    * print response
    And match response.id == parseInt(id)
