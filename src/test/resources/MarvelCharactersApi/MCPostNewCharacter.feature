@REQ_PQBP-637
@id:2
@MarvelCharactersApi
@crear-personaje

Feature: Crear un nuevo personaje en la API de personajes

Background:
  * def baseUrl = karate.get('baseUrl')
  * def testUser = karate.get('testUser')
  * def endpoint = baseUrl + '/' + testUser + '/api/characters'
  * def characterPayload =
  """
  {
    "name": "Iron Maan",
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
  And match response.name == characterPayload.name
  And match response.powers contains 'Armor'
  And match response.powers contains 'Flight'

Scenario: Intentar crear personaje con nombre duplicado
  Given url endpoint
  And request characterPayload
  When method POST
  Then status 400
  And match response ==
  """
  {
    error: 'Character name already exists'
  }
  """
