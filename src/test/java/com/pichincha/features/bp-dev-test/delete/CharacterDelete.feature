@REQ_BP @HU-0005 @iniciativa_personajes @bp-dev-test @agente3
Feature: Eliminar personaje

  @id:1 @consultaEliminarPersonajePorId @jsonData
  Scenario: T-API-HU-0005-CA1- Eliminar personaje
    * header content-type = 'application/json'
    * def base = url
    * def bodyJSON = read('classpath:../data/bp-dev-test/delete/request_delete_character.json')
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
    When method DELETE
    Then status 204

  @id:2 @consultaEliminarPersonajePorIdNoExiste @jsonData
  Scenario: T-API-HU-0005-CA1- Eliminar personaje no existe
    * header content-type = 'application/json'
    Given url url + '/' + notFoundId
    When method DELETE
    Then status 404
