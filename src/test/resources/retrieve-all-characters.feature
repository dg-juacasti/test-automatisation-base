@REQ_KEY_1 @karate @marvel
Feature: CharacterController basic API tests

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def character = read('examples/new-character.json')

  @id:2 @CreateSingleCharacter
  Scenario: Create a single character
    Given path basePath
    And request character
    When method post
    Then status 201
    * def createdId = response.id

    # Delete the created character
    Given path basePath, createdId
    When method delete
    Then status 204