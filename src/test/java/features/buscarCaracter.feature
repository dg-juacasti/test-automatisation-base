@REQ_HU_0002  @buscarCaracter    @agente1
Feature: Prueba de busqueda de caracter
  Background:
    * def config = call read('classpath:karate-config.js')
    * def fullUrl = config.baseUrl

  @id:1 @buscarTodosCaracteres
  Scenario: T-API-HU-0002-CA01- Busqueda de todos los caracteres ( Sin params )
    Given url fullUrl
    When method get
    Then status 200
    And match response == '#array'
    * print 'Retrieved characters:', response
    And match  each response contains call read ('classpath:data/listar-caracteres-schema.json')

  @id:2 @buscarCaracterPorId
  Scenario: T-API-HU-0002-CA02- Busqueda de caracter por ID de caracter existente
   # Creamos caracter para una correcta validación de un caracter existente y sus datos
    * def createdCharacter = call read('classpath:utils/create-character.feature')
    * def characterId = createdCharacter.characterId
    # Realizamos la peticion buscando el caracter
    Given url fullUrl + "/" + characterId
    When method get
    Then status 200
    And match response == '#object'
    And match response.name == createdCharacter.createdCharacter.name
    And match response.alterego == createdCharacter.createdCharacter.alterego
    And match response.powers == createdCharacter.createdCharacter.powers
    And match response.id == '#number'
    * print 'Find character:', response

  @id:3 @buscarCaracterInexistente
  Scenario: T-API-HU-0002-CA03- Busqueda de caracter por ID de caracter NO existente
    Given url fullUrl + "/" + 9999
    When method get
    Then status 404
    And match response == '#object'
    And match response == read('classpath:data/not-found-caracter.json')
    * print 'Not found character:', response