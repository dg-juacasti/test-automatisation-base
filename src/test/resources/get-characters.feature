Feature: Get all characters from the API

  Background:
    # Define global variables
    * def baseUrl = karate.properties['base.url'] || 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def testUser = karate.properties['test.user'] || 'testuser'
    * def endpoint = baseUrl + '/' + testUser + '/api/characters'

  Scenario: Successfully get all characters
    Given url endpoint
    When method GET
    Then status 200
    And match response contains only deep {
      id: '#number',
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[ #string ]'
    }
    And match each response[*].id == '#number'
    And match each response[*].powers == '#[ #string ]'
