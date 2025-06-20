@ignore
Feature: Utilidad para crear un personaje y devolver su respuesta

  Background:
    * url baseUrl
    * path '/', user, 'api/characters'

  Scenario: Crear un personaje
    # El cuerpo de la petición se recibe como argumento (requestBody)
    Given request requestBody
    When method post
    Then status 201