@REQ_BDR-1590 @GetCharactersV1
Feature: Get all or by id characters

  Background:
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bapinos/api/characters'
    * url baseUrl
    * def requestBody = read('classpath:../data/request.json')
    * def badRequest = read('classpath:../data/badRequest.json')

  @id:1 @PostNewCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA4-Save new character sucessfull
    Given url baseUrl
    And request requestBody
    When method post
    Then status 201
    * def response = response
    * print 'Response: ' + response

  @id:2 @PostDuplicateCharacter @DuplicatedCase
  Scenario: T-API-BDR-1590-CA5-Save new character sucessfull
    Given url baseUrl
    And request requestBody
    When method post
    Then status 400
    * def resposenseMessage = response.error
    * match resposenseMessage == 'Character name already exists'

  @id:3 @PostEmptyFieldsCharacter @EmptyFieldsdCase
  Scenario: T-API-BDR-1590-CA6-Save new character sucessfull
    Given url baseUrl
    And request badRequest
    When method post
    Then status 400
    * def name = response.name
    * def description = response.description
    * def powers = response.powers
    * def alterego = response.alterego
    * match name  == 'Name is required'
    * match description  == 'Description is required'
    * match powers  == 'Powers are required'
    * match alterego  == 'Alterego is required'