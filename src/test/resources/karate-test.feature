Feature: Tests de la API Marvel Characters

Background:
  * def config = read('classpath:data/config.json')
  * url config.baseUrl
  * configure ssl = config.ssl
  * def username = config.username
  * def basePath = '/' + username + '/api/characters'
  * def ironmanRequest = read('classpath:data/ironman.json')
  * def characterRequest = ironmanRequest
  * def characterUpdateRequest = read('classpath:data/ironman.json')
  * def characterAltRequest = read('classpath:data/spiderman.json')
  * def hulkRequest = read('classpath:data/hulk.json')
  * def thorRequest = read('classpath:data/thor.json')
  * def captainRequest = read('classpath:data/captain-america.json')
  * def invalidCharacterRequest = read('classpath:data/invalid-character.json')
  * def schemas = read('classpath:data/schemas.json')
  * def expectedSchema = schemas.characterSchema
  * def errorSchema = schemas.errorSchema
  * def errorMessages = read('classpath:data/error-handling.json')
  * def headers = config.headers
  # Función para limpiar personajes antes de las pruebas (opcional)
  * def cleanUp =
  """
  function() {
    var http = karate.http(karate.get('baseUrl'));
    var path = basePath;
    var response = http.path(path).method('GET').invoke();
    var characters = response.json;
    for (var i = 0; i < characters.length; i++) {
      var id = characters[i].id;
      http.path(path + '/' + id).method('DELETE').invoke();
    }
  }
  """
  # Descomentar la siguiente línea para limpiar antes de cada prueba
  # * eval cleanUp()

# 1. Obtener todos los personajes (al inicio sin datos)
Scenario: Obtener todos los personajes - lista vacía inicial
  Given path basePath
  When method GET
  Then status 200
  And match response == []

# 2. Crear personaje (exitoso)
Scenario: Crear personaje exitosamente
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST  Then status 201
  And match response == expectedSchema
  And match response.id == '#notnull'
  And match response.name == characterRequest.name
  And match response.alterego == characterRequest.alterego
  And match response.description == characterRequest.description
  And match response.powers == characterRequest.powers
  * def characterId = response.id

# 3. Obtener personaje por ID (exitoso)
Scenario: Obtener personaje por ID existente
  # Primero creamos un personaje para asegurarnos que existe
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora obtenemos el personaje por su ID
  Given path basePath + '/' + characterId
  When method GET
  Then status 200
  And match response.id == characterId
  And match response.name == characterRequest.name
  And match response.alterego == characterRequest.alterego
  And match response.description == characterRequest.description
  And match response.powers == characterRequest.powers

# 4. Obtener personaje por ID (no existe)
Scenario: Obtener personaje por ID que no existe  Given path basePath + '/999'
  When method GET
  Then status 404
  And match response == errorSchema
  And match response.error == errorMessages.notFound.error

# 5. Crear personaje con nombre duplicado
Scenario: Crear personaje con nombre duplicado debe fallar
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  # Intentamos crear otro con el mismo nombre
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 400
  And match response == errorSchema
  And match response.error == errorMessages.duplicateName.error

# 6. Crear personaje con campos requeridos faltantes
Scenario: Crear personaje con campos requeridos faltantes debe fallar  Given path basePath
  And request invalidCharacterRequest
  And headers headers
  When method POST
  Then status 400
  And match response == schemas.validationErrorSchema
  And match response.name == errorMessages.validation.name
  And match response.alterego == errorMessages.validation.alterego
  And match response.description == errorMessages.validation.description
  And match response.powers == errorMessages.validation.powers

# 7. Obtener todos los personajes (con datos)
Scenario: Obtener todos los personajes después de crear uno
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201

  # Ahora verificamos que la lista no esté vacía
  Given path basePath
  When method GET
  Then status 200
  And match response != []
  And match response[*].name contains 'Iron Man'

# 8. Actualizar personaje (exitoso)
Scenario: Actualizar personaje existente
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora actualizamos el personaje
  Given path basePath + '/' + characterId
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 200
  And match response.id == characterId
  And match response.name == characterUpdateRequest.name
  And match response.description == characterUpdateRequest.description
  And match response.powers == characterUpdateRequest.powers

# 9. Actualizar personaje que no existe
Scenario: Actualizar personaje que no existe debe fallar  Given path basePath + '/999'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 404
  And match response == errorSchema
  And match response.error == errorMessages.notFound.error

# 10. Eliminar personaje (exitoso)
Scenario: Eliminar personaje existente
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora eliminamos el personaje
  Given path basePath + '/' + characterId
  When method DELETE
  Then status 204
  # Verificamos que ya no exista
  Given path basePath + '/' + characterId
  When method GET
  Then status 404
  And match response == errorSchema
  And match response.error == errorMessages.notFound.error

# 11. Eliminar personaje que no existe
Scenario: Eliminar personaje que no existe debe fallar  Given path basePath + '/999'
  When method DELETE
  Then status 404
  And match response == errorSchema
  And match response.error == errorMessages.notFound.error

# 12. Crear multiples personajes y verificarlos
Scenario: Crear múltiples personajes y verificarlos
  # Crear Spiderman
  Given path basePath
  And request characterAltRequest
  And headers headers
  When method POST
  Then status 201
  And match response == expectedSchema
  And match response.id == '#notnull'
  And match response.name == characterAltRequest.name
  * def spidermanId = response.id
  
  # Crear Hulk
  Given path basePath
  And request hulkRequest
  And headers headers
  When method POST
  Then status 201
  And match response == expectedSchema
  And match response.id == '#notnull'
  And match response.name == hulkRequest.name
  * def hulkId = response.id
  
  # Crear Thor
  Given path basePath
  And request thorRequest
  And headers headers
  When method POST
  Then status 201
  And match response == expectedSchema
  And match response.id == '#notnull'
  And match response.name == thorRequest.name
  * def thorId = response.id
  
  # Crear Captain America
  Given path basePath
  And request captainRequest
  And headers headers
  When method POST
  Then status 201
  And match response == expectedSchema
  And match response.id == '#notnull'
  And match response.name == captainRequest.name
  * def captainId = response.id
  
  # Verificar lista de todos los personajes
  Given path basePath
  When method GET
  Then status 200
  And match response != []
  And match response[*].name contains 'Iron Man'
  And match response[*].name contains 'Spider-Man'
  And match response[*].name contains 'Hulk'
  And match response[*].name contains 'Thor'
  And match response[*].name contains 'Captain America'
