@REQ_HU_KEY-001 @karate @Celula_Identidades @Marvin_Garcia @maragarc@pichincha.com
Feature: Test de API súper simple

  Background:
    * configure ssl = true
    * def urlBase = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/maragarc/api/characters'
  
  @id:1 @GetAllHeros
  Scenario: Verificar que los heroes existen
    Given url urlBase
    When method get
    Then status 200
    And match response == '#[]'
    * print response