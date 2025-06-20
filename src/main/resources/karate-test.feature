Feature: MARVELAPI-2023 Marvel Characters API Tests

  Background:
    * url port_marvel_characters_api
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers
  

  Scenario: Get all characters
    * path '/characters'
    When method get
    Then status 200
    And match response == '#array'

  Scenario: Crear personaje exitosamente
    * path '/characters'
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    And request jsonData
    When method post
    Then status 201
    And match response.name == jsonData.name

  Scenario: Get character by id 
    # Create a character
    * path '/characters'
    * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character_thor.json')
    And request createCharacterRequest
    When method post
    Then status 201
    * def characterId = response.id
    
    # Get it back by id
    * path '/characters/', characterId
    When method get
    Then status 200
    And match response.id == characterId
    And match response.name == createCharacterRequest.name

  # @id:3 @getCharacterById @solicitudNoEncontrado404
  # Scenario: T-API-MARVELAPI-2023-CA03-Obtener personaje por ID inexistente 404 - karate
  #   * path '/characters/999999'
  #   When method get
  #   Then status 404
  #   # And match response.error == 'Character not found'
  #   # And match response == { error: 'Character not found' }

  # #===========================
  # # POST ENDPOINTS TESTS
  # #===========================
  


  # @id:5 @createCharacter @errorDuplicado400
  # Scenario: T-API-MARVELAPI-2023-CA05-Crear personaje con nombre duplicado 400 - karate
  #   # Primero creamos un personaje
  #   * path '/characters'
  #   * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
  #   And request jsonData
  #   When method post
  #   Then status 201
    
  #   # Intentamos crear otro con el mismo nombre
  #   * path '/characters'
  #   And request jsonData
  #   When method post
  #   Then status 400
  #   # And match response.error == 'Character name already exists'
  #   # And match response == { error: 'Character name already exists' }

  # @id:6 @createCharacter @errorValidacion400
  # Scenario: T-API-MARVELAPI-2023-CA06-Crear personaje con campos requeridos faltantes 400 - karate
  #   * path '/characters'
  #   * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_empty.json')
  #   And request jsonData
  #   When method post
  #   Then status 400
  #   # And match response.name == 'Name is required'
  #   # And match response.alterego == 'Alterego is required'

  # #===========================
  # # PUT ENDPOINTS TESTS
  # #===========================
  
  # @id:7 @updateCharacter @solicitudExitosa200
  # Scenario: T-API-MARVELAPI-2023-CA07-Actualizar personaje exitosamente 200 - karate
  #   # Primero creamos un personaje
  #   * path '/characters'
  #   * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character.json')
  #   And request createCharacterRequest
  #   When method post
  #   Then status 201
  #   * def characterId = response.id
    
  #   # Ahora actualizamos el personaje
  #   * path '/characters/', characterId
  #   * def updateCharacterRequest = read('classpath:data/marvel_characters_api/request_update_character.json')
  #   And request updateCharacterRequest
  #   When method put
  #   Then status 200
  #   # And match response.description == 'Updated description'
  #   # And match response.powers contains 'Repulsors'

  # @id:8 @updateCharacter @solicitudNoEncontrado404
  # Scenario: T-API-MARVELAPI-2023-CA08-Actualizar personaje inexistente 404 - karate
  #   * path '/characters/999999'
  #   * def updateCharacterRequest = read('classpath:data/marvel_characters_api/request_update_character.json')
  #   And request updateCharacterRequest
  #   When method put
  #   Then status 404
  #   # And match response.error == 'Character not found'
  #   # And match response == { error: 'Character not found' }

  # #===========================
  # # DELETE ENDPOINTS TESTS
  # #===========================
  
  # @id:9 @deleteCharacter @solicitudExitosa204
  # Scenario: T-API-MARVELAPI-2023-CA09-Eliminar personaje exitosamente 204 - karate
  #   # Primero creamos un personaje
  #   * path '/characters'
  #   * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character.json')
  #   And request createCharacterRequest
  #   When method post
  #   Then status 201
  #   * def characterId = response.id
    
  #   # Ahora eliminamos el personaje
  #   * path '/characters/', characterId
  #   When method delete
  #   Then status 204
    
  #   # Verificamos que se haya eliminado
  #   * path '/characters/', characterId
  #   When method get
  #   Then status 404

  # @id:10 @deleteCharacter @solicitudNoEncontrado404
  # Scenario: T-API-MARVELAPI-2023-CA10-Eliminar personaje inexistente 404 - karate
  #   * path '/characters/999999'
  #   When method delete
  #   Then status 404
  #   # And match response.error == 'Character not found'
  #   # And match response == { error: 'Character not found' }
