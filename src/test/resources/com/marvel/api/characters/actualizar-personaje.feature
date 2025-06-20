@update
Feature: Marvel Characters API - Actualizar Personaje

  Background:
    # Llama a la limpieza total una sola vez.
    * callonce read('classpath:com/marvel/api/characters/_util/_setup.feature')

    # Define la URL base completa para este feature, evitando problemas de path.
    * url baseUrl + '/' + user + '/api/characters'

  Scenario: Actualizar un personaje existente (Captain America)
    * def uniqueName = 'CaptainAmerica-' + java.util.UUID.randomUUID()
    * def captainAmerica = { name: uniqueName, alterego: 'Steve Rogers', description: 'The First Avenger', powers: ['Vibranium shield'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: captainAmerica }
    * def capId = result.response.id

    * def updatedCaptain = { name: uniqueName, alterego: 'Steve Rogers', description: 'A man out of time', powers: ['Vibranium shield', 'Super-soldier serum'] }
    Given path capId
    And request updatedCaptain
    When method put
    Then status 200
    And match response.description == 'A man out of time'

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: capId })

  Scenario: Intentar actualizar un personaje que no existe
    * def nonExistentBody = { name: 'Ghost', alterego: 'Unknown', description: 'Does not exist', powers: ['Invisibility'] }
    Given path '99999'
    And request nonExistentBody
    When method put
    Then status 404
    And match response.error == 'Character not found'