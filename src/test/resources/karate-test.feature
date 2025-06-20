@EvaluacionAPI
Feature: Evaluación API SUPER SIMPLE

  Background:
    * def base_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * configure ssl = true

    @id:1 @ObtenerPersonajes
    Scenario: T-API-001-CA01- Obtener Personajes
        Given url base_url + '/testuser/api/characters'
        When method GET
        Then status 200
        And print response

    @id:2 @ObtenerPersonajePorId
    Scenario: T-API-001-CA02- Obtener Personajes por Id
        Given url base_url + '/testuser/api/characters/14'
        When method GET
        Then status 200
        And print response

    @id:3 @ObtenerPersonajePorIdNoExiste
    Scenario: T-API-001-CA03- Obtener Personajes por Id no Existe
        Given url base_url + '/testuser/api/characters/999'
        When method GET
        Then status 404
        And print response

    @id:4 @CrearPersonaje
    Scenario: T-API-001-CA04- Crear Personaje Json
        Given url base_url + '/testuser/api/characters'
        And def personajeJson = read('classpath:../personaje.json')
        And request personajeJson
        When method POST
        Then status 201
        And print response

    @id:5 @CrearPersonajeDuplicado
    Scenario: T-API-001-CA05- Crear Personaje Json duplicado
        Given url base_url + '/testuser/api/characters'
        And def personajeJson = read('classpath:../personaje.json')
        And request personajeJson
        When method POST
        Then status 400
        And print response

    @id:6 @CrearPersonajeFaltaDatos
    Scenario: T-API-001-CA06- Crear Personaje Json falta datos
        Given url base_url + '/testuser/api/characters'
        And def personajeJson = read('classpath:../faltaDatos.json')
        And request personajeJson
        When method POST
        Then status 400
        And print response

    @id:7 @ActualizarDatosPersonaje
    Scenario: T-API-001-CA07- Actualizar datos de personaje
        Given url base_url + '/testuser/api/characters/16'
        And def personajeJson = read('classpath:../personaje.json')
        And request personajeJson
        When method PUT
        Then status 200
        And print response
