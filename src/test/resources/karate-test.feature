Feature: Marvel Characters API Tests

Background:
  # Carga de archivos de configuración y datos
  * def config = read('classpath:data/config.json')[0]
  * def baseUrl = config.baseUrl
  * def username = config.username
  * url baseUrl + '/' + username + '/api/characters'
  # Desactivamos SSL porque la API usa HTTP, no HTTPS
  * configure ssl = false
    # Carga de datos de prueba desde archivos JSON
  * def schemas = read('classpath:data/schemas.json')
  * def characterSchema = schemas.characterSchema
  * def ironManData = read('classpath:data/ironman.json')
  * def spiderManData = read('classpath:data/spiderman.json')
  * def thorData = read('classpath:data/thor.json')
  * def hulkData = read('classpath:data/hulk.json')
  * def captainAmericaData = read('classpath:data/captain-america.json')
  * def invalidCharacter = read('classpath:data/invalid-character.json')
    # Definimos variables para los personajes - creamos copias profundas
  * def ironMan = read('classpath:data/ironman.json')
  * def spiderMan = read('classpath:data/spiderman.json')
  
  # Función para generar strings aleatorios y evitar duplicados
  * def randomString = function(){ return java.util.UUID.randomUUID() + '' }
  * def uniqueName = function(prefix){ return prefix + '-' + randomString() }

# 1. Obtener todos los personajes
Scenario: Obtener todos los personajes
  Given path ''
  When method GET
  Then status 200
  And match response == '#array'
  And match each response contains characterSchema

# 2. Obtener personaje por ID
Scenario: Obtener un personaje por ID
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo consultamos por ID
  Given path '/' + createdId
  When method GET
  Then status 200
  And match response contains characterSchema
  And match response.id == createdId
  And match response.name == ironMan.name

# 3. Obtener un personaje que no existe
Scenario: Obtener un personaje que no existe
  Given path '/99999'
  When method GET
  Then status 404
  And match response.error == 'Character not found'

# 4. Crear un personaje exitosamente
Scenario: Crear un personaje exitosamente
  # Preparar datos para evitar duplicados
  * def hero = read('classpath:data/ironman.json')
  * set hero.name = uniqueName('Iron Man')
  
  Given path ''
  And request hero
  When method POST
  Then status 201
  And match response contains characterSchema
  And match response.name == hero.name
  * def createdId = response.id

# 5. Validar error al crear personaje con nombre duplicado
Scenario: Validar error al crear personaje con nombre duplicado
  # Primero creamos un personaje con un nombre específico
  * def hero = { name: 'Duplicated Hero-' + randomString(), alterego: 'Original', description: 'Original description', powers: ['Power1'] }
  Given path ''
  And request hero
  When method POST
  Then status 201
  
  # Intentamos crear otro con el mismo nombre
  Given path ''
  And request hero
  When method POST
  Then status 400
  And match response.error == 'Character name already exists'

# 6. Validar error al crear personaje con datos inválidos
Scenario: Validar error al crear personaje con datos inválidos
  Given path ''
  And request invalidCharacter
  When method POST
  Then status 400
  And match response.name == 'Name is required'
  And match response.alterego == 'Alterego is required'
  And match response.description == 'Description is required'
  And match response.powers == 'Powers are required'

# 7. Actualizar un personaje exitosamente
Scenario: Actualizar un personaje exitosamente
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo actualizamos
  * def updatedIronMan = { name: ironMan.name, alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight', 'Intelligence'] }
  Given path '/' + createdId
  And request updatedIronMan
  When method PUT
  Then status 200
  And match response.description == 'Updated description'
  And match response.powers contains 'Intelligence'

# 8. Actualizar un personaje que no existe
Scenario: Actualizar un personaje que no existe
  Given path '/99999'
  And request ironMan
  When method PUT
  Then status 404
  And match response.error == 'Character not found'

# 9. Eliminar un personaje exitosamente
Scenario: Eliminar un personaje exitosamente
  # Primero creamos un personaje
  Given path ''
  And request spiderMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo eliminamos
  Given path '/' + createdId
  When method DELETE
  Then status 204
  
  # Verificamos que se haya eliminado
  Given path '/' + createdId
  When method GET
  Then status 404

# 10. Eliminar un personaje que no existe
Scenario: Eliminar un personaje que no existe
  Given path '/99999'
  When method DELETE
  Then status 404
  And match response.error == 'Character not found'

# 11. Filtrar personajes por nombre
Scenario: Filtrar personajes por nombre
  # Primero creamos un personaje con nombre único
  * def uniqueName = 'Unique-' + randomString()
  * def uniqueHero = { name: uniqueName, alterego: 'Unique Identity', description: 'Unique description', powers: ['Unique Power'] }
  Given path ''
  And request uniqueHero
  When method POST
  Then status 201
  
  # Buscamos por ese nombre
  Given path ''
  And param name = uniqueName
  When method GET
  Then status 200
  And match response[0].name == uniqueName

# 12. Filtrar personajes por poder
Scenario: Filtrar personajes por poder
  # Primero creamos un personaje con poder único
  * def uniquePower = 'UniqueAbility-' + randomString()
  * def powerfulHero = { name: 'Powerful-' + randomString(), alterego: 'Power User', description: 'Has special powers', powers: [uniquePower, 'Strength'] }
  Given path ''
  And request powerfulHero
  When method POST
  Then status 201
  
  # Buscamos por ese poder
  Given path ''
  And param power = uniquePower
  When method GET
  Then status 200
  And match response[0].powers contains uniquePower

# 13. Obtener estadísticas de personajes
Scenario: Obtener estadísticas de personajes
  Given path '/stats'
  When method GET
  Then status 200
  And match response contains { totalCharacters: '#number', powerStats: '#object' }

# 14. Actualizar poder específico
Scenario: Actualizar poder específico de un personaje
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Actualizamos solo los poderes
  * def powerUpdate = { powers: ['Armor', 'Flight', 'Genius'] }
  Given path '/' + createdId + '/powers'
  And request powerUpdate
  When method PATCH
  Then status 200
  And match response.powers contains 'Genius'
  And match response.name == ironMan.name

# 15. Verificar disponibilidad de API
Scenario: Verificar disponibilidad de API
  Given url baseUrl + '/' + username + '/api/health'
  When method GET
  Then status 200
  And match response contains { status: 'UP' }

# 16. Flujo completo CRUD
Scenario: Flujo completo CRUD de personaje
  # Crear
  * def uniqueName = 'Hero-' + randomString()
  * def testCharacter = { name: uniqueName, alterego: 'Secret Identity', description: 'Test hero', powers: ['Testing'] }
  Given path ''
  And request testCharacter
  When method POST
  Then status 201
  * def id = response.id
  
  # Leer
  Given path '/' + id
  When method GET
  Then status 200
  And match response.name == uniqueName
  
  # Actualizar
  * def updatedCharacter = { name: uniqueName, alterego: 'New Identity', description: 'Updated description', powers: ['Testing', 'Debugging'] }
  Given path '/' + id
  And request updatedCharacter
  When method PUT
  Then status 200
  And match response.description == 'Updated description'
  And match response.powers contains 'Debugging'
  
  # Eliminar
  Given path '/' + id
  When method DELETE
  Then status 204
  
  # Verificar eliminación
  Given path '/' + id
  When method GET
  Then status 404
