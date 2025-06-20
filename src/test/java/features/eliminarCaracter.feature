@REQ_HU_0004  @eliminarCaracter   @agente1
Feature: Prueba de eliminación de caracter

  Background:
    * def config = call read('classpath:karate-config.js')
    * def fullUrl = config.baseUrl
    # Cargar generador
    * def characterGen = call read('classpath:utils/character-generator.js')

  @id:1 @eliminarCaracterOk
  Scenario: T-API-HU-0004-CA01- Eliminación de caracter exitoso
    # Creamos un caracter previamente para validar la eliminación y asegurar uno existente
    * def createdCharacter = call read('classpath:utils/create-character.feature')
    * def characterId = createdCharacter.characterId
    * print 'Created character:', createdCharacter.createdCharacter
    # Eliminamos el caracter previamente creado
    Given url fullUrl + '/' + characterId
    When method delete
    Then status 204
    * print 'Updated character:', response

  @id:2 @eliminarCaracterInexistente
  Scenario: T-API-HU-0004-CA02- Eliminación de caracter NO existente debe retornar error
    # Intentamos actualizar un caracter NO existente
    Given url fullUrl + '/' + 999
    When method delete
    Then status 404
    And match response == read('classpath:data/not-found-caracter.json')
    * print 'Not found character:', response

  @id:2 @eliminarCaracterInternalError
  Scenario: T-API-HU-0004-CA02- Eliminación de caracter encima del limite de la URL debe retonar error
    # Intentamos actualizar un caracter NO existente
    Given url fullUrl + '/' + 999999999999
    When method delete
    Then status 500
    And match response == read('classpath:data/internal-error.json')
    * print 'Delete character internal error:', response