Feature: Marvel Characters API

Background:
  * configure ssl = true
  * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * def username = 'testuser'
  * def basePath = '/' + username + '/api/characters'
  * def headers = { 'Content-Type': 'application/json' }
  * def nameRandom = 'Hero-' + java.util.UUID.randomUUID()
  * def characterRequest = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
  * def characterUpdateRequest = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
  * def invalidCharacterRequest = { name: '', alterego: '', description: '', powers: [] }
  * def emptyRequest = { }
  # Función para limpiar personajes antes de las pruebas (opcional)
  * def cleanUp =
  """
  function() {
    var http = karate.http(karate.get('url'));
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

@Get
Scenario: Obtener todos los personajes
  Given path basePath
  When method GET
  Then status 200
  And match response == '#[]'

@Get
Scenario: Obtener personaje por ID (exitoso)
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

@Get
Scenario: Obtener personaje por ID (no existe)
  Given path basePath + '/999'
  When method GET
  Then status 404
  And match response.error == 'Character not found'

@Post
Scenario: Crear personaje (exitoso)
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  And match response.id == '#notnull'
  And match response.name == characterRequest.name
  And match response.alterego == characterRequest.alterego
  And match response.description == characterRequest.description
  And match response.powers == characterRequest.powers
  * def characterId = response.id

@Post
Scenario: Crear personaje (nombre duplicado)
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
  And match response.error == "Character name already exists"

@Post
Scenario: Crear personaje (faltan campos requeridos)
  Given path basePath
  And request invalidCharacterRequest
  And headers headers
  When method POST
  Then status 400
  And match response.name == "Name is required"
  And match response.alterego == "Alterego is required"
  And match response.description == "Description is required"
  And match response.powers == "Powers are required"

@Put
Scenario: Actualizar personaje (exitoso)
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

@Put
Scenario: Actualizar personaje (no existe)
  Given path basePath + '/999'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 404
  And match response.error == "Character not found"

@Delete
Scenario: Eliminar personaje (exitoso)
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
  And match response.error == 'Character not found'

@Delete
Scenario: Eliminar personaje (no existe)
  Given path basePath + '/999'
  When method DELETE
  Then status 404
  And match response.error == "Character not found"

# Escenarios adicionales con IDs mal formados según el feature proporcionado

@Get
Scenario: Verificar que el de /characters/{id} devuelve error con un id mal formado
  Given path basePath + '/aaaa'
  When method GET
  Then status 500
  And match response.error == 'Internal server error'

@Put
Scenario: Verificar que devuelve error cuando intento actualizar un personaje con un id invalido
  Given path basePath + '/aaa'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 500
  And match response.error == 'Internal server error'

@Delete
Scenario: Verificar que devuelve error cuando elimino un registro con un id invalido
  Given path basePath + '/aaaaa'
  When method DELETE
  Then status 500
  And match response.error == 'Internal server error'

# Escenario de flujo completo
Scenario: Flujo completo - Crear, Obtener, Actualizar y Eliminar un personaje
  # Crear personaje
  Given path basePath
  And request { name: "#(nameRandom)", alterego: "Peter Parker", description: "Friendly neighborhood", powers: ["Spider-sense", "Wall-crawling"]}
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id
  
  # Obtener personaje creado
  Given path basePath + '/' + characterId
  When method GET
  Then status 200
  And match response.id == characterId
  And match response.name == nameRandom
  
  # Actualizar personaje
  Given path basePath + '/' + characterId
  And request { name: "#(nameRandom)", alterego: "Peter Parker", description: "Updated description", powers: ["Spider-sense", "Wall-crawling", "Super strength"]}
  And headers headers
  When method PUT
  Then status 200
  And match response.id == characterId
  And match response.description == "Updated description"
  And match response.powers contains "Super strength"
  
  # Eliminar personaje
  Given path basePath + '/' + characterId
  When method DELETE
  Then status 204
  
  # Verificar que el personaje ya no existe
  Given path basePath + '/' + characterId
  When method GET
  Then status 404
  And match response.error == "Character not found"

@Put
Scenario: Verificar que devuelve error cuando intento actualizar un personaje con un id que no existe
  Given path basePath + '/1'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 404
  And match response.error == "Character not found"

@Put
Scenario: Verificar que devuelve error cuando intento actualizar un personaje con un id invalido
  Given path basePath + '/aaa'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 500
  And match response.error == 'Internal server error'

@Delete
Scenario: Verificar que devuelve error cuando elimino un registro que no existe
  Given path basePath + '/1'
  When method DELETE
  Then status 404
  And match response.error == "Character not found"

@Delete
Scenario: Verificar que devuelve error cuando elimino un registro con un id invalido
  Given path basePath + '/aaaaa'
  When method DELETE
  Then status 500
  And match response.error == 'Internal server error'

Scenario: Flujo completo - Crear, Obtener, Actualizar y Eliminar un personaje
  # Crear personaje
  Given path basePath
  And request { name: "#(nameRandom)", alterego: "Peter Parker", description: "Friendly neighborhood", powers: ["Spider-sense", "Wall-crawling"]}
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id
  
  # Obtener personaje creado
  Given path basePath + '/' + characterId
  When method GET
  Then status 200
  And match response.id == characterId
  And match response.name == nameRandom
  
  # Actualizar personaje
  Given path basePath + '/' + characterId
  And request { name: "#(nameRandom)", alterego: "Peter Parker", description: "Updated description", powers: ["Spider-sense", "Wall-crawling", "Super strength"]}
  And headers headers
  When method PUT
  Then status 200
  And match response.id == characterId
  And match response.description == "Updated description"
  And match response.powers contains "Super strength"
  
  # Eliminar personaje
  Given path basePath + '/' + characterId
  When method DELETE
  Then status 204
  
  # Verificar que el personaje ya no existe
  Given path basePath + '/' + characterId
  When method GET
  Then status 404
  And match response.error == "Character not found"
