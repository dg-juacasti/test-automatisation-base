@REQ_BDR-1590 @CreateNewCharacterV1
Feature: Create new character

  Background:
    * url baseUrl
    * def requestBody = read('classpath:../data/request.json')
    * def badRequest = read('classpath:../data/badRequest.json')

  @id:1 @CreateNewCharacter @PositiveCase
  Scenario: T-API-BDR-1590-CA4-Save new character sucessfull
    And request requestBody
    When method post
    Then status 201
    * print 'Response: ' + response
    * match response contains { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }

  @id:2 @CreateDuplicateCharacter @DuplicatedCase
  Scenario: T-API-BDR-1590-CA5-Save new character error for duplicated
    And request requestBody
    When method post
    Then status 400
    * def responseError = response.error
    * match responseError == 'Character name already exists'

  @id:3 @CreateCharacterBadData @ErroDataCase
  Scenario: T-API-BDR-1590-CA6-Save new character error for data
    And request badRequest
    When method post
    Then status 400
    * match response.name == 'Name is required'
    * match response.description == 'Description is required'
    * match response.powers == 'Powers are required'
    * match response.alterego == 'Alterego is required'