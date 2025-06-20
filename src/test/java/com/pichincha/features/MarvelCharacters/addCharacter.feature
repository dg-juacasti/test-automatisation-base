Feature: Crear personaje en la API de Marvel Characters

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kevin/api/characters'
    * header Content-Type = 'application/json'

  @REQ_TPSREM-003 @addCharacter @casoPositivo @testAll
  Scenario: T-API-TPSREM-003-CA1-Crear personaje exitosamente
    Given request
    """
    {
      "name": "Spiderman",
      "alterego": "Peter Parker",
      "description": "Friendly neighborhood",
      "powers": ["Agility", "Spider-sense"]
    }
    """
    When method post
    Then status 201
    * print response
    * match response.name == "Spiderman"
    * match response.alterego == "Peter Parker"
    * match response.description == "Friendly neighborhood"
    * match response.powers contains "Agility"

  @REQ_TPSREM-004 @addCharacter @casoNegativo @nombreDuplicado @testAll
  Scenario: T-API-TPSREM-004-CA2-No se puede crear personaje con nombre duplicado
    Given request
    """
    {
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": ["Armor"]
    }
    """
    When method post
    Then status 400
    * match response.error == "Character name already exists"

  @REQ_TPSREM-005 @addCharacter @casoNegativo @faltanCampos @testAll
  Scenario: T-API-TPSREM-005-CA3-No se puede crear personaje si faltan campos requeridos
    Given request
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    When method post
    Then status 400
    * match response.name == "Name is required"
    * match response.description == "Description is required"
    * match response.powers == "Powers are required"
    * match response.alterego == "Alterego is required"
