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
