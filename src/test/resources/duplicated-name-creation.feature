@REQ_KEY_1 @karate @marvel
Feature: CharacterController duplicate name error handling

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'cfperezv'
    * def basePath = '/' + username + '/api/characters'
    * def character =
      """
      {
        "name": "Thor",
        "alterego": "Thor Odinson",
        "description": "God of Thunder",
        "powers": ["Mjolnir", "Lightning"]
      }
      """

  @id:4 @DuplicateNameCreation
  Scenario: Create, check duplicate, and delete character
    # Create character
    Given path basePath
    And request character
    When method post
    Then status 201
    * def createdId = response.id

    # Attempt duplicate creation
    Given path basePath
    And request character
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

    # Delete created character
    Given path basePath, createdId
    When method delete
    Then status 204