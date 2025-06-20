@REQ_BDR-1590 @GetCharactersV1
Feature: Get all or by id characters

  Background:
    * url baseUrl

  @id:1 @GetAllCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA1-Get all characters sucessfull
    When method get
    Then status 200
    * def responseSize = response.length
    * print 'Size: ' + responseSize
    * assert responseSize > 0

  @id:2 @GetByIdCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA2-Create new character and get by their id sucessfull
    Given path '/12'
    When method get
    Then status 200
    * match response.id == 12

  @id:3 @GetByIdCharacter @NegativeCase
  Scenario: T-API-BDR-1590-CA3-Get character by id not found
    Given path '/999'
    When method get
    Then status 404
    * def responseError = response.error
    * match responseError == 'Character not found'