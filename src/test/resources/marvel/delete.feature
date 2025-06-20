Feature: Operaciones DELETE en la API de personajes Marvel

  Background:
    * url config.baseUrl

  Scenario: Eliminar un personaje exitosamente
    # Primero creamos un personaje
    * def character = data.generateValidCharacter()
    
    Given path 'characters'
    And request character
    When method post
    Then status 201
    
    * def characterId = response.id
    
    # Ahora eliminamos el personaje
    Given path 'characters', characterId
    When method delete
    Then status 204
    
    # Verificamos que el personaje ya no existe
    Given path 'characters', characterId
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar un personaje que no existe
    * def invalidId = data.randomInvalidId()
    
    Given path 'characters', invalidId
    When method delete
    Then status 404
    And match response.error == 'Character not found'
