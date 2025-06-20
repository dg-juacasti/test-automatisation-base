@REQ_HU-Geraldson001 @HU-Geraldson001 @marvel_characters @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-Geraldson001 Automatización de Marvel Characters API (microservicio para gestión de personajes)

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/gaperez/api/characters'
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

  @id:1 @consultarPersonajes @exitoso200
  Scenario: T-API-HU-Geraldson001-CA01-Consultar todos los personajes exitosamente 200 
    When method GET
    Then status 200

  @id:2 @consultarPorId @exitoso200
  Scenario: T-API-HU-Geraldson001-CA02-Consultar personaje por id exitosamente 200 
    * def unique = java.util.UUID.randomUUID() + ''
    * def personaje = { "name": "Test Consultar ", "alterego": "Test", "description": "Test", "powers": ["Test"] }
    * set personaje.name = 'Test Personaje ' + unique
    And request personaje
    When method POST
    Then status 201
    * def idCreado = response.id
    * path idCreado
    When method GET
    Then status 200
    And match response.id == idCreado

  @id:3 @consultarPorId @noEncontrado404
  Scenario: T-API-HU-Geraldson001-CA03-Consultar personaje por id no existente 404 
    * path '999999'
    When method GET
    Then status 404
    And match response.error == 'Character not found'

  @id:4 @crearPersonaje @exitoso201
  Scenario: T-API-HU-Geraldson001-CA04-Crear personaje exitosamente 201 
    * def unique = java.util.UUID.randomUUID() + ''
    * def jsonData = read('classpath:data/marvel_characters_api/create_character_request.json')
    * set jsonData.name = 'Test Personaje ' + unique
    And request jsonData
    When method POST
    Then status 201


  @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-HU-Geraldson001-CA05-Crear personaje con nombre duplicado 400 
    * def jsonData = read('classpath:data/marvel_characters_api/create_character_duplicate_request.json')
    And request jsonData
    When method POST
    Then status 400
    And match response.error == 'Character name already exists'

  @id:6 @crearPersonaje @camposRequeridos400
  Scenario: T-API-HU-Geraldson001-CA06-Crear personaje con campos requeridos vacíos 400 
    * def jsonData = { "name": "", "alterego": "", "description": "", "powers": [] }
    And request jsonData
    When method POST
    Then status 400
    And match response.name == 'Name is required'
    And match response.description == 'Description is required'

  @id:7 @actualizarPersonaje @exitoso200
  Scenario: T-API-HU-Geraldson001-CA07-Actualizar personaje exitosamente 200 
    * def personaje = { "name": "Test Update", "alterego": "Test", "description": "Test", "powers": ["Test"] }
    And request personaje
    When method POST
    Then status 201
    * def idCreado = response.id
    * path idCreado
    * def jsonData = { "name": "Iron Man", "alterego": "Tony Stark", "description": "Updated description", "powers": ["Armor", "Flight"] }
    And request jsonData
    When method PUT
    Then status 200
    And match response.id == idCreado
    And match response.description == 'Updated description'

  @id:8 @actualizarPersonaje @noEncontrado404
  Scenario: T-API-HU-Geraldson001-CA08 Actualizar personaje no existente 404
    * path '999999'
    * def jsonData = { "name": "Iron Man", "alterego": "Tony Stark", "description": "Updated description", "powers": ["Armor", "Flight"] }
    And request jsonData
    When method PUT
    Then status 404
    And match response.error == 'Character not found'

  @id:9 @eliminarPersonaje @exitoso204
  Scenario: T-API-HU-Geraldson001-CA09 Eliminar personaje exitosamente 204
    * def personaje = { "name": "Test Delete", "alterego": "Test", "description": "Test", "powers": ["Test"] }
    And request personaje
    When method POST
    Then status 201
    * def idCreado = response.id
    * path idCreado
    When method DELETE
    Then status 204

  @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-HU-Geraldson001-CA10 Eliminar personaje no existente 404
    * path '999999'
    When method DELETE
    Then status 404
    And match response.error == 'Character not found'
