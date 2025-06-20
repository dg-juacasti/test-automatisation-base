@REQ_KEY-003 @HU003 @marvel_heros_update @bp_dev_test
Feature: KEY-003 Actualizar los Heroes de Marvel

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maragarc/api/characters'

  @id:7 @updateHeroSuccess @sucessfulRequest200
  Scenario: T-API-KEY-003-CA01 Actualizar un Hero Marvel exitosamente
    * def idExisting = 2
    Given url urlBase + '/' + idExisting
    * def updatedHero = read('classpath:data/MarvelHeros/updated_hero.json')
    * print updatedHero
    And request updatedHero
    When method put
    Then status 200
    * def mockHero = read('classpath:data/MarvelHeros/updated_hero.json')
    * set mockHero.id = idExisting
    And match response == mockHero

  @id:8 @updateHeroNotFound @unsucessfulRequest404
  Scenario: T-API-KEY-003-CA02 Actualizar un Hero Marvel no existe
    * def idNotFound = 999
    Given url urlBase + '/' + idNotFound
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor','Flight'] }
    When method put
    Then status 404
    And match response == { error: 'Character not found' }
