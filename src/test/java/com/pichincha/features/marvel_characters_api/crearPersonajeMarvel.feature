@REQ_BTPMCDP-999 @HU999 @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: Pruebas Marvel Characters API
  # Test scenarios for Marvel Characters API

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * header Content-Type = 'application/json'
    * configure ssl = true
    * def uuid = function() { return java.util.UUID.randomUUID() + '' }
    * def username = 'mperezja'

  # GET all characters - Matches Postman "Obtener todos los personajes"
  @id:1 @obtener_personajes @respuesta200
  Scenario: T-API-BTPMCDP-999-CA01-Obtener todos los personajes - karate
    Given path username, 'api', 'characters'
    When method GET
    Then status 200
    # The Postman collection shows this can return an empty array
    * match response == '#array'

  # POST create character - Matches Postman "Crear personaje (exitoso)"
  @id:2 @crear_personaje_exitoso @respuesta201
  Scenario: T-API-BTPMCDP-999-CA02-Crear personaje exitosamente - karate
    * def uniqueId = uuid().substring(0, 8)
    * def characterName = 'Iron Man ' + uniqueId
    * def requestBody = read('classpath:data/marvel_characters_api/request_crear_personaje_valido.json')
    * requestBody.name = characterName

    Given path username, 'api', 'characters'
    And request requestBody
    When method POST
    Then status 201
    # Validate all fields exactly as shown in Postman collection
    * match response.id == '#notnull'
    * match response.name == characterName
    * match response.alterego == 'Tony Stark'
    * match response.description == '#string'
    * match response.powers == '#[2]'
    * match response.powers contains 'Armor'
    * match response.powers contains 'Flight'

  # POST error: campos vacíos - Matches Postman "Crear personaje (faltan campos requeridos)"
  @id:3 @crear_personaje_invalido @respuesta400
  Scenario: T-API-BTPMCDP-999-CA03-Error de validación por campos vacíos - karate
    Given path username, 'api', 'characters'
    And request read('classpath:data/marvel_characters_api/request_crear_personaje_invalido.json')
    When method POST
    Then status 400
    # Error messages exactly as shown in Postman collection
    * match response.name == 'Name is required'
    * match response.alterego == 'Alterego is required'
    * match response.description == 'Description is required'
    * match response.powers == 'Powers are required'

  # PUT update character - Matches Postman "Actualizar personaje (exitoso)"
  @id:4 @actualizar_personaje @respuesta200
  Scenario: T-API-BTPMCDP-999-CA04-Actualizar personaje exitosamente - karate
    # First create a character with unique name
    * def uniqueId = uuid().substring(0, 8)
    * def characterName = 'Iron Man ' + uniqueId
    * def requestBody = read('classpath:data/marvel_characters_api/request_crear_personaje_valido.json')
    * requestBody.name = characterName

    Given path username, 'api', 'characters'
    And request requestBody
    When method POST
    Then status 201
    * def characterId = response.id

    # Then update it - validate all fields as shown in Postman collection
    Given path username, 'api', 'characters', characterId
    * def updateBody = read('classpath:data/marvel_characters_api/request_actualizar_personaje_valido.json')
    * updateBody.name = characterName
    And request updateBody
    When method PUT
    Then status 200
    * match response.id == characterId
    * match response.name == characterName
    * match response.alterego == 'Tony Stark'
    * match response.description == 'Updated description'
    * match response.powers contains 'Armor'
    * match response.powers contains 'Flight'

  # DELETE character - Matches Postman "Eliminar personaje (exitoso)"
  @id:5 @eliminar_personaje @respuesta204
  Scenario: T-API-BTPMCDP-999-CA05-Eliminar personaje exitosamente - karate
    # First create a character with unique name
    * def uniqueId = uuid().substring(0, 8)
    * def characterName = 'Iron Man ' + uniqueId
    * def requestBody = read('classpath:data/marvel_characters_api/request_crear_personaje_valido.json')
    * requestBody.name = characterName

    Given path username, 'api', 'characters'
    And request requestBody
    When method POST
    Then status 201
    * def characterId = response.id

    # Then delete it - this should return no content (204) as shown in Postman
    Given path username, 'api', 'characters', characterId
    When method DELETE
    Then status 204

    # Verify deletion - this should return 404 with specific error as shown in Postman
    Given path username, 'api', 'characters', characterId
    When method GET
    Then status 404
    * match response.error == 'Character not found'

  # POST error: nombre duplicado - Matches Postman "Crear personaje (nombre duplicado)"
  @id:6 @crear_personaje_duplicado @respuesta400
  Scenario: T-API-BTPMCDP-999-CA06-Error por nombre duplicado - karate
    # First create a character with unique name
    * def uniqueId = uuid().substring(0, 8)
    * def characterName = 'Iron Man ' + uniqueId
    * def requestBody = read('classpath:data/marvel_characters_api/request_crear_personaje_valido.json')
    * requestBody.name = characterName

    Given path username, 'api', 'characters'
    And request requestBody
    When method POST
    Then status 201

    # Then try to create another one with the same name - validation exactly as shown in Postman
    Given path username, 'api', 'characters'
    * def duplicateBody = read('classpath:data/marvel_characters_api/request_crear_personaje_duplicado.json')
    * duplicateBody.name = characterName
    And request duplicateBody
    When method POST
    Then status 400
    * match response.error == 'Character name already exists'
