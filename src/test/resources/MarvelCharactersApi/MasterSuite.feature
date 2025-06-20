Feature: Master suite para correr tests en secuencia

Scenario: ExecuteAllTestsInSequentiallyDefinedOrder

  * call read('classpath:MarvelCharactersApi/MCPostNewCharacter.feature')
  * call read('classpath:MarvelCharactersApi/MCGetCharacters.feature')
  * call read('classpath:MarvelCharactersApi/MCPutUpdateCharacter.feature')
  * call read('classpath:MarvelCharactersApi/MCDeleteCharacter.feature')
