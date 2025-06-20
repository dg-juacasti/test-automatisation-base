@REQ_BIL_1 @marvel
Feature: Test de API de marvel characters

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  @id:1 @ObtenerTodosPersonajes
  Scenario: T-API-BIL-1-CA1-Obtener todos lo personajes
    * def path = '/arevelo/api/characters'
    Given url baseUrl + path
    When method get
    Then status 200
    * print response

  @id:2 @CrearPersonaje
  Scenario: T-API-BIL-1-CA2-Crear personaje
    * def path = '/arevelo/api/characters'
    * header Content-Type = 'application/json'
    * def requestBody = read('classpath:../data/character-save-request.json')
    * print requestBody
    Given url baseUrl + path
    And request requestBody
    When method POST
    Then status 201
    * print response
    And match response.name == 'Spider-Man-1'
    And match response.alterego == 'Peter Parker'
    And match response.description == 'Superhéroe arácnido de Marvel'
    And match response.powers == ["Agilidad", "Sentido arácnido", "Trepar muros"]

