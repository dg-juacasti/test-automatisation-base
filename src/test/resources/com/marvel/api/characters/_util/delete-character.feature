Feature: Utilidad para eliminar un personaje por su ID

  Background:
    * url baseUrl
    * path '/', user, 'api/characters'

  Scenario: Eliminar un personaje de forma segura
    # El ID del personaje a eliminar se recibe como argumento (characterId)
    Given path characterId
    When method delete
    # La limpieza se considera exitosa si el personaje se borra (204)
    # o si ya no existía (404), evitando fallos innecesarios en la limpieza.
    Then match response.karate.status == 204 || response.karate.status == 404