@REQ_PQBP-637
@id:2
@MarvelCharactersApi
@crear-personaje

Feature: Crear un nuevo personaje en la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'
  * def duplicatedCharacter =
  """
  {
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Genius billionaire",
    "powers": ["Armor", "Flight"]
  }
  """
  * def uniqueName = 'Iron Man ' + new Date().getTime()
  * def characterPayload =
  """
  {
    "name": "#(uniqueName)",
    "alterego": "Tony Stark",
    "description": "Genius billionaire",
    "powers": ["Armor", "Flight"]
  }
  """

Scenario: Crear personaje exitosamente
  Given url endpoint
  And request characterPayload
  When method POST
  Then status 201
   * def createdId = response.id
   * def uniqueName = response.name
  And match response ==
  """
  {
    id: '#number',
    name: '#string',
    alterego: '#string',
    description: '#string',
    powers: '#[]'
  }
  """
  And match response.name == uniqueName
  And match response.powers contains 'Armor'
  And match response.powers contains 'Flight'

Scenario: Intentar crear personaje con nombre duplicado
  Given url endpoint
  And request duplicatedCharacter
  When method POST
  Then status 400
  And match response ==
  """
  {
    error: 'Character name already exists'
  }
  """
Scenario: Validar errores al enviar personaje con campos vacíos
  * def emptyPayload =
  """
  {
    "name": "",
    "alterego": "",
    "description": "",
    "powers": []
  }
  """
  Given url endpoint
  And request emptyPayload
  When method POST
  Then status 400
  And match response ==
  """
  {
    name: "Name is required",
    description: "Description is required",
    powers: "Powers are required",
    alterego: "Alterego is required"
  }
  """