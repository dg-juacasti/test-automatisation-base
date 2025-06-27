@REQ_MVT-0001 @HU0001 @gestion_personajes_marvel @marvel_characters @Agente2 @E2 @iniciativa_marvel
Feature: MVT-0001 Eliminar personajes (microservicio para gestión de personajes Marvel)
  Background:
    * url port_marvel_characters
    * def username = 'kmaxi'
    * configure ssl = true
    * def validCharacter = read('classpath:data/marvel_characters/characters_valid.json')[0]
    * def secondValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[1]
    * def toEraseValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[2]
    * def toEditValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[3]
    * def duplicateCharacter = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    * def invalidCharacter = read('classpath:data/marvel_characters/character_invalid.json')

  @id:1 @eliminarPersonaje @exito204
  Scenario: T-API-MVT-0001-CA01-Eliminar personaje exitosamente 204 - karate
    Given path username, 'api/characters'
    And request toEraseValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == toEraseValidCharacter.name
    And match response.alterego == toEraseValidCharacter.alterego
    And match response.description == toEraseValidCharacter.description
    And match response.powers contains toEraseValidCharacter.powers[0]
    * def characterId = response.id
    * karate.log('Respuesta del endpoint:', response)
    * def id = karate.get('characterId') ? characterId : 1
    Given path username, 'api/characters', id
    When method delete
    Then status 204

  @id:2 @eliminarPersonajeInexistente @error404
  Scenario: T-API-MVT-0001-CA02-Eliminar personaje inexistente 404 - karate
    Given path username, 'api/characters', 99999
    When method delete
    Then status 404
    And match response.error contains 'not found'
