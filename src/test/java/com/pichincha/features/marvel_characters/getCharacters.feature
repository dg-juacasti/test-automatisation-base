@REQ_MVT-0001 @HU0001 @gestion_personajes_marvel @marvel_characters @Agente2 @E2 @iniciativa_marvel
Feature: MVT-0001 Consultar personajes (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters
    * def username = 'kmaxi'
    * configure ssl = true
    * def secondValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[1]

  @id:1 @consultarPersonajes @exito200
  Scenario: T-API-MVT-0001-CA01-Obtener todos los personajes exitosamente 200 - karate
    Given path username, 'api/characters'
    When method get
    Then status 200
    And match response == '#[]'

  @id:2 @consultarPersonajePorId @exito200
  Scenario: T-API-MVT-0001-CA02-Obtener personaje por ID exitosamente 200 - karate
    Given path username, 'api/characters'
    And request secondValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == secondValidCharacter.name
    And match response.alterego == secondValidCharacter.alterego
    And match response.description == secondValidCharacter.description
    And match response.powers contains secondValidCharacter.powers[0]
    * def characterId = response.id
    * def id = karate.get('characterId') ? characterId : 1
    Given path username, 'api/characters', id
    When method get
    Then status 200
    And match response.id == id
    And match response.name == secondValidCharacter.name

  @id:3 @consultarPersonajePorId @error404
  Scenario: T-API-MVT-0001-CA03-Obtener personaje por ID inexistente 404 - karate
    Given path username, 'api/characters', 99999
    When method get
    Then status 404
    And match response.error contains 'not found'

