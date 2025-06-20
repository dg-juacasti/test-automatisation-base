Feature: Marvel Characters API - End-to-End Tests

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def username = 'testuser'
    * def basePath = '/' + username + '/api/characters'
    * configure headers = { 'Content-Type': 'application/json' }
    * def characterSchema = 
    """
    {
      id: '#number',
      name: '#string',
      alterego: '#string',
      description: '#string',
      powers: '#[] #string'
    }
    """
    * def errorSchema = 
    """
    {
      error: '#string'
    }
    """

  Scenario: E2E - Flujo completo de CRUD para personajes de Marvel
    # 1. Verificar que la lista está vacía o recuperar la lista inicial
    Given path basePath
    When method get
    Then status 200
    * def initialSize = response.length
    
    # 2. Crear un nuevo personaje con un nombre único
    * def uniqueName = 'Iron Man Test-' + java.util.UUID.randomUUID().toString().substring(0, 8)
    * def character = 
    """
    {
      "name": "#(uniqueName)",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": ["Armor", "Flight"]
    }
    """
    
    Given path basePath
    And request character
    When method post
    Then status 201
    And match response == '#(characterSchema)'
    And match response.name == character.name
    * def characterId = response.id
    
    # 3. Verificar que el personaje fue creado correctamente
    Given path basePath + '/' + characterId
    When method get
    Then status 200
    And match response == '#(characterSchema)'
    And match response.name == character.name
    
    # 4. Intentar crear un personaje con el mismo nombre (error esperado)
    Given path basePath
    And request character
    When method post
    Then status 400
    And match response.error == 'Character name already exists'
    
    # 5. Verificar que la lista de personajes ha aumentado en uno
    Given path basePath
    When method get
    Then status 200
    And match response.length == initialSize + 1
    
    # 6. Actualizar el personaje
    * character.description = 'Updated: Genius, billionaire, playboy, philanthropist'
    * character.powers = ["Armor", "Flight", "Intelligence"]
    
    Given path basePath + '/' + characterId
    And request character
    When method put
    Then status 200
    And match response == '#(characterSchema)'
    And match response.description == character.description
    And match response.powers contains 'Intelligence'
    
    # 7. Verificar que el personaje fue actualizado
    Given path basePath + '/' + characterId
    When method get
    Then status 200
    And match response.description == character.description
    
    # 8. Eliminar el personaje
    Given path basePath + '/' + characterId
    When method delete
    Then status 204
    
    # 9. Verificar que el personaje ya no existe
    Given path basePath + '/' + characterId
    When method get
    Then status 404
    And match response == '#(errorSchema)'
    And match response.error == 'Character not found'
    
    # 10. Verificar que la lista volvió a su estado original
    Given path basePath
    When method get
    Then status 200
    And match response.length == initialSize
    
  Scenario: Validación de campos requeridos
    # Probar cada campo requerido individualmente
    * def testMissingField =
    """
    function(field) {
      var payload = {
        "name": "Test Character",
        "alterego": "Test Alter Ego",
        "description": "Test Description",
        "powers": ["Test Power"]
      };
      
      if (field === 'name') payload.name = '';
      else if (field === 'alterego') payload.alterego = '';
      else if (field === 'description') payload.description = '';
      else if (field === 'powers') payload.powers = [];
      
      return payload;
    }
    """
    
    # Test nombre requerido
    * def invalidCharacter = testMissingField('name')
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response.name == 'Name is required'
    
    # Test alterego requerido
    * def invalidCharacter = testMissingField('alterego')
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response.alterego == 'Alterego is required'
    
    # Test descripción requerida
    * def invalidCharacter = testMissingField('description')
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response.description == 'Description is required'
    
    # Test poderes requeridos
    * def invalidCharacter = testMissingField('powers')
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response.powers == 'Powers are required'
    
    # Test todos los campos vacíos
    * def invalidCharacter =
    """
    {
      "name": "",
      "alterego": "",
      "description": "",
      "powers": []
    }
    """
    Given path basePath
    And request invalidCharacter
    When method post
    Then status 400
    And match response contains { name: 'Name is required' }
    And match response contains { alterego: 'Alterego is required' }
    And match response contains { description: 'Description is required' }
    And match response contains { powers: 'Powers are required' }
