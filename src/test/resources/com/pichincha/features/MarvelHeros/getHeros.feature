@REQ_KEY-001 @HU001 @marvel_heros_list @bp_dev_test 
Feature: KEY-001 Obtener los Heroes de Marvel

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maragarc/api/characters'
  
  @id:1 @getAllHeros @sucessfulRequest200
  Scenario: T-API-KEY-001-CA01 Obtener todo el listado de los Heroes de Marvel
    Given url urlBase
    When method get
    Then status 200
    And match response == '#[]'
    * print response

  @id:2 @getOneHeros @sucessfulRequest200
  Scenario: T-API-KEY-001-CA01 Obtener unicamente 1 Hero Marvel con id 1
    * def idExisting = 4
    Given url urlBase + '/'+idExisting
    When method get
    Then status 200
    And response.id == idExisting
    * def existingHero = read('classpath:data/MarvelHeros/existing_hero.json')
    * print response
    * match response == existingHero

  @id:3 @getOneHerosNotFound @notFound @unsucessfulRequest404
  Scenario: T-API-KEY-001-CA03 Verificar que un héroe no existe con id 999
    * def idNotFound = 999
    Given url urlBase + '/'+ idNotFound
    When method get
    Then status 404
    * print response
    And match response == { error: 'Character not found' }


