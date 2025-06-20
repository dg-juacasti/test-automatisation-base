@get
Feature: Marvel Characters API - Obtener Personajes

  Background:
    # Llama a la limpieza total, pero solo la primera vez que se encuentra en toda la ejecución.
    * callonce read('classpath:com/marvel/api/characters/_util/_setup.feature')

    # Configuración normal de la URL para este feature
    * url baseUrl
    * path user, 'api', 'characters'

  Scenario: Obtener todos los personajes
    Given path ''
    When method get
    Then status 200
    And match response == '#array'

  Scenario: Obtener personaje por ID existente
    # Generamos un nombre único para la prueba
    * def uniqueName = 'Wolverine-' + java.util.UUID.randomUUID()
    * def wolverine = { name: uniqueName, alterego: 'Logan', description: 'Has claws', powers: ['Healing factor'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: wolverine }
    * def wolverineId = result.response.id

    Given path wolverineId
    When method get
    Then status 200
    And match response.id == wolverineId
    And match response.name == uniqueName

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: wolverineId })

  Scenario: Obtener personaje por ID inexistente
    Given path '99999'
    When method get
    Then status 404
    And match response.error == 'Character not found'