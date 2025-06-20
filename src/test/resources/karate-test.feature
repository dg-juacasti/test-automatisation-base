@REQ_BTH-001  @personajeBTH-001
Feature: personajeBTH-001

  Background:
    * urlapi='http://bp-se-test-cabcd9b246a5.herokuapp.com/mpbastid/api/characters'
    * urlapi2='http://bp-se-test-cabcd9b246a5.herokuapp.com/mpbastid/api/characters/1'
    * urlapi3='http://bp-se-test-cabcd9b246a5.herokuapp.com/mpbastid/api/characters/999'

  @id:1 @crearPersonajeExitoso
  Scenario Outline: T-API-personajeBTH-001- Crear personaje exitoso
    Given url urlapi
    When method POST
    Then status 200
    * print response
    And def user = read('classpath:../data/crearpersonaje.json')
    And request user
    Examples:
      | dummy |
      | 1     |
  @id:2 @crearPersonajeDuplicado
  Scenario Outline: T-API-personajeBTH-001- Crear personaje duplicado
    Given url urlapi
    When method POST
    Then status 400
    * print response
    And def user = read('classpath:../data/crearPersonajeDuplicado.json')
    And request user
    Examples:
      | dummy |
      | 1     |

  @id:3 @crearPersonajeFaltanCampos
  Scenario Outline: T-API-personajeBTH-001- Crear personaje con campos faltantes
    Given url urlapi
    When method POST
    Then status 400
    * print response
    And def user = read('classpath:../data/crearPersonajeFaltanCampos.json')
    And request user
    Examples:
      | dummy |
      | 1     |

  @id:4 @obtenerTodosPersonajes
  Scenario Outline: T-API-personajeBTH-001- Obtener todos los personajes
    Given url urlapi
    When method GET
    Then status 200
    * print response
    Examples:
      | dummy |
      | 1     |

  @id:5 @obtenerPersonajePorID
  Scenario Outline: T-API-personajeBTH-001- Obtener personaje por ID
    Given url urlapi2
    When method GET
    Then status 200
    * print response
    Examples:
      | dummy |
      | 1     |
  @id:6 @obtenerPersonajePorIDNoExiste
  Scenario Outline: T-API-personajeBTH-001- Obtener personaje por ID no existe
    Given url urlapi3
    When method GET
    Then status 404
    * print response
    Examples:
      | dummy |
      | 1     |