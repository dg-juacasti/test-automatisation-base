@REQ_KEY-004 @HU004 @marvel_heros_delete @bp_dev_test
Feature: KEY-004 Eliminar los Heroes de Marvel

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maragarc/api/characters'

  @id:9 @deleteHeroSuccess @sucessfulRequest204
  Scenario: T-API-KEY-004-CA01 Eliminar un Hero Marvel exitosamente
    # create a dummy hero so it exists before deletion
    * def randomName = 'Hero-' + Java.type('java.util.UUID').randomUUID()
    * def newHero = read('classpath:data/MarvelHeros/new_hero.json')
    * set newHero.name = randomName
    Given url urlBase
    And request newHero
    When method post
    Then status 201
    * def idExisting = response.id
    Given url urlBase + '/' + idExisting
    When method delete
    Then status 204

  @id:10 @deleteHeroNotFound @unsucessfulRequest404
  Scenario: T-API-KEY-004-CA02 Eliminar un Hero Marvel no existe
    * def idNotFound = 999
    Given url urlBase + '/' + idNotFound
    When method delete
    Then status 404
    And match response == { error: 'Character not found' }
