@REQ_KEY_1 @karate @marvel
Feature: CharacterController basic API tests

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def newCharacter = read('examples/new-character.json')
    * def updateCharacter = read('examples/update-character.json')

  @id:1 @FullChracterLifecycle
  Scenario: Full character lifecycle
    # Create
    Given path basePath
    And request newCharacter
    When method post
    Then status 201
    And match response.name == newCharacter.name
    And def newId = response.id

    # Get by id
    Given path basePath, newId
    When method get
    Then status 200
    And match response.id == newId

    # Update
    Given path basePath, newId
    And request updateCharacter
    When method put
    Then status 200
    And match response.description == updateCharacter.description

    # Delete
    Given path basePath, newId
    When method delete
    Then status 204