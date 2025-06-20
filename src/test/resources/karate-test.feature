Feature: Test de API super simple

  Background:
    * configure ssl = true
    ## Definición de la URL base para los endpoints
    * def baseUrl = 'http://localhost:8080/mcastroq/api/characters'

        @id:1 @EndpointWithHeader @Response200
    Scenario: T-API-BDTO-001-CA1 - Verificar que el endpoint responde 200 con un header
        Given url baseUrl
        And header Content-Type = 'application/json'
        When method get
        Then status 200
        And print response

    @id:2 @EndpointToUpdateHero @Response201
    Scenario: T-API-BDTO-001-CA2 - Crear un nuevo personaje
        Given url baseUrl
        And header Content-Type = 'application/json'
        And request { "name": "Robot_ATS","alterego": "ROBOT ATS", "description": "Genius billionaire", "powers": ["Super Fuerza para ayudar a los demás", "Flight"]}
        When method post
        Then status 201
        And print response

    @id:3 @EndpointToVerifyHeroCreated @Response200
    Scenario: T-API-BDTO-001-CA3 - Verificar que el personaje fue creado
        Given url baseUrl + '/5' // Asumiendo que el ID es el del personaje recién creado
        And header Content-Type = 'application/json'
        When method get
        Then status 200
        And print response


    @id:4 @EndpointToCreateHeroDuplicated @Response400
      Scenario: T-API-BDTO-001-CA4 - Crear personaje (nombre duplicado, error 400)
        Given url baseUrl
        And header Content-Type = 'application/json'
        And request { "name": "Robot_ATS","alterego": "ROBOT ATS", "description": "Genius billionaire", "powers": ["Super Fuerza para ayudar a los demás", "Flight"]}
        When method post
        Then status 400
        And print response

    @id:5 @EndpointToGetHeroThatNotExists @Response404
    Scenario:  T-API-BDTO-001-CA5 - Obtener personaje inexistente (error 404)
        Given url baseUrl + '/77' // Asumiendo que el ID no existe
        And header Content-Type = 'application/json'
        When method get
        Then status 404
        And print response
    @id:6 @EndpointToUpdateHero @Response200
      Scenario:   T-API-BDTO-001-CA6 - Actualizar el personaje
      Given url baseUrl + '/5'
      And header Content-Type = 'application/json'
      And request { "name": "Robot ATS 3000","alterego": "ROBOT ATS 3000", "description": "Genius billionaire x 2", "powers": ["Super Fuerza para ayudar a los demás", "Flight", "Inmortalidad"]}
      When method put
      Then status 200
      And print response

    @id:6 @EndpointToUpdateHeroThatNotExists @Response404
    Scenario: T-API-BDTO-001-CA7 - Actualizar personaje inexistente (error 404)
      Given url baseUrl + '/1'
      And header Content-Type = 'application/json'
      And request { "name": "Robot ATS 3000","alterego": "ROBOT ATS 3000", "description": "Genius billionaire x 2", "powers": ["Super Fuerza para ayudar a los demás", "Flight", "Inmortalidad"]}
      When method put
      Then status 404
      And print response

    @id:7 @EndpointToDeleteHero @Response204
    Scenario: T-API-BDTO-001-CA8 - Eliminar personaje (válido)
      Given url baseUrl + '/5'
      And header Content-Type = 'application/json'
      When method delete
      Then status 204
      And print response

    @id:8 @EndpointToDeleteHeroThatNotExists @Response404
    Scenario: T-API-BDTO-001-CA9 - Eliminar personaje inexistente (error 404)
      Given url baseUrl + '/1'
      And header Content-Type = 'application/json'
      When method delete
      Then status 404
      And print response

    @id:9 @EndpointToGetAllHeroes @Response200
    Scenario: T-API-BDTO-001-CA10 - Obtener todos los personajes
      Given url baseUrl
      And header Content-Type = 'application/json'
      When method get
      Then status 200
      And print response
