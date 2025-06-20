@REQ_BDR-1590 @GetCharactersV1
Feature: Get all or by id characters

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bapinos/api/characters'
    * url baseUrl

  @id:1 @GetAllCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA1-Get all characters sucessfull
    Given url baseUrl
    When method get
    Then status 200
    * def responseSize = response.length ? response.length : response.rules.length
    * print 'Size: ' + responseSize

  @id:2 @GetByIdCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA2-Get character by id sucessfull
    Given path '/1'
    When method get
    Then status 200
    * def id = response.id
    * match id == 1

  @id:3 @GetByIdCharacter @NegativeCase
  Scenario: T-API-BDR-1590-CA3-Get all character by id error
    Given path '/999'
    When method get
    Then status 404
    * def resposenseMessage = response.error
    * match resposenseMessage == 'Character not found'