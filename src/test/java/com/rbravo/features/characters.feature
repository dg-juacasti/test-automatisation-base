@karate @api @charactes_marvel
Feature: List of characters

  Background:
    * url karate.get('baseUrl') + '/api/characters'
    * header content-type = 'application/json'

  @id:1 @get @characters_list
  Scenario: Get all characters returns 200 OK
    When method get
    Then status 200
    And match karate.typeOf(response) == 'list'

  @id:2 @get @characters_by_id
  Scenario: Getting the character with id 14 returns the expected structure
    Given path '14'
    When method get
    Then status 200
    * def expected =
    """
    {
      id: '#number',
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[] #present'
    }
    """
    And match response == expected

  @id:3 @get @character_id_does_not_exist
  Scenario:  Get character by ID that does not exist
    Given path '/123456789'
    When method get
    Then status 404
    And match response.error == 'Character not found'

  @id:4 @post @characters_create
  Scenario: Create a character
    * def character = read('classpath:data/character.json')
    * def random = java.util.UUID.randomUUID() + ''
    * set character.name = character.name + '-' + random
    When request character
    And method post
    Then status 201
    And match response contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[] #present' }

  @id:5 @post @characters_create_duplicate
  Scenario: Create a character with the same name
    * def character = read('classpath:data/character.json')
    When request character
    And method post
    Then status 400
    And match response == { error: 'Character name already exists' }

  @id:6 @post @character_required_fields
  Scenario: Create character with missing required fields
    * def character = read('classpath:data/character_field.json')
    When request character
    And method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  @id:7 @put @character_update
  Scenario: Update character successfully
    * def character = read('classpath:data/character_update.json')
    * def random = java.util.UUID.randomUUID() + ''
    * set character.name = character.name + '-' + random
    When request character
    And method post
    Then status 201
    * def createdId = response.id
    Given path + createdId
    And request { name: '#(character.name)', alterego: 'Steve Rogers', description: 'Updated description', powers: ['Shield', 'Leadership', 'Dev'] }
    When method put
    Then status 200
    And match response.description == 'Updated description'
    And match response.powers contains 'Leadership'

  @id:8 @put @character_update_does_not_exist
  Scenario: Update character that does not exist
    Given path '14'
    And request { name: 'Test', alterego: 'Test', description: 'Test', powers: ['Test'] }
    When method put
    Then status 404
    And match response.error == 'Character not found'

  @id:9 @delete @character_delete
  Scenario: Delete character successfully
    * def character = read('classpath:data/character.json')
    * def random = java.util.UUID.randomUUID() + ''
    * set character.name = character.name + '-' + random
    When request character
    And method post
    Then status 201
    * def createdId = response.id
    Given path + createdId
    When method delete
    Then status 204

  @id:10 @delete @character_delete_does_not_exist
  Scenario: Delete character that does not exist
    Given path '/123456789'
    When method delete
    Then status 404
    And match response.error == 'Character not found'