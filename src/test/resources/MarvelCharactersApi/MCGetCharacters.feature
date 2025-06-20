@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes
Feature: Validar estructura básica de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'

  # Leer el personaje creado desde archivo JSON
  * def fs = Java.type('java.nio.file.Files')
  * def path = Java.type('java.nio.file.Paths').get('target/character.json')
  * def characterInfo = JSON.parse(fs.readString(path))
  * def createdId = characterInfo.id
  * def createdName = characterInfo.name

Scenario: Obtener lista de personajes y validar estructura básica
  Given url endpoint
  When method GET
  Then status 200
  And match response == '#[]'
  * assert response.length > 0
  And match each response contains { id: '#notnull' }
  And match each response contains { name: '#string' }
  And match each response contains { alterego: '#string' }

Scenario: Validar tipos de propiedades en personajes
  Given url endpoint
  When method GET
  Then status 200
  And match response != null
  And match each response contains { id: '#number', name: '#string', alterego: '#string', description: '#string' }

Scenario: Validar poderes de personajes opcionales
  Given url endpoint
  When method GET
  Then status 200
  And match each response == '#? !_.powers || _.powers instanceof Array'

Scenario: Validar que personaje creado esté presente en la lista
  * def fs = Java.type('java.nio.file.Files')
  * def path = Java.type('java.nio.file.Paths').get('target/character.json')
  * def characterInfo = JSON.parse(fs.readString(path))

  Given url endpoint
  When method GET
  Then status 200

  # Crear un objeto esperado para buscarlo en la lista
  * def expectedCharacter = {}
  * expectedCharacter.name = characterInfo.name
  * expectedCharacter.id = '#number'
  * expectedCharacter.alterego = '#string'
  * expectedCharacter.description = '#string'
  * expectedCharacter.powers = '#[]'

  * match response contains expectedCharacter

  # Verificar que al menos uno en la respuesta coincida con los valores
  * match response contains expectedCharacter

Scenario: Error Obtener personaje inexistente debe retornar error 404
  * def characterId = 999
  * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

  Given url endpoint
  When method GET
  Then status 404
  And match response ==
    """
    {
      error: "Character not found"
    }
    """

Scenario: Obtener personaje existente por ID 3 exitosamente
  * def characterId = 3
  * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

  Given url endpoint
  When method GET
  Then status 200
  And match response ==
    """
    {
      id: 3,
      name: "Iron Man",
      alterego: "Tony Stark",
      description: "Genius billionaire",
      powers: ["Armor", "Flight"]
    }
    """
  And match response.name == "Iron Man"


Scenario: Obtener personaje existente por ID dinamico, valida recien creado
  * def characterId = characterInfo.id
   * def endpoint = baseUrl + '/' + testUser + '/api/characters/' + characterId

   Given url endpoint
   When method GET
   Then status 200
   And match response ==
   """
     {
       id: '#number',
       name: '#(characterInfo.name)',
       alterego: '#string',
       description: '#string',
       powers: '#[]'
     }
   """
   And match response.name == characterInfo.name
