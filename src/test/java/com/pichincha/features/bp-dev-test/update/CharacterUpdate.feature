@REQ_BP @HU-0004 @iniciativa_personajes @bp-dev-test @agente3
Feature: Actualizacion de datos de personaje

  @id:1 @consultaActualizarPersonaje @jsonData
  Scenario: T-API-HU-0004-CA1- Actualizacion de datos de personaje
    * header content-type = 'application/json'
    * def base = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/josdrodr/api/characters'
    * def bodyJSON = read('classpath:../data/bp-dev-test/update/request_update_character.json')
    * def updatedBodyJSON = read('classpath:../data/bp-dev-test/update/request_update_character_updated.json')
    Given url base
    And request bodyJSON
    When method POST
    Then status 201
    And match response.name == bodyJSON.name
    And match response.alterego == bodyJSON.alterego
    And match response.description == bodyJSON.description
    And match response.powers[0] == bodyJSON.powers[0]
    And match response.powers[1] == bodyJSON.powers[1]
    And def characterId = response.id
    Given url base + '/' + characterId
    And request updatedBodyJSON
    When method PUT
    Then status 200
    And match response.id == characterId
    And match response.name == updatedBodyJSON.name
    And match response.alterego == updatedBodyJSON.alterego

  @id:2 @consultaActualizarPersonajeNoExiste
  Scenario: T-API-HU-0004-CA2- Actualizacion de datos de personaje no existe
    * header content-type = 'application/json'
    * def updatedBodyJSON = read('classpath:../data/bp-dev-test/update/request_update_character_updated.json')
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/josdrodr/api/characters/999'
    And request updatedBodyJSON
    When method PUT
    Then status 404
    And match response.error == 'Character not found'