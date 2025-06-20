@REQ_KEY_1 @karate @marvel
Feature: CharacterController validation for missing fields

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def invalidCharacter = read('examples/missing-fields-character.json')
    * def expectedErrors = read('examples/missing-fields-error.json')

  @id:3 @MissingFieldsCreation
  Scenario: Attempt to create character with missing fields
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response == expectedErrors