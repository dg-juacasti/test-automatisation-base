@create
Feature: Marvel Characters API - Crear Personaje

  Background:
    # Llama a la limpieza total una sola vez.
    * callonce read('classpath:com/marvel/api/characters/_util/_setup.feature')

    # Define la URL base completa para este feature, evitando problemas de path.
    * url baseUrl + '/' + user + '/api/characters'

  Scenario: Crear un personaje exitosamente (Iron Man)
    * def uniqueName = 'IronMan-' + java.util.UUID.randomUUID()
    * def ironMan = { name: uniqueName, alterego: 'Tony Stark', description: 'Genius...', powers: ['Powered armor'] }

    Given path ''
    And request ironMan
    When method post
    Then status 201
    And match response.id == '#number'
    And match response.name == uniqueName

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: response.id })

  Scenario: Intentar crear un personaje con nombre duplicado (Hulk)
    * def uniqueName = 'Hulk-' + java.util.UUID.randomUUID()
    * def hulk = { name: uniqueName, alterego: 'Bruce Banner', description: 'Big green guy', powers: ['Super strength'] }
    # Creación del personaje original
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') ({ requestBody: hulk })
    * def hulkId = result.response.id

    # Intento de duplicado
    Given path ''
    And request hulk
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: hulkId })

  Scenario: Intentar crear un personaje con datos inválidos
    * def invalidBody = { name: '', alterego: '', description: '', powers: [] }
    Given path ''
    And request invalidBody
    When method post
    Then status 400
    And match response.name == 'Name is required'