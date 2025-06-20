Feature: API de Personajes Marvel

Background:
  # Configuración básica
  * configure ssl = true
  * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api'
  * configure readTimeout = 60000
  * configure connectTimeout = 60000
  * configure headers = { 'Content-Type': 'application/json' }    # Generador de nombres únicos para evitar conflictos
  * def nameRandom = 'Iron Man-' + java.util.UUID.randomUUID()
  * def daycastiName = 'daycasti-' + java.util.UUID.randomUUID()
  
  # Esquema para validación de respuestas
  * def characterSchema = { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#array' }
  
  # Datos de personajes predefinidos basados en la colección Postman
  * def ironManData = { name: "Iron Man", alterego: "daycasti", description: "Genius billionaire", powers: ["Armor", "Flight"] }

@Get @all
Scenario: Verificar que /characters responde 200 con un array
  Given path '/characters'
  When method get
  Then status 200
  And match response == '#array'

@Get @all
Scenario: Verificar que los elementos de /characters contienen id y nombre
  Given path '/characters'
  When method get
  Then status 200
  And match each response contains { id: '#number', name: '#string' }

@Get @filter
Scenario: Filtrar personajes por nombre
  # Primero creamos un personaje con nombre único para garantizar que exista
  * def uniqueHeroName = 'DaycastiHero-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueHeroName)", alterego: "daycasti", description: "Filterable hero", powers: ["Search", "Filter"]}
  When method post
  Then status 201
  * def heroId = response.id
  
  # Ahora buscar por ese nombre
  Given path '/characters'
  And param name = uniqueHeroName
  When method get
  Then status 200
  And match response[0].name == uniqueHeroName
  
  # Limpiamos: eliminamos el personaje creado
  Given path '/characters/' + heroId
  When method delete
  Then status 204

@Get @filter
Scenario: Filtrar personajes por poder específico
  # Primero creamos un personaje con poder único
  * def uniquePower = 'DaycastiPower-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "PowerHero-" + java.util.UUID.randomUUID(), alterego: "daycasti", description: "Hero with unique power", powers: ["#(uniquePower)", "Strength"]}
  When method post
  Then status 201
  * def powerHeroId = response.id
  
  # Ahora buscar por ese poder
  Given path '/characters'
  And param power = uniquePower
  When method get
  Then status 200
  And match response[0].powers contains uniquePower
  
  # Limpiamos: eliminamos el personaje creado
  Given path '/characters/' + powerHeroId
  When method delete
  Then status 204

@Get @stats
Scenario: Obtener estadísticas de personajes
  Given path '/characters/stats'
  When method get
  Then status 200
  And match response contains { totalCharacters: '#number', powerStats: '#object' }

Scenario: Crear nuevo personaje, obtener personaje creado, verificar que no puedo volver a crear con el mismo nombre, eliminarlo y comprabar que no puedo obtenerlo
  # Post crear persona (basado en el ejemplo de Postman)
  Given path '/characters'
  And request { name: "#(nameRandom)", alterego: "daycasti", description: "Genius billionaire", powers: ["Armor", "Flight"]}
  When method post
  Then status 201
  * def nuevoId = response.id
  
  #get personaje creado
  Given path '/characters/' + nuevoId
  When method get
  Then status 200
  And match response contains { id: '#number', name: '#string' }
  And match response.id == nuevoId
  And match response.name == nameRandom
    # Post intentar crear nuevamente (como en el ejemplo Postman de nombre duplicado)
  Given path '/characters'
  And request { name: "#(nameRandom)", alterego: "daycasti", description: "Genius billionaire", powers: ["Armor", "Flight"]}
  When method post
  Then status 400
  And match response.error == "Character name already exists"

  # Delete Elimnar Personaje Creado
  Given path '/characters/' + nuevoId
  When method delete
  Then status 204
  
  # Obtener personaje eliminado
  Given path '/characters/' + nuevoId
  When method get
  Then status 404
  And match response.error == 'Character not found'

Scenario: Crear personaje, actualizarlo y eliminarlo
  # Post crear personaje
  Given path '/characters'
  And request { name: "#(daycastiName)", alterego: "daycasti", description: "Superhéroe desarrollador", powers: ["Java", "Testing"]}
  When method post
  Then status 201
  * def nuevoId = response.id
  
  # Put actualizar personaje creado (como ejemplo de Postman)
  Given path '/characters/' + nuevoId
  And request { name: "#(daycastiName)", alterego: "daycasti", description: "Updated description", powers: ["Armor", "Flight"]}
  When method put
  Then status 200
  And match response contains { id: '#number', name: '#string' }

  # Delete Elimnar Personaje Creado
  Given path '/characters/' + nuevoId
  When method delete
  Then status 204

@Get @one
Scenario: Verificar que el de /characters/{id} devulve error con un id mal formado
  Given path '/characters/aaaa'
  When method get
  Then status 500
  And match response.error == 'Internal server error'

@Post
Scenario: Verificar que se no se crea un personaje con datos vacios
  Given path '/characters'
  And request { }
  When method post
  Then status 400
  And match response.name == "Name is required"
  And match response.description == "Description is required"
  And match response.powers == "Powers are required"
  And match response.alterego == "Alterego is required"

@Post @validation
Scenario: Verificar que se no se crea un personaje con array de poderes vacío
  Given path '/characters'
  And request { name: "TestHero", alterego: "Test Alterego", description: "Test Description", powers: [] }
  When method post
  Then status 400
  And match response.powers == "Powers are required"

@Post @validation
Scenario: Verificar que se no se crea un personaje con nombre muy largo
  * def longName = new Array(256).join('a') // Nombre de 255 caracteres 'a'
  Given path '/characters'
  And request { name: "#(longName)", alterego: "Test", description: "Test", powers: ["Power1"] }
  When method post
  Then status 400
  
@Post @validation
Scenario: Verificar creación de personaje con poderes múltiples
  * def heroName = "MultiPower-" + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(heroName)", alterego: "daycasti", description: "Hero with many powers", powers: ["Power1", "Power2", "Power3", "Power4", "Power5"] }
  When method post
  Then status 201
  And match response.powers == ["Power1", "Power2", "Power3", "Power4", "Power5"]
  And match response.powers.length == 5
  
  # Limpiamos
  * def heroId = response.id
  Given path '/characters/' + heroId
  When method delete
  Then status 204

@Put
Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no existe
  Given path '/characters/1'
  And request { name: "Iron Man" , alterego: "daycasti", description: "Updated description", powers: ["Armor", "Flight"]}
  When method put
  Then status 404
  And match response.error == "Character not found"

@Put
Scenario: Verificar que devuleve error cuando intento actualizar un personaje con un id que no invalido
  Given path '/characters/aaa'
  And request { name: "Iron Man" , alterego: "daycasti", description: "Updated description", powers: ["Armor", "Flight"]}
  When method put
  Then status 500
  And match response.error == 'Internal server error'

@Put @complete
Scenario: Actualización completa de un personaje cambiando todos los campos
  # Primero creamos un personaje
  * def initialName = "UpdateAll-" + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(initialName)", alterego: "Initial Alterego", description: "Initial description", powers: ["Power1", "Power2"] }
  When method post
  Then status 201
  * def heroId = response.id
  
  # Actualizamos todos los campos
  * def updatedName = "Updated-" + java.util.UUID.randomUUID()
  Given path '/characters/' + heroId
  And request { name: "#(updatedName)", alterego: "daycasti Updated", description: "Completely updated description", powers: ["NewPower1", "NewPower2", "NewPower3"] }
  When method put
  Then status 200
  And match response.name == updatedName
  And match response.alterego == "daycasti Updated"
  And match response.description == "Completely updated description"
  And match response.powers contains "NewPower3"
  And match response.powers.length == 3
  
  # Limpiamos
  Given path '/characters/' + heroId
  When method delete
  Then status 204

@Put @validation
Scenario: Verificar error al actualizar con datos inválidos
  # Primero creamos un personaje
  Given path '/characters'
  And request { name: "ToUpdate-" + java.util.UUID.randomUUID(), alterego: "daycasti", description: "Hero to update", powers: ["Power1"] }
  When method post
  Then status 201
  * def heroId = response.id
  
  # Intentamos actualizar con datos inválidos
  Given path '/characters/' + heroId
  And request { name: "", alterego: "", description: "", powers: [] }
  When method put
  Then status 400
  
  # Limpiamos
  Given path '/characters/' + heroId
  When method delete
  Then status 204

@Delete
Scenario: Verificar que devuleve error cuando elimino un registro que no existe
  Given path '/characters/1'
  When method delete
  Then status 404
  And match response.error == "Character not found"

@Delete
Scenario: Verificar que devuleve error cuando elimino un registro con un id invalido
  Given path '/characters/aaaaa'
  When method delete
  Then status 500
  And match response.error == 'Internal server error'
  
@Delete @bulk
Scenario: Crear y eliminar múltiples personajes consecutivamente
  # Crear personaje 1
  * def name1 = "ToDelete1-" + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(name1)", alterego: "daycasti", description: "First delete test", powers: ["Delete"] }
  When method post
  Then status 201
  * def id1 = response.id
  
  # Crear personaje 2
  * def name2 = "ToDelete2-" + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(name2)", alterego: "daycasti", description: "Second delete test", powers: ["Delete"] }
  When method post
  Then status 201
  * def id2 = response.id
  
  # Eliminar personaje 1
  Given path '/characters/' + id1
  When method delete
  Then status 204
  
  # Eliminar personaje 2
  Given path '/characters/' + id2
  When method delete
  Then status 204
  
  # Verificar que ambos fueron eliminados
  Given path '/characters/' + id1
  When method get
  Then status 404
  
  Given path '/characters/' + id2
  When method get
  Then status 404

@Patch
Scenario: Actualizar parcialmente solo los poderes de un personaje
  # Primero creamos un personaje
  * def heroName = "PatchTest-" + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(heroName)", alterego: "daycasti", description: "Hero for patch test", powers: ["Original Power"] }
  When method post
  Then status 201
  * def heroId = response.id
  
  # Actualizamos solo los poderes con PATCH
  Given path '/characters/' + heroId + '/powers'
  And request { powers: ["Updated Power 1", "Updated Power 2"] }
  When method patch
  Then status 200
  And match response.name == heroName
  And match response.powers == ["Updated Power 1", "Updated Power 2"]
  
  # Limpiamos
  Given path '/characters/' + heroId
  When method delete
  Then status 204
  
@Patch
Scenario: Error al intentar actualizar poderes con un ID inválido
  Given path '/characters/aaaa/powers'
  And request { powers: ["Power1", "Power2"] }
  When method patch
  Then status 500
  And match response.error == 'Internal server error'
  
@Patch
Scenario: Error al intentar actualizar poderes de un personaje que no existe
  Given path '/characters/9999/powers'
  And request { powers: ["Power1", "Power2"] }
  When method patch
  Then status 404
  And match response.error == 'Character not found'

@Get @health
Scenario: Verificar que la API está disponible
  Given path '/health'
  When method get
  Then status 200
  And match response contains { status: '#string' }
  
@Advanced
Scenario: Flujo completo - Creación, búsqueda, actualización parcial, actualización completa y eliminación
  # 1. Crear personaje con nombre único
  * def uniqueName = 'CompleteFlow-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Initial description", powers: ["Initial Power"] }
  When method post
  Then status 201
  * def heroId = response.id
  
  # 2. Buscar por nombre
  Given path '/characters'
  And param name = uniqueName
  When method get
  Then status 200
  And match response[0].id == heroId
  
  # 3. Actualizar parcialmente (solo poderes)
  Given path '/characters/' + heroId + '/powers'
  And request { powers: ["Updated Power 1", "Updated Power 2"] }
  When method patch
  Then status 200
  And match response.powers == ["Updated Power 1", "Updated Power 2"]
  
  # 4. Actualizar completamente
  Given path '/characters/' + heroId
  And request { name: "#(uniqueName)", alterego: "daycasti updated", description: "Fully updated description", powers: ["Final Power 1", "Final Power 2", "Final Power 3"] }
  When method put
  Then status 200
  And match response.description == "Fully updated description"
  And match response.powers contains "Final Power 3"
  
  # 5. Verificar actualización
  Given path '/characters/' + heroId
  When method get
  Then status 200
  And match response.alterego == "daycasti updated"
  
  # 6. Eliminar personaje
  Given path '/characters/' + heroId
  When method delete
  Then status 204
  
  # 7. Verificar eliminación
  Given path '/characters/' + heroId
  When method get
  Then status 404

@Performance
Scenario: Verificar tiempo de respuesta en operaciones consecutivas
  # Creamos un personaje y medimos el tiempo
  * def start = new Date().getTime()
  
  * def uniqueName = 'PerformanceTest-' + java.util.UUID.randomUUID()
  Given path '/characters'
  And request { name: "#(uniqueName)", alterego: "daycasti", description: "Performance test", powers: ["Speed"] }
  When method post
  Then status 201
  * def heroId = response.id
  
  # Hacemos consulta GET y medimos tiempo
  Given path '/characters/' + heroId
  When method get
  Then status 200
  
  # Eliminamos el personaje
  Given path '/characters/' + heroId
  When method delete
  Then status 204
  
  # Comprobamos que todo el flujo tarda menos de 3 segundos
  * def end = new Date().getTime()
  * def totalTime = end - start
  * print 'Tiempo total de operaciones (ms): ' + totalTime
  * assert totalTime < 3000
