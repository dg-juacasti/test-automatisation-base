@REQ_BP @HU-0003 @iniciativa_personajes @bp-dev-test @agente3
Feature: Consulta de personaje por ID

  @id:1 @consultaObtenerPersonajePorId @jsonData
  Scenario: T-API-HU-0003-CA1- Consultar informacion de personaje por ID
    * def base = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/josdrodr/api/characters'
    * header content-type = 'application/json'
    * def bodyJSON = read('classpath:../data/bp-dev-test/get/request_get_character_by_id.json')
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
    When method GET
    Then status 200
    And match response.id == characterId
    And match response.name == bodyJSON.name
    And match response.alterego == bodyJSON.alterego

  @id:2 @consultaObtenerPersonajePorIdNoExiste
  Scenario: T-API-HU-0003-CA2- Consultar informacion de personaje que no existe
    * header content-type = 'application/json'
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/josdrodr/api/characters/999'
    When method GET
    Then status 404
    And match response.error == 'Character not found'