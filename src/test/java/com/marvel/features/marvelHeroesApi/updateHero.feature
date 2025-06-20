@REQ_HU-0003 @HU0003 @marvel_characters_update @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-0003 Marvel Characters Update (microservicio para actualización de personajes)

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

  @id:1 @updateCharacter @solicitudExitosa200
  Scenario: T-API-HU-0003-CA01-Actualizar personaje exitosamente 200 - karate
    # Primero creamos un personaje
    Given path '/characters'
    * def createCharacterRequest = read('classpath:data/marvel_characters_api/request_create_character.json')
    * createCharacterRequest.name += '_' + getCurrentTimestamp()
    And request createCharacterRequest
    When method post
    Then status 201
    * def characterId = response.id
    
    # Ahora actualizamos el personaje
    Given path '/characters/', characterId
    * def updateCharacterRequest = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request updateCharacterRequest
    When method put
    Then status 200
    And match response.description == updateCharacterRequest.description
    And match response.powers contains 'Repulsors'

  @id:2 @updateCharacter @solicitudNoEncontrado404
  Scenario: T-API-HU-0003-CA02-Actualizar personaje inexistente 404 - karate
    Given path '/characters/999999'
    * def updateCharacterRequest = read('classpath:data/marvel_characters_api/request_update_character.json')
    And request updateCharacterRequest
    When method put
    Then status 404
    And match response.error == 'Character not found'
    And match response == { error: 'Character not found' }