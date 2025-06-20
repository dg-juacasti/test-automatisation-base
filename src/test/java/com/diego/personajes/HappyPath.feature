@BTHM-2157 @Feature1 @Evaluacion
Feature: Test del Api de personajes

  Background:
    * configure ssl = true
    * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser'

  @id:1 @GetSuccess
  Scenario: T-BTHM-2157-CA1 - Verificar que el servicio de obtener personajes está activo
    Given url baseUrl + '/api/characters'
    When method get
    Then status 200

  @id:2 @PostSuccess
  Scenario: T-BTHM-2157-CA2 - Verificar que el servicio cree un personaje
    * def randomNumber = Math.floor(Math.random() * 10000)
    * def characterName = 'Diego Iron Man ' + randomNumber

    Given url baseUrl + '/api/characters'
    And request { "name": "#(characterName)", "alterego": "Tony Stark Diego Post", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method post
    Then status 201
    And match response.name == characterName
    And match response.alterego == 'Tony Stark Diego Post'
    * def responseIdPost = response.id
    * print 'Personaje creado:', responseIdPost

    Given url baseUrl + '/api/characters/' + responseIdPost
    When method get
    Then status 200

  @id:3 @DeleteSuccess
  Scenario: T-BTHM-2157-CA3 - Verificar que el servicio elimine un personaje
    * def randomNumber = Math.floor(Math.random() * 10000)
    * def characterName = 'Diego Iron Man ' + randomNumber

    Given url baseUrl + '/api/characters'
    And request { "name": "#(characterName)", "alterego": "Tony Stark Diego Delete", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method post
    Then status 201
    And match response.name == characterName
    And match response.alterego == 'Tony Stark Diego Delete'
    * def responseIdDelete = response.id
    * print 'Personaje creado:', responseIdDelete

    Given url baseUrl + '/api/characters/' + responseIdDelete
    When method delete
    Then status 204

    Given url baseUrl + '/api/characters/' + responseIdDelete
    When method get
    Then status 404

  @id:4 @PutSuccess
  Scenario: T-BTHM-2157-CA4 - Verificar que el servicio cambie el nombre de un personaje
    * def randomNumber = Math.floor(Math.random() * 10000)
    * def characterName = 'Diego Iron Man ' + randomNumber

    Given url baseUrl + '/api/characters'
    And request { "name": "#(characterName)", "alterego": "Tony Stark Diego Put", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method post
    Then status 201
    And match response.name == characterName
    And match response.alterego == 'Tony Stark Diego Put'
    * def responseIdPut = response.id
    * print 'Personaje creado:', responseIdPut

    Given url baseUrl + '/api/characters/' + responseIdPut
    And request { "name": "Iron Man Cambiado por DiegoF", "alterego": "Tony Stark Diego Put", "description": "Genius billionaire", "powers": ["Armor", "Flight"] }
    When method put
    Then status 200

    Given url baseUrl + '/api/characters/' + responseIdPut
    When method get
    Then status 200
    And match response.name == 'Iron Man Cambiado por DiegoF'