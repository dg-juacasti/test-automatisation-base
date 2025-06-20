@REQ_HUJD-123 @HUJD-123 @marvel_characters_crud @marvel_characters_api
Feature: HUJD-123 Gestionar personajes en Marvel Characters API (microservicio para gestión de personajes)

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/juadgarz/api/characters'
    * def headers = read('classpath:data/marvel_characters_api/headers.json')
    * headers headers

  @id:1 @crear_personaje @exitoso201
  Scenario: T-API-HUJD-123-CA01-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/personaje_valido.json')
    And request jsonData
    When method POST
    Then status 201
  # And match response.id != null
  # And match response.name == 'Iron Man'
  # Deberia almacenarse el id resultante en una variable para reusar en otros escenarios
  # Tener todos en un archivo y la validación de nombre de la API no lo permite

  @id:2 @crear_personaje @nombre_duplicado400
  Scenario: T-API-HUJD-123-CA02-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/personaje_duplicado.json')
    And request jsonData
    When method POST
    Then status 400
  # And match response.error == 'Character name already exists'
  # And match response != null

  @id:3 @crear_personaje @faltan_campos400
  Scenario: T-API-HUJD-123-CA03-Crear personaje con campos requeridos vacíos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/personaje_invalido.json')
    And request jsonData
    When method POST
    Then status 400
  # And match response.name == 'Name is required'
  # And match response.powers == 'Powers are required'

  @id:4 @obtener_todos @exitoso200
  Scenario: T-API-HUJD-123-CA01-Obtener todos los personajes 200 - karate
    When method GET
    Then status 200
  # And match response == []

  @id:5 @obtener_por_id @exitoso200
  Scenario: T-API-HUJD-123-CA02-Obtener personaje por ID exitoso 200 - karate
    * path 9
    When method GET
    Then status 200
  # And match response.id == 1
  # And match response.name == 'Iron Man'

  @id:6 @obtener_por_id @no_existe404
  Scenario: T-API-HUJD-123-CA03-Obtener personaje por ID no existente 404 - karate
    * path 999
    When method GET
    Then status 404
  # And match response.error == 'Character not found'
  # And match response != null

  @id:7 @actualizar_personaje @exitoso200
  Scenario: T-API-HUJD-123-CA01-Actualizar personaje exitosamente 200 - karate
    * path 9
    * def jsonData = read('classpath:data/marvel_characters_api/personaje_valido.json')
    And request jsonData
    When method PUT
    Then status 200
  # And match response.description == 'Updated description'
  # And match response.id == 1

  @id:8 @actualizar_personaje @no_existe404
  Scenario: T-API-HUJD-123-CA02-Actualizar personaje no existente 404 - karate
    * path 999
    * def jsonData = read('classpath:data/marvel_characters_api/personaje_valido.json')
    And request jsonData
    When method PUT
    Then status 404
  # And match response.error == 'Character not found'
  # And match response != null

  @id:9 @eliminar_personaje @exitoso204
  Scenario: T-API-HUJD-123-CA01-Eliminar personaje exitosamente 204 - karate
    * path 9
    When method DELETE
    Then status 204
  # And match response == null

  @id:10 @eliminar_personaje @no_existe404
  Scenario: T-API-HUJD-123-CA02-Eliminar personaje no existente 404 - karate
    * path 999
    When method DELETE
    Then status 404
  # And match response.error == 'Character not found'
  # And match response != null