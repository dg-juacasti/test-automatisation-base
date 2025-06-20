Feature: Update character via PUT method

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Successfully update an existing character
    Given path 'jgusnay/api/characters/1'
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 200
    * match response ==
      """
      {
        id: '#number',
        name: "Iron Man",
        alterego: "Tony Stark",
        description: "Updated description",
        powers: ["Armor", "Flight"]
      }
      """


  Scenario: Fail to update non-existent character
    Given path 'jgusnay/api/characters/9999'
    And request
    """
    {
      "name": "Ghost Hero",
      "alterego": "No One",
      "description": "Does not exist",
      "powers": ["Invisibility"]
    }
    """
    When method put
    Then status 404
    * match response == { error: "Character not found" }