Feature: API tests for characters

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Verify that the /jgusnay/api/characters endpoint returns 200
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200

  Scenario: Validate character structure
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200
    * def personajes = response
    * match each personajes == { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }

  Scenario: Validate that a character has at least 2 powers
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200
    * def personajes = response
    * def conMuchosPoderes = karate.filter(personajes, function(p) { return p.powers.length >= 2 })
    * assert conMuchosPoderes.length > 0

  Scenario: Retrieve existing character by ID
    Given path 'jgusnay/api/characters/1'
    When method get
    Then status 200
    * match response ==
    """
    {
      id: 1,
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[]'
    }
    """

  Scenario: Retrieve character that does not exist
    Given path 'jgusnay/api/characters/9999'
    When method get
    Then status 404
    * match response == { error: 'Character not found' }