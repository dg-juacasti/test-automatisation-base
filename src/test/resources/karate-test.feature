@REQ_BIL_1 @marvel
Feature: Test de API de marvel characters

  Background:
    * configure ssl = true
  @id:1 @ObtenerTodosPersonajes
  Scenario: T-API-BIL-1-CA1-Obtener todos lo personajes
    * def path = '/api/characters'
    Given url baseUrl + path
    When method get
    Then status 200
    * print response

  @id:2 @CrearPersonaje
  Scenario: T-API-BIL-1-CA2-Crear personaje
    * def path = '/api/characters'
    * header Content-Type = 'application/json'
    * def requestBody = read('classpath:../data/character-save-request.json')
    * def randomNumber = Math.round(Math.random() * 10000)
    * set requestBody.name = requestBody.name + '_' + randomNumber
    * print 'Creating character', requestBody
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 201
    * print response
    And match response.name == requestBody.name
    And match response.alterego == 'Peter Parker'
    And match response.description == 'Superhéroe arácnido de Marvel'
    And match response.powers == ["Agilidad", "Sentido arácnido", "Trepar muros"]


  @id:3 @CrearPersonajeCasoInvalido
  Scenario: T-API-BIL-1-CA3-Crear personaje con caso inválido
    * def path = '/api/characters'
    * header Content-Type = 'application/json'
    * def requestBody = read('classpath:../data/character-save-request.json')
    * print requestBody
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 400
    * print response
    And match response.error == 'Character name already exists'

  @id:4 @CrearPersonajeCasoInvalidoDatosFaltantes
  Scenario: T-API-BIL-1-CA4-Crear personaje con caso inválido (datos faltantes)
    * def path = '/api/characters'
    * header Content-Type = 'application/json'
    * def requestBody = read('classpath:../data/character-save-request.json')
    * print requestBody
    Given url baseUrl + path
    And request
     """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method POST
    Then status 400
    * print response
    And match response.name == 'Name is required'
    And match response.description ==  'Description is required'
    And match response.powers == 'Powers are required'
    And match response.alterego == 'Alterego is required'


  @id:5 @ObtenerPersonajePorID
  Scenario: T-API-BIL-1-CA5-Obtener el personaje por id
    * def path = '/api/characters/' + idPersonaje
    Given url baseUrl + path
    When method get
    Then status 200
    * print response

  @id:6 @ObtenerPersonajeNoExiste
  Scenario: T-API-BIL-1-CA6-Obtener el personaje por id (no existe)
    * def idPersonaje = 9999
    * def path = '/api/characters/' + idPersonaje
    Given url baseUrl + path
    When method get
    Then status 404
    * print response


  @id:7 @ActualizarPersonajeExitoso
  Scenario: T-API-BIL-1-CA7-Actualizar personaje con caso exito
    * def path = '/api/characters'
    * def idPersonaje = 1
    * header Content-Type = 'application/json'
    Given url baseUrl + path + '/' + idPersonaje
    And request
     """
      {
        "name": "Super Banco Pichincha 1",
        "alterego": "Super Banco",
        "description": "Dev full stack",
        "powers": ["Angular"]
      }
      """
    When method PUT
    Then status 200
    * print response
    And match response.id == idPersonaje
    And match response.description ==  'Dev full stack'
    And match response.powers contains 'Angular'
    And match response.alterego == 'Super Banco'

  @id:8 @ActualizarPersonajeNoExiste
  Scenario: T-API-BIL-1-CA8-Actualizar personaje (no existe)
    * def path = '/api/characters'
    * def idPersonaje = 400
    * header Content-Type = 'application/json'
    Given url baseUrl + path + '/' + idPersonaje
    And request
     """
      {
        "name": "Iron Man",
        "alterego": "xxx",
        "description": "xxx",
        "powers": ["xxx"]
      }
      """
    When method PUT
    Then status 404
    * print response
    And match response.error == 'Character not found'


  @id:9 @EliminarPersonajeExitoso
  Scenario: T-API-BIL-1-CA8-Eliminar personaje exitosamente
    * def idPersonaje = 1
    * def path = '/api/characters/' + idPersonaje
    Given url baseUrl + path
    When method DELETE
    Then status 204
    * print response
