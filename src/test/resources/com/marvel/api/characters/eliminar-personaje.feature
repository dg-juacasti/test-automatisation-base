@delete
Feature: Marvel Characters API - Eliminar Personaje

  Background:
    # Llama a la limpieza total, pero solo la primera vez que se encuentra en toda la ejecución.
    * callonce read('classpath:com/marvel/api/characters/_util/_setup.feature')

    # Configuración normal de la URL para este feature
    * url baseUrl
    * path user, 'api', 'characters'

  Scenario: Eliminar un personaje existente (Thor)
    * def uniqueName = 'Thor-' + java.util.UUID.randomUUID()
    * def thor = { name: uniqueName, alterego: 'Thor Odinson', description: 'God of Thunder', powers: ['Mjolnir'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: thor }
    * def thorId = result.response.id

    Given path thorId
    When method delete
    Then status 204

    Given path thorId
    When method get
    Then status 404

  Scenario: Intentar eliminar un personaje que no existe
    Given path '99999'
    When method delete
    Then status 404
    And match response.error == 'Character not found'