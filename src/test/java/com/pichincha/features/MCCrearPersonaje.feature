@REQ_BAN-0003
Feature: Crear Personaje

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def character = read('classpath:../MarvelCharacters/CrearPersonaje.json')


@id:1 @MarvelCharactersAPI  @CrearPersonajeExitoso
  Scenario: T-API-BAN-0003-CA1 Crear Personaje (exitoso)
    Given url baseUrl
    And request character
    When method post
    Then status 201
    And match response.alterego == "Edu Lima"
    And print response

  @id:2 @MarvelCharactersAPI  @CrearPersonajeNombreDuplicado
  Scenario: T-API-BAN-0003-CA2 Crear personaje (nombre duplicado)
    Given url baseUrl
    And request character
    When method post
    Then status 400
    And match response.error == "Character name already exists"
    And print response

  @id:3 @MarvelCharactersAPI  @CrearPersonajeFaltaCamposRequeridos
  Scenario: T-API-BAN-0003-CA3 Crear personaje (faltan campos requeridos)
    Given url baseUrl
    And def characterWithoutRequiredFields = read('classpath:../MarvelCharacters/CrearPersonajeFaltaCamposRequeridos.json')
    And request characterWithoutRequiredFields
    When method post
    Then status 400
    And match response.name == "Name is required"
    And match response.alterego == "Alterego is required"
    And match response.description == "Description is required"
    And match response.powers == "Powers are required"
    And print response
