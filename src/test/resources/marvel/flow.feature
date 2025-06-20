Feature: Flujo completo CRUD para la API de personajes Marvel

  Background:
    * url config.baseUrl
    * def expectedResponseFields = ['id', 'name', 'alterego', 'description', 'powers']

  Scenario: Flujo completo - Crear, Obtener, Actualizar y Eliminar un personaje
    # 1. Crear un personaje
    * def character = data.generateValidCharacter()
    
    Given path 'characters'
    And request character
    When method post
    Then status 201
    And match response contains { id: '#number', name: character.name }
    
    * def characterId = response.id
    
    # 2. Obtener el personaje creado
    Given path 'characters', characterId
    When method get
    Then status 200
    And match response.id == characterId
    And match response.name == character.name
    
    # 3. Actualizar el personaje
    * def updatedCharacter = character
    * set updatedCharacter.description = 'Updated description for flow test'
    
    Given path 'characters', characterId
    And request updatedCharacter
    When method put
    Then status 200
    And match response.description == updatedCharacter.description
    
    # 4. Eliminar el personaje
    Given path 'characters', characterId
    When method delete
    Then status 204
    
    # 5. Verificar que el personaje fue eliminado
    Given path 'characters', characterId
    When method get
    Then status 404
    And match response.error == 'Character not found'
