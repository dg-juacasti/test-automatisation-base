Feature: Test de API súper simple

  Background:
    * def base_url='http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * def user = 'testuser'
    * def id_ = '45'
    * header Content-Type= 'application/json'
    
    
@id:1 @Consultar
  Scenario: Consultar Super heroe
    Given url base_url 
    When method GET
    Then status 200
    And print response
    And match response.status == 'string'

 @id:2 @ConsultarId
    Scenario:  ConsultarId
      Given url base_url + '/' user + 'api/characters' + id_
      When method GET
      Then status 200
      And print response
      
 @id:3 @CrearSuperHeroe
Scenario: Crear un superhéroe con método POST
  Given url base_url + '/' + user + 'api/characters'
  And request { name: 'Fuegoman', power: 'Fuego', category: { name: 'Fuegoman' } }
  When method POST
  Then status 201
  And print response
  And match response.name == 'Fuegoman'

@id:4 @CrearPersonajeDuplicado
Scenario: Crear personaje (nombre duplicado, error 400)
  Given url base_url + '/' + user + 'api/characters'
  And request { name: 'Fuegoman', power: 'Fuego', category: { name: 'Fuegoman' } }
  When method POST
  Then status 400
  And print response
  //And match response.message
  
@id:5 @CrearPersonajeDatosInvalidos
Scenario: Crear personaje (datos inválidos, error 400)
  Given url base_url + '/' + user + 'api/characters'
  And request { name: '', power: '', category: { name: '' } }
  When method POST
  Then status 400
  And print response

    @id:6 @ObtenerPersonajeInexistente
  Scenario: Obtener personaje inexistente (error 404)
    Given url base_url + '/' + user + 'api/characters/999999'
    When method GET
    Then status 404
    And print

    @id:7 @ActualizarPersonajeValido
    Scenario: Actualizar personaje (válido)
      # Primero creamos un personaje para obtener su id
      Given url base_url + '/' + user + 'api/characters'
      And request { name: 'Actualizable', power: 'Viento', category: { name: 'Elemental' } }
      When method POST
      Then status 201
      And def personajeId = response.id
    
      # Ahora actualizamos el personaje creado
      Given url base_url + '/' + user + 'api/characters/' + personajeId
      And request { name: 'Actualizado', power: 'Tormenta', category: { name: 'Elemental' } }
      When method PUT
      Then status 200
      And print response
      And match response.name == 'Actualizado'
      And match

      @id:8 @EliminarPersonajeValido
      Scenario: Eliminar personaje (válido)
        # Primero creamos un personaje para obtener su id
        Given url base_url + '/' + user + 'api/characters'
        And request { name: 'Eliminable', power: 'Agua', category: { name: 'Elemental' } }
        When method POST
        Then status 201
        And def personajeId = response.id
      
        # Ahora eliminamos el personaje creado
        Given url base_url + '/' + user + 'api/characters/' + personajeId
        When method DELETE
        Then status 200
        And print response

@id:9 @EliminarPersonajeInexistente
Scenario: Eliminar personaje inexistente (error 404)
  Given url base_url + '/' + user + 'api/characters/999999'
  When method DELETE
  Then status 404
  And print