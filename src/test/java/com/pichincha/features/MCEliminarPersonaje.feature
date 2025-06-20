@REQ_UH-0005
Feature: Eliminar personaje

  Background:
    * configure ssl = true
    * header Content-Type = 'application/json'
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def character = read('classpath:../MarvelCharacters/CrearPersonaje.json')


@id:1 @MarvelCharactersAPI  @EliminarPersonajeExitoso
  Scenario: T-API-UH-0005-CA1 Eliminar personaje (exitoso)
    # Crear pesonaje para eliminar
    Given url baseUrl
    And request character
    When method post
    Then status 201
    And def createdCharacterId = response.id
    #Delete el personaje creado
    Given url baseUrl
    And path createdCharacterId
    When method delete
    Then status 204
    And print response

@id:2 @MarvelCharactersAPI  @EliminarPersonajeNoExiste
  Scenario: T-API-UH-0005-CA1 Eliminar personaje (no existe)
    Given url baseUrl
    And path '999'
    When method delete
    Then status 404
    And match response.error == "Character not found"
    And print response