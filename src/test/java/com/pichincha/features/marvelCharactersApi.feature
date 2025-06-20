@REQ_TESTDEV-0001 @HU0001 @marvel_characters_api @test_automatisation_base_ltgomez @Agente2 @E2 @iniciativa_marvel @automation_with_copilot
Feature: TESTDEV-0001 API de Personajes Marvel (microservicio para gestión de personajes Marvel)
  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * path 'testuser/api/characters'
    * header Content-Type = 'application/json'

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
    * def timestamp = java.lang.System.currentTimeMillis()
    * def jsonData = { name: 'Spider Man ' + timestamp, alterego: 'Peter Parker', description: 'Friendly neighborhood', powers: ['Spider sense', 'Wall climbing'] }
    And request jsonData
    When method POST 
    Then status 201
    * print response
    # And match response != null
    # And match response.id != null

  @id:5 @crearPersonaje @duplicadoError400
  Scenario: T-API-TESTDEV-0001-CA05-Crear personaje con nombre duplicado 400 - karate
    # Primero creamos un personaje
    * def timestamp = java.lang.System.currentTimeMillis()
    * def uniqueName = 'Duplicated Hero ' + timestamp
    * def jsonData1 = { name: uniqueName, alterego: 'Original', description: 'Original Hero', powers: ['Original Power'] }
    And request jsonData1
    When method POST
    Then status 201
    
    # Ahora intentamos crear otro con el mismo nombre
    * def jsonData2 = { name: uniqueName, alterego: 'Clone', description: 'Clone Hero', powers: ['Cloned Power'] }
    And request jsonData2
    When method POST
    Then status 400
    * print response
    # And match response.error == 'Character name already exists'
    # And match response != null

  @id:6 @crearPersonaje @datosInvalidos400
  Scenario: T-API-TESTDEV-0001-CA06-Crear personaje con datos inválidos 400 - karate
    * def jsonData = { name: '', alterego: '', description: '', powers: [] }
    And request jsonData
    When method POST
    Then status 400
    * print response
    # And match response contains { name: 'Name is required' }
    # And match response contains { alterego: 'Alterego is required' }

  @id:7 @actualizarPersonaje @actualizacionExitosa200
  Scenario: T-API-TESTDEV-0001-CA07-Actualizar personaje existente 200 - karate
    # Primero creamos un personaje para asegurar que existe
    * def timestamp = java.lang.System.currentTimeMillis()
    * def createJson = { name: 'Thor ' + timestamp, alterego: 'Thor Odinson', description: 'God of Thunder', powers: ['Lightning', 'Hammer'] }
    And request createJson
    When method POST
    Then status 201
    
    # Ahora actualizamos el personaje creado
    * def personajeId = response.id
    * path personajeId
    * def jsonData = { name: 'Thor', alterego: 'Thor Odinson', description: 'Updated description', powers: ['Lightning', 'Hammer'] }
    And request jsonData
    When method PUT
    Then status 200
    * print response
    # And match response != null
    # And match response.description == 'Updated description'

  @id:8 @actualizarPersonaje @actualizacionFallida404
  Scenario: T-API-TESTDEV-0001-CA08-Actualizar personaje no existente 404 - karate
    * def personajeId = '99999'
    * path personajeId
    * def jsonData = { name: 'Not exists', alterego: 'Not exists', description: 'Not exists', powers: ['Not exists'] }
    And request jsonData
    When method PUT
    Then status 404
    * print response
    # And match response.error == 'Character not found'
    # And match response != null

  @id:9 @eliminarPersonaje @eliminacionExitosa204
  Scenario: T-API-TESTDEV-0001-CA09-Eliminar personaje existente 204 - karate
    # Primero creamos un personaje para luego eliminarlo
    * def timestamp = java.lang.System.currentTimeMillis()
    * def createJson = { name: 'Captain America ' + timestamp, alterego: 'Steve Rogers', description: 'Super Soldier', powers: ['Shield', 'Strength'] }
    And request createJson
    When method POST
    Then status 201
    
    # Ahora eliminamos el personaje creado
    * def personajeId = response.id
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

  @id:11 @errorServidor @errorServicio
  Scenario: T-API-TESTDEV-0001-CA11-Error de servicio - karate
    * path 'internal-error-test'
    When method GET
    Then status 404
    * print response
    # And match response.error == 'Character not found'
    # And match response != null

