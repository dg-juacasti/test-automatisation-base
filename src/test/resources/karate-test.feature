Feature: Crear múltiples personajes con Karate

  Background:
    * url baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com/{esampedr}/api/characters
      * def characters =
  """
  [
    {
      "id": 32,
      "name": "Iron Man",
      "alterego": "Tony Stark",
      "description": "Updated description",
      "powers": [ "Armor", "Flight" ]
    },
    {
      "id": 33,
      "name": "Test Special-1750394698980",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 2,
      "name": "Spider-Man Test",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel para testing",
      "powers": [ "Agilidad", "Sentido arácnido", "Trepar muros" ]
    },
    {
      "id": 34,
      "name": "Valid Character-1750394792389",
      "alterego": "Valid Alter",
      "description": "Valid description",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 3,
      "name": "A...A",
      "alterego": "A...A",
      "description": "A...A",
      "powers": [ "A...A" ]
    },
    {
      "id": 35,
      "name": "Test Special-1750394793916",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 4,
      "name": "Character with many powers",
      "alterego": "Many Powers Alter",
      "description": "Personaje con muchos poderes",
      "powers": [ "Poder 1", "Poder 2", "Poder 3", "Poder 4", "Poder 5", "Poder 6", "Poder 7", "Poder 8", "Poder 9", "Poder 10" ]
    },
    {
      "id": 36,
      "name": "Valid Character-1750394826921",
      "alterego": "Valid Alter",
      "description": "Valid description",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 37,
      "name": "Test Special-1750394828328",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 38,
      "name": "Valid Character-1750394870213",
      "alterego": "Valid Alter",
      "description": "Valid description",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 39,
      "name": "Test Special-1750394871627",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 8,
      "name": "'; DROP TABLE characters; --",
      "alterego": "SQL Injection Test",
      "description": "Test de seguridad",
      "powers": [ "SQL Power" ]
    },
    {
      "id": 41,
      "name": "Spider Man",
      "alterego": "Peter Parker",
      "description": "student",
      "powers": [ "Flight" ]
    },
    {
      "id": 42,
      "name": "Iron Man",
      "alterego": "Otro",
      "description": "Otro",
      "powers": [ "Armor" ]
    },
    {
      "id": 44,
      "name": "Iron Man2",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": [ "Armor", "Flight" ]
    },
    {
      "id": 45,
      "name": "Test",
      "alterego": "Tony Stark",
      "description": "Genius billionaire",
      "powers": [ "Armor", "Flight" ]
    },
    {
      "id": 14,
      "name": "Spider-Man Test AAA",
      "alterego": "Peter Parker AA",
      "description": "Superhéroe arácnido de Marvel para testing",
      "powers": [ "Agilidad", "Sentido arácnido", "Trepar muros" ]
    },
    {
      "id": 16,
      "name": "Batman",
      "alterego": "Bruce Wayne",
      "description": "Genius billionaire",
      "powers": [ "Strong", "Force" ]
    },
    {
      "id": 27,
      "name": "Valid Character-1750394549392",
      "alterego": "Valid Alter",
      "description": "Valid description",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 28,
      "name": "Test Special-1750394550905",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 29,
      "name": "Special Test #(timestamp)",
      "alterego": "Alter Ego Test",
      "description": "Descripción con acentos: áéíóú",
      "powers": [ "Power Español", "Power Test" ]
    },
    {
      "id": 30,
      "name": "Valid Character-1750394648357",
      "alterego": "Valid Alter",
      "description": "Valid description",
      "powers": [ "Power1", "Power2" ]
    },
    {
      "id": 31,
      "name": "Test Special-1750394649920",
      "alterego": "Special Alter",
      "description": "Description with symbols",
      "powers": [ "Power1", "Power2" ]
    }
  ]
  """

  Scenario: Enviar todos los personajes al backend
    * def createCharacter =
  """
  function(c) {
    var res = karate.callSingle({
      method: function() {
        karate.log('Creando personaje con ID:', c.id);
        var response = karate.call({
          url: baseUrl,
          request: c,
          method: 'POST'
        });
        return response;
      }
    });
    return res;
  }
  """
    * karate.forEach(characters, createCharacter)
