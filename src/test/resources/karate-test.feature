Feature: Marvel Characters API Tests

Background:
  # Configuración básica
  * configure ssl = true
  * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
  * configure readTimeout = 60000
  * configure connectTimeout = 60000
  * configure headers = { 'Content-Type': 'application/json' }
  
  # Esquema para validación de respuestas
  * def characterSchema = { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#array' }
  
  # Datos de personajes predefinidos para los tests
  * def daycastiCharacter = { name: "daycasti-Iron Man", alterego: "daycasti", description: "Genius billionaire", powers: ["Armor", "Flight"] }
  * def invalidCharacter = { name: "", alterego: "", description: "", powers: [] }
  * def uniqueHeroName = 'daycasti-Hero-' + java.util.UUID.randomUUID()

# 1. Obtener todos los personajes
Scenario: Obtener todos los personajes
  Given path '/characters'
  When method get
  Then status 200
  And match response == '#array'
  And match each response contains { id: '#number', name: '#string' }

# 2. Obtener personaje por ID (exitoso)
Scenario: Obtener personaje por ID (exitoso)
  # Primero creamos un personaje
  Given path '/characters'
  And request { name: "#(uniqueHeroName)", alterego: "daycasti", description: "Test hero", powers: ["Super Strength", "Intelligence"] }
  When method post
  Then status 201
  * def createdId = response.id
  
  # Luego lo consultamos por ID
  Given path '/characters/' + createdId
  When method get
  Then status 200
  And match response contains characterSchema
  And match response.id == createdId
  And match response.name == uniqueHeroName
  
  # Limpieza: Eliminamos el personaje creado
  Given path '/characters/' + createdId
  When method delete
  Then status 204

# 3. Obtener personaje por ID (no existe)
Scenario: Obtener personaje por ID (no existe)
  Given path '/characters/999'
  When method get
  Then status 404
  And match response.error == 'Character not found'

# 4. Crear personaje (exitoso)
Scenario: Crear personaje (exitoso)
  * def uniqueName = 'daycasti-Character-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Created character", powers: ["Strength", "Speed"] }
  When method post
  Then status 201
  And match response contains characterSchema
  And match response.name == uniqueName
  And match response.alterego == "daycasti"
  
  # Limpieza: Eliminamos el personaje creado
  * def createdId = response.id
  Given path '/characters/' + createdId
  When method delete
  Then status 204

# 5. Crear personaje (nombre duplicado)
Scenario: Crear personaje (nombre duplicado)
  # Primero creamos un personaje
  * def uniqueName = 'daycasti-Duplicate-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Original character", powers: ["Power1"] }
  When method post
  Then status 201
  * def createdId = response.id
  
  # Intentamos crear otro con el mismo nombre
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Duplicate character", powers: ["Power2"] }
  When method post
  Then status 400
  And match response.error == 'Character name already exists'
  
  # Limpieza: Eliminamos el personaje creado
  Given path '/characters/' + createdId
  When method delete
  Then status 204

# 6. Crear personaje (faltan campos requeridos)
Scenario: Crear personaje (faltan campos requeridos)
  Given path '/characters'
  And request invalidCharacter
  When method post
  Then status 400
  And match response.name == "Name is required"
  And match response.alterego == "Alterego is required"
  And match response.description == "Description is required"
  And match response.powers == "Powers are required"

# 7. Actualizar personaje (exitoso)
Scenario: Actualizar personaje (exitoso)
  # Primero creamos un personaje
  * def uniqueName = 'daycasti-ToUpdate-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Original description", powers: ["Original Power"] }
  When method post
  Then status 201
  * def createdId = response.id
  
  # Luego lo actualizamos
  Given path '/characters/' + createdId
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Updated description", powers: ["Armor", "Flight", "Intelligence"] }
  When method put
  Then status 200
  And match response.description == 'Updated description'
  And match response.powers contains 'Intelligence'
  
  # Limpieza: Eliminamos el personaje creado
  Given path '/characters/' + createdId
  When method delete
  Then status 204

# 8. Actualizar personaje (no existe)
Scenario: Actualizar personaje (no existe)
  Given path '/characters/999'
  And request { name: "daycasti-NonExistent", alterego: "daycasti", description: "This character doesn't exist", powers: ["Nothing"] }
  When method put
  Then status 404
  And match response.error == 'Character not found'

# 9. Eliminar personaje (exitoso)
Scenario: Eliminar personaje (exitoso)
  # Primero creamos un personaje
  * def uniqueName = 'daycasti-ToDelete-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Character to delete", powers: ["Temporary"] }
  When method post
  Then status 201
  * def createdId = response.id
  
  # Luego lo eliminamos
  Given path '/characters/' + createdId
  When method delete
  Then status 204
  
  # Verificamos que se haya eliminado
  Given path '/characters/' + createdId
  When method get
  Then status 404
  And match response.error == 'Character not found'

# 10. Eliminar personaje (no existe)
Scenario: Eliminar personaje (no existe)
  Given path '/characters/999'
  When method delete
  Then status 404
  And match response.error == 'Character not found'