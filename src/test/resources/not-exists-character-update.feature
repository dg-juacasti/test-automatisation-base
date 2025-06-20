@REQ_KEY_1 @karate @marvel
Feature: CharacterController update non-existent character

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def nonExistentId = 999999
    * def updatePayload = read('examples/update-character.json')

  @id:6 @UpdateNonExistentCharacter
  Scenario: Attempt to update a non-existent character
    Given path basePath, nonExistentId
    And request updatePayload
    When method put
    Then status 404
    And match response.error == 'Character not found'