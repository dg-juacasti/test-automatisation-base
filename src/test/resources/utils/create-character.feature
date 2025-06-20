@ignore
Feature: Helper para crear personajes

  Scenario: Crear un personaje
    * def config = call read('classpath:karate-config.js')
    * def characterGen = call read('classpath:utils/character-generator.js')
    * def testCharacter = characterGen.generateCharacterWithName('CRUD-Test')
    Given url config.baseUrl
    And request testCharacter
    When method post
    Then status 201
    * def characterId = response.id
    * def createdCharacter = response