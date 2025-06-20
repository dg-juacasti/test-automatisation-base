@REQ_UH-0004
Feature: Actualizar personaje

  Background:
    * configure ssl = true
    * header Content-Type = 'application/json'
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def character = read('classpath:../MarvelCharacters/ActualizarPersonaje.json')
    * def characterCreate = read('classpath:../MarvelCharacters/CrearPersonaje.json')


@id:1 @MarvelCharactersAPI  @ActualizarPersonajeExitoso
  Scenario: T-API-UH-0004-CA1 Actualizar personaje (exitoso)
    # Crear personaje para actualizar
    Given url baseUrl
    And request characterCreate
    When method post
    Then status 201
    And match response.alterego == "Edu Lima"
    And def createdCharacterId = response.id
    # Actualizar el personaje creado
    Given url baseUrl
    And path createdCharacterId
    And request character
    When method put
    Then status 200
    And match response.id == createdCharacterId
    And match response.alterego == "Tony Stark"
    And print response
  # Eliminar personaje creado para mantener el estado limpio
    Given url baseUrl
    And path createdCharacterId
    When method delete
    Then status 204

@id:2 @MarvelCharactersAPI  @ActualizarPersonajeNoExiste
  Scenario: T-API-UH-0004-CA2 Actualizar personaje (no existe)
    Given url baseUrl
    And path '999'
    And request character
    When method put
    Then status 404
    And match response.error == "Character not found"
    And print response
