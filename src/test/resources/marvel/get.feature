Feature: Operaciones GET en la API de personajes Marvel

  Background:
    * url config.baseUrl
    * def expectedResponseFields = ['id', 'name', 'alterego', 'description', 'powers']

  Scenario: Obtener todos los personajes
    Given path 'characters'
    When method get
    Then status 200
    And match response == '#array'
    * def initialSize = response.length

  Scenario: Obtener un personaje existente por ID
    # Primero creamos un personaje para asegurarnos que existe
    * def character = data.generateValidCharacter()
    
    Given path 'characters'
    And request character
    When method post
    Then status 201
    
    * def characterId = response.id
    
    # Ahora probamos obtenerlo por ID
    Given path 'characters', characterId
    When method get
    Then status 200
    And match response contains { id: '#number', name: character.name }
    And match response.alterego == character.alterego
    And match response.description == character.description
    And match response.powers == character.powers
    And match response == '#object'
    And match each response contains expectedResponseFields

  Scenario: Obtener un personaje que no existe
    * def invalidId = data.randomInvalidId()
    
    Given path 'characters', invalidId
    When method get
    Then status 404
    And match response.error == 'Character not found'
