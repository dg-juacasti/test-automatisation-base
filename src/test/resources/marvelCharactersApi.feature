Feature: Marvel Characters API tests

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'testuser'
    * def basePath = '/' + username + '/api/characters'
    * configure headers = { 'Content-Type': 'application/json' }
    * def characterPayload =
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    * def uniqueName = function() { return 'Character-' + java.util.UUID.randomUUID().toString().substring(0, 8); }
    
  Scenario: Obtener todos los personajes
    Given path basePath
    When method get
    Then status 200
    And match response == '#array'

  Scenario: Crear personaje (exitoso)
    * def character = characterPayload
    * character.name = uniqueName()
    
    Given path basePath
    And request character
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.name == character.name
    And match response.alterego == character.alterego
    And match response.description == character.description
    And match response.powers == character.powers

    # Guardar el id para usarlo en otros tests
    * def characterId = response.id

  Scenario: Obtener personaje por ID (exitoso)
    # Primero crear un personaje
    * def character = characterPayload
    * character.name = uniqueName()
    
    Given path basePath
    And request character
    When method post
    Then status 201
    * def characterId = response.id
    
    # Ahora obtener el personaje por ID
    Given path basePath + '/' + characterId
    When method get
    Then status 200
    And match response.id == characterId
    And match response.name == character.name

  Scenario: Obtener personaje por ID (no existe)
    Given path basePath + '/999999'
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje (nombre duplicado)
    # Primero crear un personaje
    * def character = characterPayload
    * character.name = uniqueName()
    
    Given path basePath
    And request character
    When method post
    Then status 201
    
    # Intentar crear otro personaje con el mismo nombre
    Given path basePath
    And request character
    When method post
    Then status 400
    And match response.error == 'Character name already exists'
  
  Scenario: Crear personaje (faltan campos requeridos)
    * def invalidCharacter =
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  Scenario: Actualizar personaje (exitoso)
    # Primero crear un personaje
    * def character = characterPayload
    * character.name = uniqueName()
    
    Given path basePath
    And request character
    When method post
    Then status 201
    * def characterId = response.id
    
    # Ahora actualizar el personaje
    * character.description = 'Updated description'
    
    Given path basePath + '/' + characterId
    And request character
    When method put
    Then status 200
    And match response.id == characterId
    And match response.description == 'Updated description'

  Scenario: Actualizar personaje (no existe)
    * def character = characterPayload
    
    Given path basePath + '/999999'
    And request character
    When method put
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Eliminar personaje (exitoso)
    # Primero crear un personaje
    * def character = characterPayload
    * character.name = uniqueName()
    
    Given path basePath
    And request character
    When method post
    Then status 201
    * def characterId = response.id
    
    # Ahora eliminar el personaje
    Given path basePath + '/' + characterId
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path basePath + '/999999'
    When method delete
    Then status 404
    And match response.error == 'Character not found'
