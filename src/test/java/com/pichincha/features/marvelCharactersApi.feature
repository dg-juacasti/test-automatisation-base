@REQ_TESTDEV-0001 @HU0001 @marvel_characters_api @test_automatisation_base_ltgomez @Agente2 @E2 @iniciativa_marvel @automation_with_copilot
Feature: TESTDEV-0001 API de Personajes Marvel (microservicio para gestión de personajes Marvel)
  Background:
    * url port_test_automatisation_base_ltgomez
    * path '/testuser/api/characters'
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

  @id:1 @consultarPersonajes @listaExitosa200
  Scenario: T-API-TESTDEV-0001-CA01-Obtener todos los personajes 200 - karate
    When method GET
    Then status 200
    * print response
    # And match response != null
    # And match response == '#array'

  @id:2 @consultarPersonajePorId @personajeExistente200
  Scenario: T-API-TESTDEV-0001-CA02-Obtener personaje por ID existente 200 - karate
    * def personajeId = '1'
    * path personajeId
    When method GET
    Then status 200
    * print response
    # And match response != null
    # And match response.name == 'Iron Man'

  @id:3 @consultarPersonajePorId @personajeNoExistente404
  Scenario: T-API-TESTDEV-0001-CA03-Obtener personaje por ID no existente 404 - karate
    * def personajeId = '999'
    * path personajeId
    When method GET
    Then status 404
    * print response
    # And match response.error == 'Character not found'
    # And match response != null

  @id:4 @crearPersonaje @creacionExitosa201
  Scenario: T-API-TESTDEV-0001-CA04-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/test-automatisation-base-ltgomez/request_create_character.json')
    And request jsonData
    When method POST
    Then status 201
    * print response
    # And match response != null
    # And match response.id != null

  @id:5 @crearPersonaje @duplicadoError400
  Scenario: T-API-TESTDEV-0001-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/test-automatisation-base-ltgomez/request_duplicate_character.json')
    * jsonData.name = 'Iron Man'
    And request jsonData
    When method POST
    Then status 400
    * print response
    # And match response.error == 'Character name already exists'
    # And match response != null

  @id:6 @crearPersonaje @datosInvalidos400
  Scenario: T-API-TESTDEV-0001-CA06-Crear personaje con datos inválidos 400 - karate
    * def jsonData = read('classpath:data/test-automatisation-base-ltgomez/request_invalid_character.json')
    And request jsonData
    When method POST
    Then status 400
    * print response
    # And match response contains { name: 'Name is required' }
    # And match response contains { alterego: 'Alterego is required' }

  @id:7 @actualizarPersonaje @actualizacionExitosa200
  Scenario: T-API-TESTDEV-0001-CA07-Actualizar personaje existente 200 - karate
    * def personajeId = '1'
    * path personajeId
    * def jsonData = read('classpath:data/test-automatisation-base-ltgomez/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 200
    * print response
    # And match response != null
    # And match response.description == 'Updated description'

  @id:8 @actualizarPersonaje @actualizacionFallida404
  Scenario: T-API-TESTDEV-0001-CA08-Actualizar personaje no existente 404 - karate
    * def personajeId = '999'
    * path personajeId
    * def jsonData = read('classpath:data/test-automatisation-base-ltgomez/request_update_character.json')
    And request jsonData
    When method PUT
    Then status 404
    * print response
    # And match response.error == 'Character not found'
    # And match response != null

  @id:9 @eliminarPersonaje @eliminacionExitosa204
  Scenario: T-API-TESTDEV-0001-CA09-Eliminar personaje existente 204 - karate
    * def personajeId = '1'
    * path personajeId
    When method DELETE
    Then status 204
    * print response
    # And match response == ''
    # And match responseBytes == ''

  @id:10 @eliminarPersonaje @eliminacionFallida404
  Scenario: T-API-TESTDEV-0001-CA10-Eliminar personaje no existente 404 - karate
    * def personajeId = '999'
    * path personajeId
    When method DELETE
    Then status 404
    * print response
    # And match response.error == 'Character not found'
    # And match response != null

  @id:11 @errorServidor @errorInterno500
  Scenario: T-API-TESTDEV-0001-CA11-Error interno del servidor 500 - karate
    * def personajeId = 'error'
    * path personajeId
    When method GET
    Then status 500
    * print response
    # And match response.error contains 'Internal Server Error'
    # And match response != null

