@REQ_TEST-2006 @HU2006 @marvel_characters_api @marvel_characters_api @Agente2 @E2 @iniciativa_marvel_api
Feature: TEST-2006 Gestión de personajes de Marvel (microservicio para administrar personajes de Marvel)

  Background:
    * configure ssl = true
    * url port_marvel_characters_api
    * path '/' + marvel_username + '/api/characters'
    * def generarHeaders =
      """
      function() {
      return {
      "Content-Type": "application/json",
      "Host": "bp-se-test-cabcd9b246a5.herokuapp.com",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Connection": "keep-alive"
      };
      }
      """
    * def headers = generarHeaders()
    * headers headers
    * def generarNombreAleatorio =
      """
      function() {
      var superheroes = ['Iron', 'Captain', 'Thor', 'Hulk', 'Black', 'Spider', 'Doctor', 'Wonder', 'Scarlet', 'Vision'];
      var apellidos = ['Man', 'Woman', 'America', 'Panther', 'Widow', 'Strange', 'Witch', 'Lord', 'Soldier', 'Hero'];
      var random1 = Math.floor(Math.random() * superheroes.length);
      var random2 = Math.floor(Math.random() * apellidos.length);
      return superheroes[random1] + ' ' + apellidos[random2] + ' ' + java.util.UUID.randomUUID().toString().substring(0, 6);
      }
      """
    * def characterData = {}
    * def sharedData = {}

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-TEST-2006-CA01-Obtener todos los personajes 200 - karate
    When method GET
    Then status 200
  # And match response != null
  # And match response == '#array'


  @id:2 @obtenerPersonaje @noExiste404
  Scenario: T-API-TEST-2006-CA03-Obtener personaje que no existe 404 - karate
    * path '/999'
    When method GET
    Then status 404
  # And match response.error == 'Character not found'
  # And match response.error != null

  @id:3 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-TEST-2006-CA04-Crear personaje nuevo 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_valid.json')
    * def nombrePersonaje = generarNombreAleatorio()
    * set jsonData.name = nombrePersonaje
    * karate.set('characterData', jsonData)
    And request jsonData
    When method POST
    Then status 201
    And match response.id != null
    And match response.name == jsonData.name
    * set sharedData.id = response.id

  @id:4 @obtenerPersonaje @solicitudExitosa200
  Scenario: T-API-TEST-2006-CA02-Obtener personaje por ID 200 - karate
    * def jsonData = karate.get('characterData')
    * path jsonData.id
    When method GET
    Then status 200
    # And match response != null
    # And match response.id == 1

  @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-TEST-2006-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = karate.get('characterData')
    And request jsonData
    When method POST
    Then status 400
  # And match response.error == 'Character name already exists'
  # And match response.error != null


  @id:6 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-TEST-2006-CA07-Actualizar personaje existente 200 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_valid.json')
    * def nombrePersonaje = generarNombreAleatorio()
    * set jsonData.name = nombrePersonaje
    * set jsonData.description = 'Updated description for ' + jsonData.name
    * path '/' + sharedData.id
    And request jsonData
    When method PUT
    Then status 200
# And match response.description == jsonData.description
# And match response.id == jsonData.id

  @id:7 @crearPersonaje @camposInvalidos400
  Scenario: T-API-TEST-2006-CA06-Crear personaje con campos inválidos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
  # And match response.name == 'Name is required'
  # And match response.alterego == 'Alterego is required'


  @id:8 @actualizarPersonaje @noExiste404
  Scenario: T-API-TEST-2006-CA08-Actualizar personaje que no existe 404 - karate
    * path '/999'
    * def jsonData = read('classpath:data/marvel_characters_api/character_update.json')
    And request jsonData
    When method PUT
    Then status 404
  # And match response.error == 'Character not found'
  # And match response.error != null

  @id:9 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-TEST-2006-CA09-Eliminar personaje existente 204 - karate
    * path '/' + sharedData.id
    When method DELETE
    Then status 204
  # And match response == ''
  # And match responseBytes == '#[0]'

  @id:10 @eliminarPersonaje @noExiste404
  Scenario: T-API-TEST-2006-CA10-Eliminar personaje que no existe 404 - karate
    * path '/999'
    When method DELETE
    Then status 404
  # And match response.error == 'Character not found'
  # And match response.error != null

  @id:11 @errorServicio500
  Scenario: T-API-TEST-2006-CA11-Error interno del servidor 500 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/character_valid.json')
    * path '/undefined'
    And request jsonData
    When method PUT
    Then status 500
# And match response.error contains 'Internal server error'
# And match response.status == 500
