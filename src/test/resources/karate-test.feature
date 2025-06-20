Feature: Pruebas automatizadas Marvel Characters API

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/'
    * configure ssl = true
    * def personajeNuevo = { name: 'FranklinBernal1', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    * def personajeActualizado = {name: "Iron Man123456789ae",alterego: "Tony Stark", description: "Updated description","powers": ["Armor", "Flight"]}
    * def personajeNuevoParaEliminar = { name: 'BernalMontenegro1', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    * def personajeNuevoParaDuplicar = { name: 'Montenegro3', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
  @create
  Scenario: Crear un personaje exitosamente
    Given path '/testuser/api/characters'
    And header Content-Type = 'application/json'
    And request personajeNuevo
    When method post
    Then status 201
    And match response.name == personajeNuevo.name
    And match response.alterego == personajeNuevo.alterego
    And match response.powers == personajeNuevo.powers
    * def idCreado = response.id

  @getById
  Scenario: Obtener personaje por ID (exitoso)
    Given path '/testuser/api/characters/1875'
    And header Content-Type = 'application/json'
    When method get
    Then status 200
    And match response.id == 1875

  @update
  Scenario: Actualizar personaje por ID (exitoso)
    # Creamos un personaje primero
    Given path '/testuser/api/characters/1875'
    And header Content-Type = 'application/json'
    And request personajeActualizado
    When method put
    Then status 200

  @delete
  Scenario: Eliminar personaje por ID (exitoso)
    # Creamos un personaje primero
    Given path '/testuser/api/characters/'
    And header Content-Type = 'application/json'
    And request personajeNuevoParaEliminar
    When method post
    Then status 201
    * def id = response.id
    Given path '/testuser/api/characters/',id
    When method delete
    Then status 204


  @getByIdNotFound
  Scenario: Obtener personaje por ID inexistente (error)
    Given path '/testuser/api/characters/999999'
    And header Content-Type = 'application/json'
    When method get
    Then status 404

  @duplicate
  Scenario: Crear personaje con nombre duplicado (error)
    # Creamos un personaje primero
    Given path '/testuser/api/characters/'
    And header Content-Type = 'application/json'
    And request personajeNuevoParaDuplicar
    When method post
    Then status 201
    # Intentamos crear el mismo personaje otra vez
    Given path '/testuser/api/characters/'
    And header Content-Type = 'application/json'
    And request personajeNuevo
    When method post
    Then status 400


