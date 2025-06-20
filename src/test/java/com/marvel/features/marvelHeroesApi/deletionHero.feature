@REQ_HU-0004 @HU0004 @marvel_characters_deletion @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-0004 Marvel Characters Deletion (microservicio para eliminación de personajes)

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

  @id:1 @deleteCharacter @solicitudExitosa204
  Scenario: T-API-HU-0004-CA01-Eliminar personaje exitosamente 204 - karate
    # Primero creamos un personaje
    Given path '/characters'
    * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character.json')
    * createCharacterRequest.name += '_' + getCurrentTimestamp() 
    And request createCharacterRequest
    When method post
    Then status 201
    * def characterId = response.id
    
    # Ahora eliminamos el personaje
    * path '/characters/', characterId
    When method delete
    Then status 204
    
    # Verificamos que se haya eliminado
    * path '/characters/', characterId
    When method get
    Then status 404
    And match response.error == 'Character not found'
    And match response == { error: 'Character not found' }

  @id:2 @deleteCharacter @solicitudNoEncontrado404
  Scenario: T-API-HU-0004-CA02-Eliminar personaje inexistente 404 - karate
    Given path '/characters/999999'
    When method delete
    Then status 404
    And match response.error == 'Character not found'
    And match response == { error: 'Character not found' }