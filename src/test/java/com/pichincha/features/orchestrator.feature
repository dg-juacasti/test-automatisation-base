Feature: Orquestador de pruebas CRUD

  Scenario: Ejecutar CRUD en orden
    * call read('create-characters.feature')
    * call read('get-characters.feature')
    * call read('update-characters.feature')
    * call read('delete-characters.feature')