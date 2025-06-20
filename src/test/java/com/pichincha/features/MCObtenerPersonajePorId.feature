@REQ_UH-0002
Feature: Obtener personaje por ID

  Background:
    * configure ssl = true
    * header Content-Type = 'application/json'
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
    * def characterCreate = read('classpath:../MarvelCharacters/CrearPersonaje.json')


@id:1 @MarvelCharactersAPI  @ObtenerPersonajePorIdExitoso
  Scenario: T-API-UH-0002-CA1 Obtener personaje por ID (exitoso)
    #Crear personaje para obtener por id
    Given url baseUrl
    And request characterCreate
    When method post
    Then status 201
    And def createdCharacterId = response.id

  #obtener personaje por id
    Given url baseUrl
    And path createdCharacterId
    When method get
    Then status 200
    And match response.id == createdCharacterId
    And print response

@id:2 @MarvelCharactersAPI  @ObtenerPersonajePorIdNoexiste
  Scenario: T-API-UH-0002-CA2 Obtener personaje por ID (no existe)
    Given url baseUrl
    And path '999'
    When method get
    Then status 404
    And match response.error == "Character not found"
    And print response
