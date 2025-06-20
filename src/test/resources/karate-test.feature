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
