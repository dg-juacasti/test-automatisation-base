Feature: Operaciones POST en la API de personajes Marvel

  Background:
    * url config.baseUrl
    * def expectedResponseFields = ['id', 'name', 'alterego', 'description', 'powers']

  Scenario: Crear un personaje exitosamente
    * def character = data.generateValidCharacter()
    
    Given path 'characters'
    And request character
    When method post
    Then status 201
    And match response contains { id: '#number', name: character.name }
    And match response.alterego == character.alterego
    And match response.description == character.description
    And match response.powers == character.powers
    And match response == '#object'
    And match each response contains expectedResponseFields

  Scenario: Crear un personaje con nombre duplicado
    * def character = data.generateValidCharacter()
    
    # Primero creamos un personaje
    Given path 'characters'
    And request character
    When method post
    Then status 201
    
    # Intentamos crear otro con el mismo nombre
    Given path 'characters'
    And request character
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Crear un personaje con campos requeridos faltantes
    * def invalidCharacter = data.generateInvalidCharacter()
    
    Given path 'characters'
    And request invalidCharacter
    When method post
    Then status 400
    And match response contains { name: 'Name is required' }
    And match response contains { alterego: 'Alterego is required' }
    And match response contains { description: 'Description is required' }
    And match response contains { powers: 'Powers are required' }
