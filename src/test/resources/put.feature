@REQ_BDR-1590 @UpdateCharacterByIdV1
Feature: Update character by id

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bapinos/api/characters'
    * url baseUrl
    * def updateRequest = read('classpath:../data/updateRequest.json')

  @id:1 @UpdateExistingCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA7-Update existing character sucessfull
    Given path "/1"
    And request updateRequest
    When method put
    Then status 200
    * def responseName = response.name
    * match responseName == 'New Name'

  @id:1 @UpdateNotExistingCharacter @NegativeCase
  Scenario: T-API-BDR-1590-CA8-Update not existing character error
    Given path "/404"
    And request updateRequest
    When method put
    Then status 404
    * def resposenseMessage = response.error
    * match resposenseMessage == 'Character not found'