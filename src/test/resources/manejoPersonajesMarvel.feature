@REQ_CERAZOHE @HU_CERAZOHE @marvel_characters @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: CERAZOHE Manejo de personajes Marvel (microservicio para gestión de personajes)

  Background:
    * url "http://bp-se-test-cabcd9b246a5.herokuapp.com"
    * def headers = read('classpath:../data/marvel_characters_api/headers_api_personajes.json')
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-CERAZOHE-CA01-Obtener todos los personajes 200 - karate
    Given path '/cerazohe/api/characters'
    When method GET
    Then status 200
    And match response == [] || response.length > 0

  @id:2 @crearPersonaje @creacionExitosa201
  Scenario Outline: T-API-CERAZOHE-CA04-Crear personaje exitosamente 201 - karate
    Given path '/cerazohe/api/characters'
    * def requestBody = read('classpath:../data/marvel_characters_api/request_crear_personaje.json')
    * print requestBody
    And request requestBody
    When method POST
    Then status 201
    And match response.name == '<name>'
    And match response.id != null

    Examples:
      | read('classpath:data/marvel_characters_api/crear_personaje.csv') |

  @id:3 @crearPersonaje @errorValidacion400
  Scenario: T-API-CERAZOHE-CA05-Crear personaje con nombre duplicado 400 - karate
    Given path '/cerazohe/api/characters'
    And request read('classpath:data/marvel_characters_api/request_crear_personaje_duplicado.json')
    When method POST
    Then status 400
    And match response.error contains 'already exists'

  @id:4 @crearPersonaje @errorValidacion400
  Scenario: T-API-CERAZOHE-CA06-Crear personaje con datos inválidos 400 - karate
    Given path '/cerazohe/api/characters'
    And request read('classpath:data/marvel_characters_api/request_crear_personaje_invalido.json')
    When method POST
    Then status 400
    And match response.name contains 'required'
    And match response.powers contains 'required'


  @id:5 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-CERAZOHE-CA02-Obtener personaje por ID exitoso 200 - karate
    # Obtener todos los personajes y seleccionar un id existente
    Given path '/cerazohe/api/characters'
    When method GET
    Then status 200
    * def personajes = response
    * def idExistente = personajes.length > 0 ? personajes[0].id : null
    # Validar que existe al menos un personaje
    * match idExistente != null
    # Consultar el personaje usando el id obtenido dinámicamente
    Given path '/cerazohe/api/characters', idExistente
    When method GET
    Then status 200
    And match response.id == idExistente
    And match response.name != null

  @id:6 @obtenerPersonajePorId @noEncontrado404
  Scenario: T-API-CERAZOHE-CA03-Obtener personaje por ID no existe 404 - karate
    Given path '/cerazohe/api/characters/999'
    When method GET
    Then status 404
    And match response.error contains 'not found'

  @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario Outline: T-API-CERAZOHE-CA07-Actualizar personaje exitosamente 200 - karate
    # Consultar ids existentes antes de actualizar
    Given path '/cerazohe/api/characters'
    When method GET
    Then status 200
    * def personajes = response
    * def idExistente = personajes.length > 0 ? personajes[0].id : null
    * match idExistente != null
    # Sobrescribir el valor de <id> con un id existente
    * def id = idExistente
    Given path '/cerazohe/api/characters', id
    * def requestBody = read('classpath:../data/marvel_characters_api/request_actualizar_personaje.json')
    * print requestBody
    And request requestBody
    When method PUT
    Then status 200
    And match response.description == '<description>'

    Examples:
      | read('classpath:data/marvel_characters_api/actualizar_personaje.csv') |

  @id:8 @actualizarPersonaje @noEncontrado404
  Scenario Outline: T-API-CERAZOHE-CA08-Actualizar personaje no existe 404 - karate
    Given path '/cerazohe/api/characters/999'
    * def requestBody =  read('classpath:data/marvel_characters_api/request_actualizar_personaje.json')
    * print requestBody
    And request requestBody
    When method PUT
    Then status 404
    And match response.error contains 'not found'
    Examples:
      | read('classpath:data/marvel_characters_api/actualizar_personaje.csv') |

  @id:9 @eliminarPersonaje @eliminacionExitosa204
  Scenario: T-API-CERAZOHE-CA09-Eliminar personaje exitosamente 204 - karate
    # Obtener un id existente antes de eliminar
    Given path '/cerazohe/api/characters'
    When method GET
    Then status 200
    * def personajes = response
    * def idExistente = personajes.length > 0 ? personajes[0].id : null
    * match idExistente != null
    Given path '/cerazohe/api/characters', idExistente
    When method DELETE
    Then status 204

  @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-CERAZOHE-CA10-Eliminar personaje no existe 404 - karate
    Given path '/cerazohe/api/characters/999'
    When method DELETE
    Then status 404
    And match response.error contains 'not found'

  @id:11 @errorInterno @errorServicio500
  Scenario: T-API-CERAZOHE-CA12-Error interno del servidor 500 - karate
    Given path '/cerazohe/api/characters'
    * def errorRequest = read('classpath:data/marvel_characters_api/request_crear_personaje_500.json')
    And request errorRequest
    When method POST
    Then status 500
    And match response.error contains 'Internal server error'
