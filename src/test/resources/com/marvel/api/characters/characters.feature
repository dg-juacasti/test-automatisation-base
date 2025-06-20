@regression
Feature: Pruebas de la API de Personajes de Marvel (Juan Carlos De La Cruz)

  Background:
    # Define la URL base para todas las peticiones de este feature
    * url baseUrl
    * path '/', user, 'api/characters'

    # Pre-carga la plantilla del personaje para reusarla en los escenarios
    * def characterSchema = read('classpath:com/marvel/api/characters/_data/character-template.json')

  Scenario: Obtener todos los personajes, esperando una lista
    Given path ''
    When method get
    Then status 200
    # Valida que la respuesta es un arreglo JSON, puede estar vacío o no.
    And match response == '#array'


  Scenario: Intentar obtener un personaje con un ID inexistente
    Given path '99999' # Un ID que es muy improbable que exista
    When method get
    Then status 404
    And match response.error == 'Character not found'


  Scenario: Crear un nuevo personaje (Spider-Man) y verificar la respuesta
    # Prepara el cuerpo de la petición usando la plantilla y datos específicos
    * def spiderman = characterSchema
    * set spiderman.name = 'Spider-Man'
    * set spiderman.alterego = 'Peter Parker'
    * set spiderman.description = 'The one and only'
    * set spiderman.powers = ['Web-slinging', 'Superhuman strength', 'Spider-sense']

    Given path ''
    And request spiderman
    When method post
    Then status 201

    # Valida que la respuesta contiene los datos enviados y un ID numérico
    And match response.id == '#number'
    And match response.name == 'Spider-Man'
    And match response.alterego == 'Peter Parker'

    # Hook para limpiar el personaje creado después del escenario, garantizando que no queden datos basura
    * def characterId = response.id
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: '#(characterId)' })


  Scenario: Intentar crear un personaje con un nombre duplicado (Hulk)
    # Preparación: Primero creamos a Hulk para que su nombre ya exista
    * def hulk = { name: 'Hulk', alterego: 'Bruce Banner', description: 'Big green guy', powers: ['Super strength'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: '#(hulk)' }
    * def hulkId = result.response.id

    # Acción: Intentamos crear otro personaje con el mismo nombre
    Given path ''
    And request hulk
    When method post
    Then status 400
    And match response.error == 'Character name already exists'

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: '#(hulkId)' })


  Scenario: Intentar crear un personaje con campos requeridos vacíos
    * def invalidBody = { name: '', alterego: '', description: '', powers: [] }
    Given path ''
    And request invalidBody
    When method post
    Then status 400
    # Valida cada uno de los mensajes de error esperados
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'


  Scenario: Actualizar un personaje existente (Iron Man)
    # Preparación: Creamos un personaje para luego actualizarlo
    * def ironMan = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius, billionaire, playboy, philanthropist', powers: ['Powered armor'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: '#(ironMan)' }
    * def ironManId = result.response.id

    # Prepara el cuerpo de la petición de actualización
    * def updatedIronMan = { name: 'Iron Man', alterego: 'Tony Stark', description: 'The man in the can', powers: ['Powered armor', 'Flight'] }

    # Acción
    Given path ironManId
    And request updatedIronMan
    When method put
    Then status 200

    # Validación: se verifica que la descripción y los poderes cambiaron
    And match response.id == ironManId
    And match response.description == 'The man in the can'
    And match response.powers contains 'Flight'

    # Limpieza
    * karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: '#(ironManId)' })


  Scenario: Eliminar un personaje existente (Thor) y verificar que fue borrado
    # Preparación: Creamos a Thor
    * def thor = { name: 'Thor', alterego: 'Thor Odinson', description: 'God of Thunder', powers: ['Mjolnir', 'Control over lightning'] }
    * def result = callonce read('classpath:com/marvel/api/characters/_util/create-and-get-id.feature') { requestBody: '#(thor)' }
    * def thorId = result.response.id

    # Acción: Eliminar a Thor
    Given path thorId
    When method delete
    Then status 204

    # Post-validación: Verificamos que al intentar obtenerlo, recibimos un 404
    Given path thorId
    When method get
    Then status 404