Feature: Marvel Characters API - Test Suite Completo

  Background:
    * url baseUrl
    * configure ssl = false
    * def baseUrl = 'http://localhost:8080'

  @smoke @get
  Scenario: GET - Obtener todos los personajes (lista vacía inicial)
    Given url baseUrl
    When method GET
    Then status 200
    And match response == []
    And match header Content-Type contains 'application/json'

  @positive @post
  Scenario: POST - Crear personaje exitoso (Iron Man)
    Given url baseUrl
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire philanthropist",
        "powers": ["Armor", "Flight", "Repulsors"]
      }
      """
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.name == 'Iron Man'
    And match response.alterego == 'Tony Stark'
    And match response.description == 'Genius billionaire philanthropist'
    And match response.powers == ['Armor', 'Flight', 'Repulsors']
    * def ironManId = response.id

  @positive @get
  Scenario: GET - Obtener personaje por ID exitoso
    # Crear personaje primero
    Given url baseUrl
    And request
      """
      {
        "name": "Spider-Man",
        "alterego": "Peter Parker",
        "description": "Friendly neighborhood Spider-Man",
        "powers": ["Web-slinging", "Spider-sense", "Wall-crawling"]
      }
      """
    When method POST
    Then status 201
    * def spidermanId = response.id
    
    # Obtener por ID
    Given url baseUrl + '/' + spidermanId
    When method GET
    Then status 200
    And match response.id == spidermanId
    And match response.name == 'Spider-Man'
    And match response.alterego == 'Peter Parker'
    And match response.description == 'Friendly neighborhood Spider-Man'
    And match response.powers == ['Web-slinging', 'Spider-sense', 'Wall-crawling']

  @negative @get
  Scenario: GET - Obtener personaje con ID inexistente
    Given url baseUrl + '/999'
    When method GET
    Then status 404
    And match response.error == 'Character not found'

  @negative @post
  Scenario: POST - Crear personaje con nombre duplicado
    # Crear primer personaje
    Given url baseUrl
    And request
      """
      {
        "name": "Thor",
        "alterego": "Thor Odinson",
        "description": "God of Thunder",
        "powers": ["Mjolnir", "Lightning", "Super strength"]
      }
      """
    When method POST
    Then status 201
    
    # Intentar crear otro con mismo nombre
    Given url baseUrl
    And request
      """
      {
        "name": "Thor",
        "alterego": "Otro Thor",
        "description": "Otro descripción",
        "powers": ["Hammer"]
      }
      """
    When method POST
    Then status 400
    And match response.error == 'Character name already exists'

  @negative @post
  Scenario: POST - Crear personaje con campos requeridos vacíos
    Given url baseUrl
    And request
      """
      {
        "name": "",
        "alterego": "",
        "description": "",
        "powers": []
      }
      """
    When method POST
    Then status 400
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

  @negative @post
  Scenario: POST - Crear personaje sin campo name
    Given url baseUrl
    And request
      """
      {
        "alterego": "Tony Stark",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method POST
    Then status 400

  @negative @post
  Scenario: POST - Crear personaje sin campo alterego
    Given url baseUrl
    And request
      """
      {
        "name": "Iron Man",
        "description": "Genius billionaire",
        "powers": ["Armor", "Flight"]
      }
      """
    When method POST
    Then status 400

  @negative @post
  Scenario: POST - Crear personaje sin campo description
    Given url baseUrl
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "powers": ["Armor", "Flight"]
      }
      """
    When method POST
    Then status 400

  @negative @post
  Scenario: POST - Crear personaje sin campo powers
    Given url baseUrl
    And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Genius billionaire"
      }
      """
    When method POST
    Then status 400

  @positive @put
  Scenario: PUT - Actualizar personaje exitosamente
    # Crear personaje primero
    Given url baseUrl
    And request
      """
      {
        "name": "Captain America",
        "alterego": "Steve Rogers",
        "description": "First Avenger",
        "powers": ["Shield", "Super strength", "Leadership"]
      }
      """
    When method POST
    Then status 201
    * def captainId = response.id
    
    # Actualizar el personaje
    Given url baseUrl + '/' + captainId
    And request
      """
      {
        "name": "Captain America",
        "alterego": "Steve Rogers",
        "description": "Updated: The First Avenger with enhanced abilities",
        "powers": ["Shield", "Super strength", "Leadership", "Tactical skills"]
      }
      """
    When method PUT
    Then status 200
    And match response.id == captainId
    And match response.name == 'Captain America'
    And match response.alterego == 'Steve Rogers'
    And match response.description == 'Updated: The First Avenger with enhanced abilities'
    And match response.powers == ['Shield', 'Super strength', 'Leadership', 'Tactical skills']

  @negative @put
  Scenario: PUT - Actualizar personaje inexistente
    Given url baseUrl + '/999'
    And request
      """
      {
        "name": "Non-existent Hero",
        "alterego": "Nobody",
        "description": "Does not exist",
        "powers": ["Nothing"]
      }
      """
    When method PUT
    Then status 404
    And match response.error == 'Character not found'

  @positive @delete
  Scenario: DELETE - Eliminar personaje exitosamente
    # Crear personaje primero
    Given url baseUrl
    And request
      """
      {
        "name": "Hulk",
        "alterego": "Bruce Banner",
        "description": "The incredible Hulk",
        "powers": ["Super strength", "Regeneration", "Gamma radiation"]
      }
      """
    When method POST
    Then status 201
    * def hulkId = response.id
    
    # Eliminar el personaje
    Given url baseUrl + '/' + hulkId
    When method DELETE
    Then status 204
    And match response == ''

  @negative @delete
  Scenario: DELETE - Eliminar personaje inexistente
    Given url baseUrl + '/999'
    When method DELETE
    Then status 404
    And match response.error == 'Character not found'

  @integration @crud
  Scenario: CRUD Completo - Flujo de vida completo de un personaje
    # 1. Verificar lista inicial
    Given url baseUrl
    When method GET
    Then status 200
    * def initialCount = response.length
    
    # 2. Crear personaje
    Given url baseUrl
    And request
      """
      {
        "name": "Black Widow",
        "alterego": "Natasha Romanoff",
        "description": "Master spy and assassin",
        "powers": ["Combat skills", "Espionage", "Weapons mastery"]
      }
      """
    When method POST
    Then status 201
    * def characterId = response.id
    And match response.name == 'Black Widow'
    
    # 3. Verificar que se agregó a la lista
    Given url baseUrl
    When method GET
    Then status 200
    And assert response.length == initialCount + 1
    
    # 4. Obtener por ID
    Given url baseUrl + '/' + characterId
    When method GET
    Then status 200
    And match response.name == 'Black Widow'
    And match response.alterego == 'Natasha Romanoff'
    
    # 5. Actualizar
    Given url baseUrl + '/' + characterId
    And request
      """
      {
        "name": "Black Widow",
        "alterego": "Natasha Romanoff",
        "description": "Updated: Elite S.H.I.E.L.D. agent and Avenger",
        "powers": ["Combat skills", "Espionage", "Weapons mastery", "Leadership"]
      }
      """
    When method PUT
    Then status 200
    And match response.description == 'Updated: Elite S.H.I.E.L.D. agent and Avenger'
    And match response.powers contains 'Leadership'
    
    # 6. Eliminar
    Given url baseUrl + '/' + characterId
    When method DELETE
    Then status 204
    
    # 7. Verificar que ya no existe
    Given url baseUrl + '/' + characterId
    When method GET
    Then status 404
    And match response.error == 'Character not found'

  @boundary @post
  Scenario: POST - Crear personaje con caracteres especiales
    Given url baseUrl
    And request
      """
      {
        "name": "Ñoño-Man & Héroe",
        "alterego": "José María Ñoño",
        "description": "Héroe con caracteres especiales: áéíóúüñ ¡¿!",
        "powers": ["Poderes mágicos", "Súper fuerza"]
      }
      """
    When method POST
    Then status 201
    And match response.name == 'Ñoño-Man & Héroe'
    And match response.alterego == 'José María Ñoño'
    And match response.description contains 'áéíóúüñ'

  @boundary @post
  Scenario: POST - Crear personaje con nombres largos
    Given url baseUrl
    And request
      """
      {
        "name": "SuperHeroeConUnNombreMuyMuyMuyLargoQueExcedeLoNormal",
        "alterego": "PersonaConUnNombreRealMuyMuyMuyLargoQueExcedeLoNormal",
        "description": "Esta es una descripción extremadamente larga que contiene muchos detalles sobre el personaje y sus habilidades especiales que son muy importantes para la historia pero que también es muy extensa para probar los límites del sistema",
        "powers": ["Poder1", "Poder2", "Poder3", "Poder4", "Poder5", "Poder6", "Poder7", "Poder8", "Poder9", "Poder10"]
      }
      """
    When method POST
    Then status 201
    And assert response.powers.length == 10

  @validation @structure
  Scenario: Validar estructura completa de respuesta
    Given url baseUrl
    And request
      """
      {
        "name": "Doctor Strange",
        "alterego": "Stephen Strange",
        "description": "Master of the Mystic Arts",
        "powers": ["Magic", "Time manipulation", "Astral projection"]
      }
      """
    When method POST
    Then status 201
    And match response ==
      """
      {
        "id": "#number",
        "name": "Doctor Strange",
        "alterego": "Stephen Strange",
        "description": "Master of the Mystic Arts",
        "powers": ["Magic", "Time manipulation", "Astral projection"]
      }
      """
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.alterego == '#string'
    And match response.description == '#string'
    And match response.powers == '#array'
    And assert response.powers.length == 3
    And match each response.powers == '#string'

  @performance @multiple
  Scenario: Crear múltiples personajes secuencialmente
    * def characters = 
      """
      [
        {"name": "Wolverine", "alterego": "Logan", "description": "Mutant with adamantium claws", "powers": ["Regeneration", "Adamantium claws"]},
        {"name": "Storm", "alterego": "Ororo Munroe", "description": "Weather manipulator", "powers": ["Weather control", "Flight"]},
        {"name": "Cyclops", "alterego": "Scott Summers", "description": "Optic blasts leader", "powers": ["Optic blasts", "Leadership"]}
      ]
      """
    
    # Crear primer personaje
    Given url baseUrl
    And request characters[0]
    When method POST
    Then status 201
    * def id1 = response.id
    And match response.name == 'Wolverine'
    
    # Crear segundo personaje  
    Given url baseUrl
    And request characters[1]
    When method POST
    Then status 201
    * def id2 = response.id
    And match response.name == 'Storm'
    
    # Crear tercer personaje
    Given url baseUrl
    And request characters[2]
    When method POST
    Then status 201
    * def id3 = response.id
    And match response.name == 'Cyclops'
    
    # Verificar que todos fueron creados
    Given url baseUrl
    When method GET
    Then status 200
    And assert response.length >= 3

  @negative @edge-cases
  Scenario: GET - ID con valor límite negativo
    Given url baseUrl + '/-1'
    When method GET
    Then status 404

  @negative @edge-cases
  Scenario: GET - ID con valor cero
    Given url baseUrl + '/0'
    When method GET
    Then status 404

  @negative @edge-cases
  Scenario: GET - ID con string inválido
    Given url baseUrl + '/invalid-id'
    When method GET
    Then status 400

  @negative @edge-cases
  Scenario: POST - JSON malformado
    Given url baseUrl
    And request 'invalid json string'
    When method POST
    Then status 400

  @negative @edge-cases
  Scenario: DELETE - Eliminar el mismo personaje dos veces
    # Crear personaje
    Given url baseUrl
    And request
      """
      {
        "name": "Double Delete Hero",
        "alterego": "DD Hero",
        "description": "Will be deleted twice",
        "powers": ["Double deletion resistance"]
      }
      """
    When method POST
    Then status 201
    * def deleteId = response.id
    
    # Primera eliminación (exitosa)
    Given url baseUrl + '/' + deleteId
    When method DELETE
    Then status 204
    
    # Segunda eliminación (debe fallar)
    Given url baseUrl + '/' + deleteId
    When method DELETE
    Then status 404
    And match response.error == 'Character not found'
