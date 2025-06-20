@RED_BIL-10 @update-characters
Feature: API para la actualizacón de personajes

  Background:
    * def path = '/characters'

  @id:1
  Scenario Outline: @RED_BIL-10-CA1 actualizar personajes de forma exitosa
    * def requestBody = read('classpath:../characters/requests/update/new-character.json')
    * def id = karate.readAsString('file:target/id.txt')
    Given url baseUrl + path + '/' + id
    And request requestBody
    When method PUT
    Then status 200
    * print response
    And match response.id == parseInt(id)
    And match response.name == '<name>'
    And match response.description == '<description>'
    Examples:
      | read('classpath:../characters/requests/data/modify-character.csv') |