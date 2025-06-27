@REQ_MVT-0001 @HU0001 @gestion_personajes_marvel @marvel_characters @Agente2 @E2 @iniciativa_marvel
Feature: MVT-0001 Crear personajes (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters
    * def username = 'kmaxi'
    * configure ssl = true
    * def validCharacter = read('classpath:data/marvel_characters/characters_valid.json')[0]
    * def duplicateCharacter = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    * def invalidCharacter = read('classpath:data/marvel_characters/character_invalid.json')

  @id:1 @crearPersonaje @exito201
  Scenario: T-API-MVT-0001-CA01-Crear personaje exitosamente 201 - karate
    Given path username, 'api/characters'
    And request validCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == validCharacter.name
    And match response.alterego == validCharacter.alterego
    And match response.description == validCharacter.description
    And match response.powers contains validCharacter.powers[0]
    * def characterId = response.id
    * karate.log('Respuesta del endpoint:', response)

  @id:2 @crearPersonajeDuplicado @error400
  Scenario: T-API-MVT-0001-CA02-Crear personaje con nombre duplicado 400 - karate
    Given path username, 'api/characters'
    And request duplicateCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.error contains 'already exists'

  @id:3 @crearPersonajeInvalido @error400
  Scenario: T-API-MVT-0001-CA03-Crear personaje con datos inválidos 400 - karate
    Given path username, 'api/characters'
    And request invalidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.name contains 'required'
    And match response.alterego contains 'required'
    And match response.description contains 'required'
    And match response.powers contains 'required'

