@REQ_CHARACTERS-003 @HU003 @actualizar_personajes @characters @Agente2 @E2 @iniciativa_characters
Feature: CHARACTERS-003 Actualizar personajes (microservicio para actualizar personajes)
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

  @id:1 @actualizarPersonaje @actualizacionExitosa200
  Scenario: T-API-CHARACTERS-003-CA01-Actualizar personaje Hulk exitosamente 200 - karate
    # Crear personaje Hulk de prueba
    * path '/l2mt/api/characters'
    * def hulkCharacterData = { name: 'Hulk', alterego: 'Bruce Banner 2', description: 'Científico que se transforma en un gigante verde', powers: ['Fuerza sobrehumana', 'Resistencia extrema', 'Regeneración acelerada'] }
    * request hulkCharacterData
    * method POST
    * status 201
    * def hulkCharacterId = response.id
    
    # Actualizar el personaje Hulk creado
    * path '/l2mt/api/characters/' + hulkCharacterId
    * def updatedHulkData = { name: 'Hulk', alterego: 'Bruce Banner', description: 'Científico que se transforma en un gigante verde (actualizado)', powers: ['Fuerza sobrehumana', 'Resistencia extrema', 'Regeneración acelerada'] }
    * request updatedHulkData
    When method PUT
    Then status 200
    And match response.id == hulkCharacterId
    And match response.name == 'Hulk'
    And match response.alterego == 'Bruce Banner'
    And match response.description == 'Científico que se transforma en un gigante verde (actualizado)'
    And match response.powers == ['Fuerza sobrehumana', 'Resistencia extrema', 'Regeneración acelerada']
    
    # Cleanup: Eliminar el personaje creado
    * path '/l2mt/api/characters/' + hulkCharacterId
    * method DELETE

  @id:2 @actualizarPersonaje @personajeInexistente404
  Scenario: T-API-CHARACTERS-003-CA02-Actualizar personaje inexistente 404 - karate
    * path '/l2mt/api/characters/9999'
    * def updateData = { name: 'No existe', alterego: 'Nadie', description: 'No existe', powers: ['Nada'] }
    * request updateData
    When method PUT
    Then status 404

  @id:3 @actualizarPersonaje @errorValidacion400
  Scenario: T-API-CHARACTERS-003-CA03-Actualizar personaje con datos inválidos 400 - karate
    # Crear personaje Hulk de prueba
    * path '/l2mt/api/characters'
    * def hulkCharacterData = { name: 'Hulk Test', alterego: 'Bruce Banner', description: 'Personaje de prueba', powers: ['Fuerza sobrehumana'] }
    * request hulkCharacterData
    * method POST
    * status 201
    * def hulkCharacterId = response.id
    
    # Intentar actualizar con datos inválidos (sin nombre)
    * path '/l2mt/api/characters/' + hulkCharacterId
    * def invalidUpdateData = { name: '', alterego: 'Bruce Banner', description: 'Datos inválidos', powers: [] }
    * request invalidUpdateData
    When method PUT
    Then status 400
    
    # Cleanup: Eliminar el personaje creado
    * path '/l2mt/api/characters/' + hulkCharacterId
    * method DELETE
