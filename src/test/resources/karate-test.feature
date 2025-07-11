Feature: Marvel Characters API Tests

  Background:
    * url 'http://localhost:8080/testuser/api'
    * def characterPayload =
      """
      {
        "name": "Spider-Man",
        "alterego": "Peter Parker",
        "description": "Friendly neighborhood Spider-Man",
        "powers": ["Web-slinging", "Super strength", "Spider-sense"]
      }
      """

  Scenario: 1.0 - Get all characters and expect an empty list
    Given path 'characters'
    When method GET
    Then status 200
    And match response == []

  Scenario: 2.0 - Create a character successfully
    Given request characterPayload
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.name == characterPayload.name
    * def createdId = response.id

  Scenario: 2.1 - Attempt to create a character with a duplicate name
    Given request characterPayload
    When method POST
    Then status 400
    And match response.error == "Character name already exists"

  Scenario: 2.2 - Attempt to create a character with missing required fields
    Given request { name: "", alterego: "", description: "", powers: [] }
    When method POST
    Then status 400
    And match response.name == "Name is required"
    And match response.alterego == "Alterego is required"
    And match response.description == "Description is required"
    And match response.powers == "Powers are required"

  Scenario: 3.0 - Get character by ID successfully
    # Depends on scenario 2.0 having run and set createdId
    Given path createdId
    When method GET
    Then status 200
    And match response.id == createdId
    And match response.name == characterPayload.name

  Scenario: 3.1 - Get character by ID that does not exist
    Given path '999'
    When method GET
    Then status 404
    And match response.error == "Character not found"

  Scenario: 4.0 - Update a character successfully
    # Depends on scenario 2.0 having run and set createdId
    * def updatedDescription = "Updated description for Spider-Man"
    * def updatePayload = karate.copy(characterPayload)
    * updatePayload.description = updatedDescription
    Given path createdId
    And request updatePayload
    When method PUT
    Then status 200
    And match response.id == createdId
    And match response.description == updatedDescription

  Scenario: 4.1 - Update a character that does not exist
    Given path '999'
    And request characterPayload
    When method PUT
    Then status 404
    And match response.error == "Character not found"

  Scenario: 5.0 - Delete a character successfully
    # Depends on scenario 2.0 having run and set createdId
    Given path createdId
    When method DELETE
    Then status 204

  Scenario: 5.1 - Delete a character that does not exist
    Given path '999'
    When method DELETE
    Then status 404
    And match response.error == "Character not found"
