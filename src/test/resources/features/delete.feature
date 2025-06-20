@REQ_BDR-1590 @DeleteCharacterV1
Feature: Delete character

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bapinos/api/characters'
    * url baseUrl

  @id:1 @DeleteNotExistingCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA9-Delete existing character
    Given path '/15'
    When method delete
    Then status 204

  @id:3 @DeleteNotExistingCharacter @NegativeCase
  Scenario: T-API-BDR-1590-CA10-Delete not existing character
    Given path '/999'
    When method delete
    Then status 404
    * def responseError = response.error
    * match responseError == 'Character not found'