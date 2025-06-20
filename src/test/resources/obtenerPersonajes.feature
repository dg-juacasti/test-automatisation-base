@REQ_CHARACTERS-001 @HU001 @characters_api @characters @Agente2 @E2 @iniciativa_characters
Feature: CHARACTERS-001 API de personajes completa (microservicio para obtener personajes)
  Background:
    * url "http://bp-se-test-cabcd9b246a5.herokuapp.com"
    * configure ssl = true
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

  @id:1 @consultarPersonajes @listadoExitoso200
  Scenario: T-API-CHARACTERS-001-CA01-Consultar lista de personajes exitosamente 200 - karate
    * path '/l2mt/api/characters'
    When method GET
    Then status 200
    And match response == "#[]"
    # And match response != null

  @id:2 @consultarPersonaje @personajeExitoso200
  Scenario: T-API-CHARACTERS-001-CA02-Consultar personaje por ID exitosamente 200 - karate
    # Crear personaje de prueba
    * path '/l2mt/api/characters'
    * def testCharacterData = { name: 'Capitán América Test 1', alterego: 'Steve Rogers', description: 'Superhéroe patriótico de Marvel para pruebas', powers: ['Fuerza sobrehumana', 'Escudo indestructible', 'Liderazgo'] }
    * request testCharacterData
    * method POST
    * status 201
    * def testCharacterId = response.id
    
    # Consultar el personaje creado
    * path '/l2mt/api/characters/' + testCharacterId
    When method GET
    Then status 200
    And match response.id == testCharacterId
    And match response.name == 'Capitán América Test 1'
    And match response.alterego == 'Steve Rogers'
    And match response.description == 'Superhéroe patriótico de Marvel para pruebas'
    And match response.powers == ['Fuerza sobrehumana', 'Escudo indestructible', 'Liderazgo']
    
    # Cleanup: Eliminar el personaje creado
    * path '/l2mt/api/characters/' + testCharacterId
    * method DELETE

  @id:3 @consultarPersonaje @personajeInexistente404
  Scenario: T-API-CHARACTERS-001-CA03-Consultar personaje inexistente 404 - karate
    * path '/l2mt/api/characters/9999'
    When method GET
    Then status 404
    # And match response.message contains 'not found'
    # And match response.status == 404
