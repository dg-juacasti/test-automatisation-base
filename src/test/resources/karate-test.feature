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
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/fjarrin/api/characters/1'
    When method get
    Then status 200
    * print response

