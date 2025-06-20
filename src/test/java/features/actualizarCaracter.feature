@REQ_HU_0003  @actualizarCaracter    @agente1
Feature: Prueba de actualización de caracter
  Background:
    * def config = call read('classpath:karate-config.js')
    * def fullUrl = config.baseUrl
    # Cargar generador
    * def characterGen = call read('classpath:utils/character-generator.js')

    # Generar personaje dinámico para CRUD usando la función cargada
    * def updatedCharacterData = characterGen.generateCharacterWithName('CRUD-Updated')
    * print 'Generated update character:', updatedCharacterData
    
  @id:1 @actualizarCaracterOk
  Scenario: T-API-HU-0003-CA01- Actualización de caracter exitoso     # Creamos un caracter previamente para validar la actualizacion y asegurar uno existente
    * def createdCharacter = call read('classpath:utils/create-character.feature')
    * def characterId = createdCharacter.characterId
    * print 'Created character:', createdCharacter.createdCharacter
    # Actualizamos el caracter previamente creado
    Given url fullUrl + '/' + characterId
    And request updatedCharacterData
    When method put
    Then status 200
    And match response.name == updatedCharacterData.name
    And match response.alterego == updatedCharacterData.alterego
    And match response.powers == updatedCharacterData.powers
    And match response.id == characterId
    * print 'Updated character:', response

  @id:2 @actualizarCaracterError
  Scenario: T-API-HU-0004-CA01- Actualización de caracter exitoso NO existente debe retornar error
    # Intentamos actualizar un caracter NO existente
    Given url fullUrl + '/' + 9999
    And request updatedCharacterData
    When method put
    Then status 404
    And match response == '#object'
    And match response == read('classpath:data/not-found-caracter.json')
    * print 'Not found character:', response