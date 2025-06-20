@REQ_HU-0002 @HU0002 @marvel_characters_creation @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-0002 Marvel Characters Creation (microservicio para creación de personajes)

  Background:
    * url port_marvel_characters_api
    * path '/characters'
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

  @id:1 @createCharacter @solicitudExitosa201
  Scenario: T-API-HU-0002-CA01-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character.json')
    * jsonData.name += '_' + getCurrentTimestamp() 
    And request jsonData
    When method post
    Then status 201
    And match response.name == jsonData.name

  @id:2 @createCharacter @errorDuplicado400
  Scenario: T-API-HU-0002-CA02-Crear personaje con nombre duplicado 400 - karate
    # Primero creamos un personaje
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_duplicate.json')
    * jsonData.name += '_' + getCurrentTimestamp() 
    And request jsonData
    When method post
    Then status 201
    
    # Intentamos crear otro con el mismo nombre
    And request jsonData
    When method post
    Then status 400
    And match response.error == 'Character name already exists'
    And match response == { error: 'Character name already exists' }

  @id:3 @createCharacter @errorValidacion400
  Scenario: T-API-HU-0002-CA03-Crear personaje con campos requeridos faltantes 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_create_character_empty.json')
    And request jsonData
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    