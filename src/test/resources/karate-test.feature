Feature: Marvel Characters API Tests

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'testuser'
    * def basePath = username + '/api/characters'

  Scenario: Get all characters
    Given path basePath
    When method GET
    Then status 200
    And match response == '#[_ > 0]'
    And match each response contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#array' }

  Scenario: Create a new character successfully
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def uniqueName = 'Test Character ' + timestamp()
    
    Given path basePath
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Test Alter Ego",
      "description": "Test Description",
      "powers": ["Test Power 1", "Test Power 2"]
    }
    """
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.name == uniqueName
    And match response.alterego == 'Test Alter Ego'
    And match response.description == 'Test Description'
    And match response.powers == ['Test Power 1', 'Test Power 2']
    * def characterId = response.id

  Scenario: Get character by ID - Success
    * def createCharacter = call read('classpath:karate-test.feature@CreateCharacter')
    * def characterId = createCharacter.characterId
    * def uniqueName = createCharacter.uniqueName

    Given path basePath + '/' + characterId
    When method GET
    Then status 200
    And match response.id == characterId
    And match response.name == uniqueName
    And match response.alterego == 'Test Alter Ego'
    And match response.description == 'Test Description'
    And match response.powers == ['Test Power 1', 'Test Power 2']

  Scenario: Get character by ID - Not Found
    Given path basePath
    When method GET
    Then status 200
    * def ids = response.map(x => x.id)
    * def maxId = ids.length > 0 ? Math.max.apply(null, ids) : 1000
    * def notFoundId = maxId + 1
    Given path basePath + '/' + notFoundId
    When method GET
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Create character - Duplicate name
    * def createFirst = call read('classpath:karate-test.feature@CreateCharacter')
    
    Given path basePath
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """
    When method POST
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Create character - Missing required fields
    Given path basePath
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method POST
    Then status 400
    And match response contains { name: 'Name is required' }
    And match response contains { alterego: 'Alterego is required' }
    And match response contains { description: 'Description is required' }
    And match response contains { powers: 'Powers are required' }

  Scenario: Update character - Success
    * def createCharacter = call read('classpath:karate-test.feature@CreateCharacter')
    * def characterId = createCharacter.characterId

    Given path basePath + '/' + characterId
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method PUT
    Then status 200
    And match response.id == characterId
    And match response.description == 'Updated description'

  Scenario: Update character - Not Found
    Given path basePath
    When method GET
    Then status 200
    * def ids = response.map(x => x.id)
    * def maxId = ids.length > 0 ? Math.max.apply(null, ids) : 1000
    * def notFoundId = maxId + 1
    Given path basePath + '/' + notFoundId
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": ["Armor", "Flight"]
    }
    """
    When method PUT
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Delete character - Success
    * def createCharacter = call read('classpath:karate-test.feature@CreateCharacter')
    * def characterId = createCharacter.characterId

    Given path basePath + '/' + characterId
    When method DELETE
    Then status 204

  Scenario: Delete character - Not Found
    Given path basePath
    When method GET
    Then status 200
    * def ids = response.map(x => x.id)
    * def maxId = ids.length > 0 ? Math.max.apply(null, ids) : 1000
    * def notFoundId = maxId + 1
    Given path basePath + '/' + notFoundId
    When method DELETE
    Then status 404
    And match response.error == 'Character not found'

  @CreateCharacter
  Scenario: Create a character for reuse
    * def timestamp = function(){ return java.lang.System.currentTimeMillis() }
    * def uniqueName = 'Test Character ' + timestamp()
    
    Given path basePath
    And header Content-Type = 'application/json'
    And request
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Test Alter Ego",
      "description": "Test Description",
      "powers": ["Test Power 1", "Test Power 2"]
    }
    """
    When method POST
    Then status 201
    * def characterId = response.id
