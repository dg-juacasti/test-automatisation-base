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
    # Guardar los datos del personaje creado usando la función del karate-config
    * saveCharacterData(response)
    * print 'Character saved globally with ID:', response.id


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
    # Obtener los datos del personaje guardado previamente
    * def savedCharacter = getCharacterData()
    * print 'Retrieved saved character:', savedCharacter
    * def idPersonaje = savedCharacter.id
    * def path = '/api/characters/' + idPersonaje
    Given url baseUrl + path
    When method get
    Then status 200
    * print response
    # Verificar que los datos coinciden con los guardados
    And match response.id == savedCharacter.id
    And match response.name == savedCharacter.name

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
    # Obtener los datos del personaje guardado previamente
    * def savedCharacter = getCharacterData()
    * print 'Updating character with ID:', savedCharacter.id
    * def idPersonaje = savedCharacter.id
    * def path = '/api/characters'
    * header Content-Type = 'application/json'
    Given url baseUrl + path + '/' + idPersonaje
    And request
     """
      {
        "name": "Super Banco Pichincha Updated",
        "alterego": "Super Banco",
        "description": "Dev full stack updated",
        "powers": ["Angular", "Karate Testing"]
      }
      """
    When method PUT
    Then status 200
    * print response
    And match response.id == idPersonaje
    And match response.description ==  'Dev full stack updated'
    And match response.powers contains 'Angular'
    And match response.powers contains 'Karate Testing'
    And match response.alterego == 'Super Banco'
    # Actualizar los datos guardados con la nueva información
    * saveCharacterData(response)

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
  Scenario: T-API-BIL-1-CA9-Eliminar personaje exitosamente
    # Obtener los datos del personaje guardado previamente
    * def savedCharacter = getCharacterData()
    * print 'Deleting character with ID:', savedCharacter.id
    * def idPersonaje = savedCharacter.id
    * def path = '/api/characters/' + idPersonaje
    Given url baseUrl + path
    When method DELETE
    Then status 204
    * print response
    # Limpiar los datos guardados después de eliminar
    * clearCharacterData()
    * print 'Character data cleared after deletion'



  @id:10 @EliminarPersonajeNoExie
  Scenario: T-API-BIL-1-CA10-Eliminar personaje no existente
    # Obtener los datos del personaje guardado previamente
    * def path = '/api/characters/' + '999999'
    Given url baseUrl + path
    When method DELETE
    Then status 404
    * print response
