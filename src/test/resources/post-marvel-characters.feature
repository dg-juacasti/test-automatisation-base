Feature: Character creation via POST

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Successful character creation with valid structure
    Given path 'jgusnay/api/characters'
    And request
      """
      {
        "id": 16,
        "name": "Batman5",
        "alterego": "Bruce Wayne",
        "description": "Genius billionaire",
        "powers": ["Strong", "Force"]
      }
      """
    When method post
    Then status 201
    * match response ==
      """
      {
        id: '#number',
        name: '#string',
        alterego: '#string',
        description: '#string',
        powers: '#[]'
      }
      """

  Scenario: Fail to create character with duplicate name
    Given path 'jgusnay/api/characters'
    And request
    """
    {
      "id": 99,
      "name": "Batman",
      "alterego": "The Dark Knight",
      "description": "Duplicate attempt",
      "powers": ["Detective", "Stealth"]
    }
    """
    When method post
    Then status 400
    * match response == { error: 'Character name already exists' }


  Scenario: Fail to create character with missing required fields
    Given path 'jgusnay/api/characters'
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method post
    Then status 400
    * match response ==
    """
    {
      "name": "Name is required",
      "description": "Description is required",
      "powers": "Powers are required",
      "alterego": "Alterego is required"
    }
    """