@RED_BIL-10 @delete-characters
Feature: API para la eliminación de personajes

  Background:
    * def path = '/characters'

  @id:1
  Scenario: @RED_BIL-10-CA1 Eliminación de personajes de forma exitosa
    * def id = karate.readAsString('file:target/id.txt')
    Given url baseUrl + path + '/' + id
    When method DELETE
    Then status 204

  @id:1
  Scenario: @RED_BIL-10-CA2 Eliminación de personajes de forma incorrecta, personaje no encontrado
    * def id = '-10'
    Given url baseUrl + path + '/' + id
    When method DELETE
    Then status 404
    * print response
    And match response.error == 'Character not found'