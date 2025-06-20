Feature: Operaciones PUT en la API de personajes Marvel

  Background:
    * url config.baseUrl
    * def expectedResponseFields = ['id', 'name', 'alterego', 'description', 'powers']

  Scenario: Actualizar un personaje exitosamente
    # Primero creamos un personaje
    * def character = data.generateValidCharacter()
    
    Given path 'characters'
    And request character
    When method post
    Then status 201
    
    * def characterId = response.id
    
    # Ahora actualizamos el personaje
    * def updatedCharacter = character
    * set updatedCharacter.description = 'Updated description ' + java.util.UUID.randomUUID()
    
    Given path 'characters', characterId
    And request updatedCharacter
    When method put
    Then status 200
    And match response contains { id: '#number', name: updatedCharacter.name }
    And match response.alterego == updatedCharacter.alterego
    And match response.description == updatedCharacter.description
    And match response.powers == updatedCharacter.powers
    And match response == '#object'
    And match each response contains expectedResponseFields

  Scenario: Actualizar un personaje que no existe
    * def character = data.generateValidCharacter()
    * def invalidId = data.randomInvalidId()
    
    Given path 'characters', invalidId
    And request character
    When method put
    Then status 404
    And match response.error == 'Character not found'
