@RED_BIL-10 @create-characters
Feature: API para el registro de personajes

  Background:
    * def path = '/characters'

  @id:1
  Scenario Outline: @RED_BIL-10-CA1 registrar personajes de forma exitosa
    * def requestBody = read('classpath:../characters/requests/create/new-character.json')
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 201
    * print response
    * def newId = response.id
    * karate.write(newId, '/id.txt')
    And match response.id == newId
    And match response.name == '<name>'
    Examples:
      | read('classpath:../characters/requests/data/character.csv') |

  @id:2
  Scenario Outline: @RED_BIL-10-CA2 registrar personajes de forma duplicado
    * def requestBody = read('classpath:../characters/requests/create/new-character.json')
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 400
    * print response
    And match response.error == 'Character name already exists'
    Examples:
      | read('classpath:../characters/requests/data/character.csv') |

  @id:3
  Scenario Outline: @RED_BIL-10-CA3 registrar personajes de forma incorrecta
    * def requestBody = read('classpath:../characters/requests/create/incorrect-request.json')
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 400
    * print response
    And match response.name == 'Name is required'
    Examples:
      | read('classpath:../characters/requests/data/character.csv') |