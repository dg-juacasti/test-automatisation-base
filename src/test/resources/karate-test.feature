@TestChapter
Feature: Test de API súper simple

  Background:
    * configure ssl = true

  @id:1 @Escenario1
  Scenario: Obtener todos los personajes
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    When method get
    Then status 200
    * print response

  @id:2 @Escenario2
  Scenario:Obtener personaje por id
    #Creo un personaje que sera usado para la prueba de borrado
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    * def randomNum = java.lang.Math.floor(100000 * Math.random())
    * def nombreUnico = 'capitan america ' + randomNum
    And request
    """
    {
      "name": "#(nombreUnico)",
      "alterego":"Steve Grant Rogers",
      "description": "Patriotic Hero",
      "powers": ["Superhuman Strength", "Enhanced Endurance"]
    }
    """
    When method post
    Then status 201
    * def idCreado = response.id    
    #Uso en la prueba
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/'+idCreado
    When method get
    Then status 200
    * print response

  @id:3 @Escenario3
  Scenario: Obtener personaje por id no existente
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/9999'
    When method get
    Then status 404
    * print response
    And match response.error == 'Character not found'

  @id:4 @Escenario4
  Scenario: Crear personaje Caso Valido
    * def randomNum = java.lang.Math.floor(100000 * Math.random())
    * def nombreUnico = 'capitan america ' + randomNum
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    And request
    """
    {
      "name": "#(nombreUnico)",
      "alterego":"Steve Grant Rogers",
      "description": "Patriotic Hero",
      "powers": ["Superhuman Strength", "Enhanced Endurance"]
    }
    """
    When method post
    Then status 201
    * print response
  @id:5 @Escenario5
  Scenario: Crear personaje Caso Nombre Duplicado
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    And request
    """
    {
      "name": "Captain America",
      "alterego": "Steve Grant Rogers",
      "description": "Patriotic Hero",
      "powers": ["Superhuman Strength", "Enhanced Endurance"]
    }
    """
    When method post
    Then status 400
    * print response
    And match response.error contains 'Character name already exists'
  
  @id:6 @Escenario6
  Scenario: Crear personaje Caso Datos invalidos
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    And request
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
    * print response
    And match response.name == 'Name is required'
    And match response.alterego == 'Alterego is required'
    And match response.description == 'Description is required'
    And match response.powers == 'Powers are required'

    @id:7 @Escenario7
    Scenario: Actualizar personaje Exitoso
    #Creo un personaje que sera usado para la prueba de actualizacion
    * def randomNum = java.lang.Math.floor(100000 * Math.random())
    * def nombreUnico = 'capitan america ' + randomNum
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
    And request
    """
    {
      "name": "#(nombreUnico)",
      "alterego":"Steve Grant Rogers",
      "description": "Patriotic Hero",
      "powers": ["Superhuman Strength", "Enhanced Endurance"]
    }
    """
    When method post
    Then status 201
    * def idCreado = response.id      
      
      #Actualizo personaje 
      Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/'+idCreado
      And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 200
    * print response
    And match response.description == 'Updated description'

    @id:8 @Escenario8
    Scenario: Actualizar personaje No existe
      Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/9999'
      And request
      """
      {
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": ["Armor", "Flight"]
      }
      """
    When method put
    Then status 404
    * print response
    And match response.error == 'Character not found'    

  @id:9 @Escenario9
  Scenario: Borrar personaje no existe
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/9999'
    When method delete
    Then status 404
    * print response
    And match response.error == 'Character not found'

  @id:10 @Escenario10
  Scenario: Borrar personaje exitoso
    #Creo un personaje que sera usado para la prueba de borrado
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters'
        * def randomNum = java.lang.Math.floor(100000 * Math.random())
    * def nombreUnico = 'capitan america ' + randomNum
    And request
    """
    {
      "name": "#(nombreUnico)",
      "alterego":"Steve Grant Rogers",
      "description": "Patriotic Hero",
      "powers": ["Superhuman Strength", "Enhanced Endurance"]
    }
    """
    When method post
    Then status 201
    * def idCreado = response.id
    #Procedo a eliminar el personaje creado
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/' + idCreado
    When method delete
    Then status 204