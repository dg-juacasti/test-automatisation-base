Feature: MVT-0001 - Gestión de personajes Marvel

  Background:
    * url 'http://localhost:8080'
    * def username = 'kmaxi'
    * configure ssl = true
    * def validCharacter = read('classpath:data/marvel_characters/characters_valid.json')[0]
    * def secondValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[1]
    * def toEraseValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[2]
    * def toEditValidCharacter = read('classpath:data/marvel_characters/characters_valid.json')[3]
    * def duplicateCharacter = { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    * def invalidCharacter = read('classpath:data/marvel_characters/character_invalid.json')

  # Escenarios positivos
  Scenario: Obtener todos los personajes (lista vacía o existente)
    Given path username, 'api/characters'
    When method get
    Then status 200
    And match response == '#[]'

  Scenario: Crear personaje exitosamente
    Given path username, 'api/characters'
    And request validCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == validCharacter.name
    And match response.alterego == validCharacter.alterego
    And match response.description == validCharacter.description
    And match response.powers contains validCharacter.powers[0]
    * def characterId = response.id
    * karate.log('Respuesta del endpoint:', response)

  Scenario: Obtener personaje por ID (exitoso)
    Given path username, 'api/characters'
    And request secondValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == secondValidCharacter.name
    And match response.alterego == secondValidCharacter.alterego
    And match response.description == secondValidCharacter.description
    And match response.powers contains secondValidCharacter.powers[0]
    * def characterId = response.id
    * def id = karate.get('characterId') ? characterId : 1
    Given path username, 'api/characters', id
    When method get
    Then status 200
    And match response.id == id
    And match response.name == secondValidCharacter.name

  Scenario: Actualizar personaje exitosamente
    Given path username, 'api/characters'
    And request toEditValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == toEditValidCharacter.name
    And match response.alterego == toEditValidCharacter.alterego
    And match response.description == toEditValidCharacter.description
    And match response.powers contains toEditValidCharacter.powers[0]
    * def characterId = response.id
    * def id = karate.get('characterId') ? characterId : 1
    * def updatedCharacter = JSON.parse(JSON.stringify(toEditValidCharacter))
    * updatedCharacter.description = 'Updated description'
    Given path username, 'api/characters', id
    And request updatedCharacter
    And header Content-Type = 'application/json'
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: Eliminar personaje exitosamente
    Given path username, 'api/characters'
    And request toEraseValidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response.name == toEraseValidCharacter.name
    And match response.alterego == toEraseValidCharacter.alterego
    And match response.description == toEraseValidCharacter.description
    And match response.powers contains toEraseValidCharacter.powers[0]
    * def characterId = response.id
    * karate.log('Respuesta del endpoint:', response)
    * def id = karate.get('characterId') ? characterId : 1
    Given path username, 'api/characters', id
    When method delete
    Then status 204

  # Escenarios negativos
  Scenario: Crear personaje con nombre duplicado (error 400)
    Given path username, 'api/characters'
    And request duplicateCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.error contains 'already exists'

  Scenario: Crear personaje con datos inválidos (error 400)
    Given path username, 'api/characters'
    And request invalidCharacter
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response.name contains 'required'
    And match response.alterego contains 'required'
    And match response.description contains 'required'
    And match response.powers contains 'required'

  Scenario: Obtener personaje por ID inexistente (error 404)
    Given path username, 'api/characters', 99999
    When method get
    Then status 404
    And match response.error contains 'not found'

  Scenario: Actualizar personaje inexistente (error 404)
    Given path username, 'api/characters', 99999
    And request validCharacter
    And header Content-Type = 'application/json'
    When method put
    Then status 404
    And match response.error contains 'not found'

  Scenario: Eliminar personaje inexistente (error 404)
    Given path username, 'api/characters', 99999
    When method delete
    Then status 404
    And match response.error contains 'not found'
