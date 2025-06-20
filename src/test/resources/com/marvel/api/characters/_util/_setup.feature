@ignore
Feature: Limpieza total del entorno antes de las pruebas

  Background:
    * url baseUrl
    * path user, 'api', 'characters'

  Scenario: Borrar todos los personajes existentes para el usuario
    # 1. Obtenemos la lista de TODOS los personajes
    Given path ''
    When method get
    # No importa si falla o tiene éxito, continuamos.
    # Si la lista está vacía, la variable 'allCharacters' será un array vacío.
    * def allCharacters = response

    # 2. Usamos un bucle para borrar cada personaje por su ID
    # karate.forEach itera sobre la lista 'allCharacters'
    # y ejecuta el 'calleable' para cada elemento.
    * karate.forEach(allCharacters, function(character){ karate.call('delete-character.feature', { characterId: character.id }) })

    # 3. Solo para verificar, imprimimos un mensaje.
    * print '>>>> Entorno limpiado, listos para las pruebas. <<<<'