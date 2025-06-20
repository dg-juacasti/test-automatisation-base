@REQ_KEY-002 @HU002 @marvel_heros_save @bp_dev_test
Feature: KEY-002 Crear los Heroes de Marvel

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maragarc/api/characters'

  @id:4 @createHeroSuccess @sucessfulRequest201
  Scenario: T-API-KEY-002-CA01 Crear un Hero Marvel exitosamente
    Given url urlBase
    * def randomName = 'Hero-' + Java.type('java.util.UUID').randomUUID()
    * def newHero = read('classpath:data/MarvelHeros/new_hero.json')
    * print "Changing name to new hero to avoid repeated"
    * set newHero.name = randomName
    And request newHero
    When method post
    Then status 201
    And match response.name == randomName

  @id:5 @createHeroDuplicateName @unsucessfulRequest400
  Scenario: T-API-KEY-002-CA02 Crear un Hero Marvel con nombre duplicado
    Given url urlBase
    And request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    When method post
    Then status 400
    And match response == { error: 'Character name already exists' }

  @id:6 @createHeroMissingFields @unsucessfulRequest400
  Scenario: T-API-KEY-002-CA03 Crear un Hero Marvel faltan campos requeridos
    Given url urlBase
    And request { name: '', alterego: '', description: '', powers: [] }
    When method post
    Then status 400
    And match response == { name: 'Name is required', alterego: 'Alterego is required', description: 'Description is required', powers: 'Powers are required' }
