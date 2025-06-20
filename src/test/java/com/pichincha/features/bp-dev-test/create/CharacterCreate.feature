@REQ_BP @HU-0002 @iniciativa_personajes @bp-dev-test @agente3
Feature: Creacion de personajes

  @id:1 @consultaCreacionDePersonaje @jsonData
  Scenario: T-API-HU-0002-CA1- Consultar creacion de personaje
    * header content-type = 'application/json'
    * def bodyJSON = read('classpath:../data/bp-dev-test/create/request_create_character.json')
    Given url url
    And request bodyJSON
    When method POST
    Then status 201
    And match response.name == bodyJSON.name
    And match response.alterego == bodyJSON.alterego
    And match response.description == bodyJSON.description
    And match response.powers[0] == bodyJSON.powers[0]
    And match response.powers[1] == bodyJSON.powers[1]

   @id:2 @consultaCreacionDePersonajesDuplicado @jsonData
   Scenario: T-API-HU-0002-CA2- Consultar creacion de personaje duplicado
     * header content-type = 'application/json'
     * def bodyJSON = read('classpath:../data/bp-dev-test/create/request_create_character_duplicated.json')
     Given url url
     And request bodyJSON
     When method POST
     Then status 201
     And match response.name == bodyJSON.name
     And match response.alterego == bodyJSON.alterego
     And match response.description == bodyJSON.description
     And match response.powers[0] == bodyJSON.powers[0]
     And match response.powers[1] == bodyJSON.powers[1]
     And request bodyJSON
     When method POST
     Then status 400
     And match response.error == 'Character name already exists'

  @id:3 @consultaCreacionDePersonajesConCamposFaltantes @jsonData
  Scenario: T-API-HU-0002-CA3- Consultar creacion de personaje con parametros faltantes
    * header content-type = 'application/json'
    * def bodyJSON = read('classpath:../data/bp-dev-test/create/request_create_character_missing_fields.json')
    Given url url
    And request bodyJSON
    When method POST
    Then status 400
    And match response.name == 'Name is required'
    And match response.description == 'Description is required'