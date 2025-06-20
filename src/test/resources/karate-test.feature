Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def baseUrl = karate.get('baseUrl')
    * def username = karate.get('username')
    * def apiPath = karate.get('apiPath')
    * def fullApiUrl = baseUrl + '/' + username + apiPath

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  Scenario: Obtener lista de personajes de Marvel
    Given url fullApiUrl
    When method get
    Then status 200

  Scenario: Obtener personaje por ID (exitoso)
    Given url fullApiUrl + '/104
    When method get
    Then status 200
    And match response contains { id: 104, name: 'Iron Man' }

  Scenario: Obtener personaje por ID (no existe)
    Given url fullApiUrl + '/999'
    When method get
    Then status 404
    And match response.error == 'Character not found'

  Scenario: Crear personaje (exitoso)
    Given url fullApiUrl
    And request { name: 'Hawkeye', alterego: 'Clint Barton', description: 'Expert archer', powers: ['Archery', 'Martial Arts'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == 'Hawkeye'

  Scenario: Crear personaje (nombre duplicado)
    Given url fullApiUrl
    And request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

  Scenario: Crear personaje (faltan campos requeridos)
    Given url fullApiUrl
    And request { name: '', alterego: '', description: '', powers: [] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  Scenario: Actualizar personaje (exitoso)
    Given url fullApiUrl + '/104'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Actualizar personaje (no existe)
    Given url fullApiUrl + '/999'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method put
    Then status 404
