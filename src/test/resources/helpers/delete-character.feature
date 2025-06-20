Feature: Helper para eliminar un personaje por ID

Scenario:
  # Parámetros esperados: id, basePath
  Given path basePath + '/' + id
  When method DELETE
  Then status 204 || status 404
