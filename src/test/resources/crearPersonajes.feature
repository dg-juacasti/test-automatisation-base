@REQ_CHARACTERS-002 @HU002 @crear_personajes @characters @Agente2 @E2 @iniciativa_characters
Feature: CHARACTERS-002 Crear personajes (microservicio para crear personajes)
  Background:
    * url "http://bp-se-test-cabcd9b246a5.herokuapp.com"
    * path '/l2mt/api/characters'
    * configure ssl = true
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @crearPersonaje @creacionExitosa201
  Scenario: T-API-CHARACTERS-002-CA01-Crear personaje exitosamente 201 - karate
    Given def jsonData = read('classpath:data/characters/request_create_character.json')
    * def randomNumber = Math.floor(Math.random() * 10000)
    * set jsonData.name = jsonData.name + '-' + randomNumber
    And request jsonData
    When method POST
    Then status 201

  @id:2 @crearPersonaje @errorValidacion400
  Scenario: T-API-CHARACTERS-002-CA02-Crear personaje con datos inválidos 400 - karate
    Given def jsonData = read('classpath:data/characters/request_create_character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
