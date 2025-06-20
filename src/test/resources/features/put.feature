@REQ_BDR-1590 @UpdateCharacterByIdV1
Feature: Update character by id

  Background:
    * url baseUrl
    * def updateRequest = read('classpath:../data/updateRequest.json')

  @id:1 @UpdateExistingCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA7-Update existing character successful
    Given path '/8'
    And request updateRequest
    When method put
    Then status 200
    * match response contains { id: '#number', name: 'New Name', alterego: 'New alterego', description: 'Updated description', powers: '#[]' }

  @id:2 @UpdateNotExistingCharacter @NegativeCase
  Scenario: T-API-BDR-1590-CA8-Update not existing character error
    Given path "/404"
    And request updateRequest
    When method put
    Then status 404
    * def resposenseMessage = response.error
    * match resposenseMessage == 'Character not found'