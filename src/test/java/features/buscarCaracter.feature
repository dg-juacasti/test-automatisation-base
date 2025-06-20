@REQ_HU_0002  @buscarCaracter    @agente1
Feature: Prueba de busqueda de caracter
  Background:
    * def config = call read('classpath:karate-config.js')
    * def fullUrl = config.baseUrl
    # Cargar generador
    * def characterGen = call read('classpath:utils/character-generator.js')

    # Generar personaje dinámico para CRUD usando la función cargada
    * def testCharacter = characterGen.generateCharacterWithName('CRUD-Test')

    * print 'Generated test character:', testCharacter

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
    * def characterId = null
    Given url fullUrl
    And request testCharacter
    When method post
    Then status 201
    * def characterId = response.id
    # Realizamos la peticion buscando el caracter
    Given url fullUrl + "/" + characterId
    When method get
    Then status 200
    And match response == '#object'
    And match response.name == testCharacter.name
    And match response.alterego == testCharacter.alterego
    And match response.powers == testCharacter.powers
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