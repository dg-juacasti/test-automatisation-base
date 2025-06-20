@REQ_CHARACTERS-001 @HU001 @characters_api @characters @Agente2 @E2 @iniciativa_characters
Feature: CHARACTERS-001 API de personajes completa (microservicio para obtener personajes)
  Background:
    * url "http://bp-se-test-cabcd9b246a5.herokuapp.com"
    * path '/l2mt/api/characters'
    * configure ssl = true
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @consultarPersonajes @listadoExitoso200
  Scenario: T-API-CHARACTERS-001-CA01-Consultar personajes exitosamente 200 - karate
    When method GET
    Then status 200
    And match response == "#[]"
    # And match response != null

 