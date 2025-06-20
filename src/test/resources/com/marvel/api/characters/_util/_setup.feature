@ignore
Feature: Limpieza total del entorno antes de las pruebas

  Background:
    # DEFINIMOS LA URL BASE COMPLETA AQUÍ, SIN USAR path
    * url baseUrl + '/' + user + '/api/characters'

  Scenario: Borrar todos los personajes existentes para el usuario
    # 1. Obtenemos la lista de TODOS los personajes
    # Al usar 'path' vacío, la URL será exactamente la del Background, sin barras extra.
    Given path ''
    When method get
    # IMPORTANTE: Ahora manejamos el posible error 500
    * if (responseStatus != 200) karate.abort()

    * def allCharacters = response

    # 2. Iteramos para borrar cada personaje
    * karate.forEach(allCharacters, function(character){ karate.call('classpath:com/marvel/api/characters/_util/delete-character.feature', { characterId: character.id }) })

    * print '>>>> Entorno limpiado, listos para las pruebas. <<<<'