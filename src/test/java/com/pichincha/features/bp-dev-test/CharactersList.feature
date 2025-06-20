@REQ_BP @HU-0001 @iniciativa_personajes @bp-dev-test @agente3
Feature: Listado de Personajes

  @id:1 @consultaListaDePersonajes
  Scenario: T-API-HU-0001-CA1- Consultar listado de todos los personajes
    Given url url
    When method GET
    Then status 200
    * print response