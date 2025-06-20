@REQ_CHARACTERS-003 @HU003 @eliminar_personajes @characters @Agente2 @E2 @iniciativa_characters
Feature: CHARACTERS-003 Eliminar personajes (microservicio para eliminar personajes)
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

  @id:1 @eliminarPersonaje @eliminacionExitosa200 @cleanup
  Scenario: T-API-CHARACTERS-003-CA01-Eliminar personaje exitosamente 200 - karate
    # Crear personaje de prueba (Pantera Negra)
    * path '/l2mt/api/characters'
    * def testCharacterData = { name: 'Pantera Negra Test', alterego: 'T\'Challa', description: 'Rey de Wakanda y superhéroe de Marvel para pruebas', powers: ['Fuerza sobrehumana', 'Agilidad felina', 'Vibranium suit', 'Liderazgo'] }
    * request testCharacterData
    * method POST
    * status 201
    * def testCharacterId = response.id
    
    # Eliminar el personaje creado
    * path '/l2mt/api/characters/' + testCharacterId
    When method DELETE
    Then status 204

  @id:2 @eliminarPersonaje @personajeInexistente404
  Scenario: T-API-CHARACTERS-003-CA02-Eliminar personaje inexistente 404 - karate
    * path '/l2mt/api/characters/9999'
    When method DELETE
    Then status 404
    # And match response.message contains 'not found'
    # And match response.status == 404

