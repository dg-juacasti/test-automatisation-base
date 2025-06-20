@REQ_HU_0001  @crearCaracter    @agente1
Feature: Prueba de creación de caracter

  Background:
    * def config = call read('classpath:karate-config.js')
    * def fullUrl = config.baseUrl
    # Cargar generador
    * def characterGen = call read('classpath:utils/character-generator.js')
    
    # Generar personaje dinámico para CRUD usando la función cargada
    * def testCharacter = characterGen.generateCharacterWithName('CRUD-Test')

    * print 'Generated test character:', testCharacter

    # Función de cleanup
    * def cleanupCharacter = 
      """
      function(characterId) {
        if (characterId) {
          try {
            karate.log('Cleaning up character ID:', characterId);
            var response = karate.call('delete', { url: fullUrl + '/' + characterId });
            karate.log('Cleanup result:', response.status);
            return response;
          } catch(e) {
            karate.log('Cleanup failed (expected in some cases):', e.message);
            return { status: 'failed', error: e.message };
          }
        }
        return { status: 'skipped' };
      }
      """

  Scenario: T-API-HU-0001-CA01- Creación de caracter exitoso
    * def characterId = null
    Given url fullUrl
    And request testCharacter
    When method post
    Then status 201
    And match response == '#object'
    And match response.name == testCharacter.name
    And match response.alterego == testCharacter.alterego
    And match response.powers == testCharacter.powers
    And match response.id == '#number'
    * def characterId = response.id
    * print 'Created character:', response

  Scenario: T-API-HU-0001-CA02- Creación de caracter sin campos , debe retonar 404 y campos requeridos
    Given url fullUrl
    And request {}
    When method post
    Then status 400
    And match response == '#object'
    And match response == read('classpath:data/caracter-error-campos-requeridos.json')
    * print 'Error character response:', response

  Scenario: T-API-HU-0001-CA03- Creación de caracter sin request , debe retornar 500 internal server error
    Given url fullUrl
    When method post
    Then status 500
    And match response == '#object'
    And match response == read('classpath:data/internal-error.json')
    * print 'Error character response:', response