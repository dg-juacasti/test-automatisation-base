@REQ_HU-0001 @HU0001 @marvel_characters_query @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-0001 Marvel Characters Query (microservicio para consulta de personajes)

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
    * def getCurrentTimestamp =
      """
      function() {
        return java.lang.System.currentTimeMillis();
      }
      """

    @id:1 @getCharacters @solicitudExitosa200
    Scenario: T-API-HU-0001-CA01-Obtener todos los personajes 200 - karate
      Given path '/characters'
      When method get
      Then status 200
      And match response == '#array'

    @id:2 @getCharacterById @solicitudExitosa200
    Scenario: T-API-HU-0001-CA02-Obtener personaje por ID 200 - karate
      # Primero creamos un personaje para asegurarnos que exista
      Given path '/characters'
      * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character_spiderman.json')
      * createCharacterRequest.name += '_' + getCurrentTimestamp() 
      And request createCharacterRequest
      When method post
      Then status 201
      * def characterId = response.id
    
      # Ahora obtenemos el personaje por ID
      Given path '/characters/', characterId
      When method get
      Then status 200
      And match response.id == characterId
      And match response.name == createCharacterRequest.name
      
    @id:3 @getCharacterById @solicitudNoEncontrado404
    Scenario: T-API-HU-0001-CA03-Obtener personaje por ID inexistente 404 - karate
      Given path '/characters/999999999'
      When method get
      Then status 404
      And match response.error == 'Character not found'
      And match response == { error: 'Character not found' }
