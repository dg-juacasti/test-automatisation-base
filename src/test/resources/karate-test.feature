@REQ_TEST-CHAPTER-2025 @bp-dev-test
Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def url_ = "http://bp-se-test-cabcd9b246a5.herokuapp.com/fiza/api/characters"
    * def bodyRequest = read('data/CharacterCreate.json')
    Given def urlBase = url_

  @id:1 @bp-dev-test-Obtener_todos_los_personajes
  Scenario: T-MIC-TEST-CHAPTER-2025-CA1-Obtener todos los personajes
    * url urlBase
    When method GET
    Then status 200
    And print response

  @id:2 @bp-dev-test-Obtener_personaje_por_ID
  Scenario: T-MIC-TEST-CHAPTER-2025-CA2-Obtener personaje por ID
    * url urlBase
    And path '/1'
    When method GET
    Then status 200
    And print response

  @id:3 @bp-dev-test-Crear_personaje_válido
  Scenario: T-MIC-TEST-CHAPTER-2025-CA3-Crear personaje (válido)
    * header content-type = 'application/json'
    * url urlBase
    * def bodyRequest = read('data/CharacterCreate.json')
    * print bodyRequest
    And request bodyRequest
    When method POST
    Then status 201
    And print response

  @id:4 @bp-dev-test-Crear_personaje_(nombre_duplicado_error_400)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA4-Crear personaje (nombre duplicado, error 400)
    * header content-type = 'application/json'
    * url urlBase
    * print bodyRequest
    And request bodyRequest
    When method POST
    Then status 400
    And match response.error == "Character name already exists"
    And print response

  @id:5 @bp-dev-test-Crear_personaje_(datos_inválidos_error_400)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA5-Crear personaje (datos inválidos, error 400)
    * header content-type = 'application/json'
    * url urlBase
    Given set bodyRequest.name = ""
    And set bodyRequest.alterego = ""
    And set bodyRequest.description = ""
    And set bodyRequest.powers = []
    And print bodyRequest
    And request bodyRequest
    When method POST
    Then status 400
    And match response.name == "Name is required"
    And match response.description == "Description is required"
    And match response.powers == "Powers are required"
    And match response.alterego == "Alterego is required"
    And print response

  @id:6 @bp-dev-test-Obtener_personaje_inexistente(error_404)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA6-Obtener personaje inexistente (error 404)
    * header content-type = 'application/json'
    * url urlBase
    And path '/14'
    When method GET
    Then status 404
    And match response.error == "Character not found"
    And print response

  @id:7 @bp-dev-test-Actualizar_personaje_(válido)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA7-Actualizar personaje (válido)
    * header content-type = 'application/json'
    * url urlBase
    And path '/1'
    Given set bodyRequest.name = "Spider-Man"
    And set bodyRequest.alterego = "Peter Parker"
    And set bodyRequest.description = "Superhéroe arácnido de Marvel (actualizado)"
    And set bodyRequest.powers = ["Agilidad", "Sentido arácnido", "Trepar muros"]
    And print bodyRequest
    And request bodyRequest
    When method PUT
    Then status 200
    And print response

  @id:8 @bp-dev-test-Actualizar_personaje_inexistente(error_404)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA8-Actualizar personaje inexistente (error 404)
    * header content-type = 'application/json'
    * url urlBase
    And path '/14'
    Given set bodyRequest.name = "No existe"
    And set bodyRequest.alterego = "Nadie"
    And set bodyRequest.description = "No existe"
    And set bodyRequest.powers = ["Nada"]
    And print bodyRequest
    And request bodyRequest
    When method PUT
    Then status 404
    And print response

  @id:9 @bp-dev-test-Eliminar_personaje_(válido)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA9-Eliminar personaje (válido)
    * header content-type = 'application/json'
    * url urlBase
    And path '/5'
    When method DELETE
    Then status 204
    And print response

  @id:10 @bp-dev-test-Eliminar_personaje_inexistente(error_404)
  Scenario: T-MIC-TEST-CHAPTER-2025-CA10-Eliminar personaje inexistente (error 404)
    * header content-type = 'application/json'
    * url urlBase
    And path '/14'
    When method DELETE
    Then status 404
    And print response