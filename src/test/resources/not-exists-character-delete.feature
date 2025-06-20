@REQ_KEY_1 @karate @marvel
Feature: CharacterController update non-existent character

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def nonExistentId = 999999

  @id:5 @UpdateNonExistentCharacter
  Scenario: Attempt to update a non-existent character
    Given path basePath, nonExistentId
    When method delete
    Then status 404
    And match response.error == 'Character not found'