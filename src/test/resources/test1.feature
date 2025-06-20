Feature: Pruebas de API para personajes

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'

  Scenario: Verificar que el endpoint /jgusnay/api/characters responde 200
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200

  Scenario: Verificar estructura de personajes
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200
    * def personajes = response
    * match each personajes == { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#[]' }


  Scenario: Validar que un personaje tiene al menos 2 poderes
    Given path 'jgusnay/api/characters'
    When method get
    Then status 200
    * def personajes = response
    * def conMuchosPoderes = karate.filter(personajes, function(p) { return p.powers.length >= 2 })
    * assert conMuchosPoderes.length > 0

  Scenario: Obtener personaje existente por ID
    Given path 'jgusnay/api/characters/1'
    When method get
    Then status 200
    * match response ==
    """
    {
      id: 1,
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[]'
    }
    """

  Scenario: Obtener personaje que no existe
    Given path 'jgusnay/api/characters/9999'
    When method get
    Then status 404
    * match response == { error: 'Character not found' }