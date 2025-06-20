@BTHM-2157 @Feature2 @Evaluacion
Feature: Test del Api de personajes pero con casos de error

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser'

  @id:1 @GetErrorById
  Scenario: T-BTHM-2157-CA1 - Verificar que el servicio de obtener personajes por Id de error por no encontrar el personaje
    Given url baseUrl + '/api/characters/9999999'
    When method get
    Then status 404

  @id:2 @PostErrorNoAlterego
  Scenario: T-BTHM-2157-CA2 - Verificar que el servicio de crear un personaje falle por no enviar el campo alterego
    * def randomNumber = Math.floor(Math.random() * 10000)
    * def characterName = 'Diego Iron Man ' + randomNumber

    Given url baseUrl + '/api/characters'
    And request { "name": "#(characterName)", "powers": ["Armor", "Flight"] }
    When method post
    Then status 400

  @id:3 @DeleteErrorIdNoEncontrado
  Scenario: T-BTHM-2157-CA3 - Verificar que el servicio de eliminación de error por no encontrar el Id del personaje
    Given url baseUrl + '/api/characters/9999999'
    When method delete
    Then status 404

  @id:4 @PutErrorIdNoEncontrado
  Scenario: T-BTHM-2157-CA4 - Verificar que el servicio de actualización de error por no encontrar el Id del personaje
    Given url baseUrl + '/api/characters/9999999'
    And request { "name": "Iron Man Cambiado por DiegoF", "alterego": "Tony Stark Diego Put", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method put
    Then status 404