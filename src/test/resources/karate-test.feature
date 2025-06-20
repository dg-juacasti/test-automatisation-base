@ExamenPractico
Feature:
Evaluación de conocimiento práctico - chapte 20-06-2025 GABRIELA VALLADARES jevallad
Background:
    * def base_url = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/jevallad/api'
    * header content-type = 'application/json'
    * configure ssl = true

@id:1 @ConsultaPersonaje
    Scenario: T-API-BTFAC-123-CA01- Consultar Personaje
        Given url base_url + '/characters'
        When method GET
        Then status 200
        And print response

@id:2 @AgregarPersonaje
    Scenario: T-API-BTFAC-123-CA03- Agregar nuevo personaje
        Given url base_url + '/characters'
        And def personaje = read('classpath:../payloads/Personajes.json')
        And request personaje
        When method POST
        Then status 201
        And print response
        And match response.name == 'Spiderman'

@id:3 @EliminaPersonajeConData
    Scenario: T-API-BTFAC-123-CA06- Eliminar un Personaje
        * def personaje = call read('karate-test.feature@ConsultaPersonaje')
        * print personaje
        * def personajeId = 2
        Given url base_url + '/characters/' + personajeId
        When method DELETE
        Then status 204
        * print response

@id:4 @EditarPersonaje
    Scenario: T-API-BTFAC-123-CA06- Editar un Personaje
        * def personaje = call read('karate-test.feature@ConsultaPersonaje')
        * print personaje
        * def personajeId = 4
        Given url base_url + '/characters/' + personajeId
        And def nuevoPersonaje = read('classpath:../payloads/PersonajesEditar.json')
        And request nuevoPersonaje
        When method PUT
        Then status 200
        * print response

@id:5 @EliminaPersonajeNoExiste
    Scenario: T-API-BTFAC-123-CA06- Eliminar un Personaje que No existe
        * def personaje = call read('karate-test.feature@ConsultaPersonaje')
        * print personaje
        * def personajeId = 2
        Given url base_url + '/characters/' + personajeId
        When method DELETE
        Then status 404
        * print response

@id:6 @EditarPersonajeNoExiste
    Scenario: T-API-BTFAC-123-CA06- Editar un Personaje que No existe
        * def personaje = call read('karate-test.feature@ConsultaPersonaje')
        * print personaje
        * def personajeId = 4
        Given url base_url + '/characters/' + personajeId
        And def nuevoPersonaje = read('classpath:../payloads/PersonajesEditar.json')
        And request nuevoPersonaje
        When method PUT
        Then status 404
        * print response
  
@id:7 @ConsultaPersonajeConData
    Scenario: T-API-BTFAC-123-CA01- Consultar Personaje con data
        Given url base_url + '/characters/4'
        When method GET
        Then status 200
        And print response

@id:8 @ConsultaPersonajeConDataNoExiste
    Scenario: T-API-BTFAC-123-CA01- Consultar Personaje con data que no existe
        Given url base_url + '/characters/10'
        When method GET
        Then status 404
        And print response