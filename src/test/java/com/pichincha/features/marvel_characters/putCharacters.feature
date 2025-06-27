@REQ_MVT-0001 @HU0001 @gestion_personajes_marvel @marvel_characters @Agente2 @E2 @iniciativa_marvel
Feature: MVT-0001 Actualizar personajes (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters
    * def username = 'kmaxi'
    * configure ssl = true
    * def toEditValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[3]
    * def invalidCharacter = read('classpath:data/marvel_characters/character_invalid.json')

  @id:1 @actualizarPersonaje @exito200
  Scenario: T-API-MVT-0001-CA01-Actualizar personaje exitosamente 200 - karate
    Given path username, 'api/characters'
    And request toEditValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == toEditValidCharacter.name
    And match response.alterego == toEditValidCharacter.alterego
    And match response.description == toEditValidCharacter.description
    And match response.powers contains toEditValidCharacter.powers[0]
    * def characterId = response.id
    * def id = karate.get('characterId') ? characterId : 1
    * def updatedCharacter = JSON.parse(JSON.stringify(toEditValidCharacter))
    * updatedCharacter.description = 'Updated description'
    Given path username, 'api/characters', id
    And request updatedCharacter
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.description == 'Updated description'

  @id:2 @actualizarPersonajeInexistente @error404
  Scenario: T-API-MVT-0001-CA02-Actualizar personaje inexistente 404 - karate
    Given path username, 'api/characters', 99999
    And request toEditValidCharacter
    And header Content-Type = 'application/json'
    When method put
    Then status 404
    And match response.error contains 'not found'
