Feature: Delete character via DELETE method

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Successfully delete an existing character
    Given path 'jgusnay/api/characters/4'
    When method delete
    Then status 204

  Scenario: Fail to delete non-existent character
    Given path 'jgusnay/api/characters/9999'
    When method delete
    Then status 404
    * match response == { error: "Character not found" }