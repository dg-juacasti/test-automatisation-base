    Feature: Marvel Characters API tests

      Background:
        * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters'
        * configure ssl = true
        * configure ssl = true

      Scenario: Get all characters (empty list)
        When method get
        Then status 200
        And match response == []

      Scenario: Get character by ID (exists)
        Given path '1'
        When method get
        Then status 200
        And match response ==
        """
        {
          id: 1,
          name: 'Iron Man',
          alterego: 'Tony Stark',
          description: 'Genius billionaire',
          powers: ['Armor', 'Flight']
        }
        """

      Scenario: Get character by ID (not found)
        Given path '999'
        When method get
        Then status 404
        And match response.error == 'Character not found'

      Scenario: Create character (success)
        Given request
        """
        {
          name: 'Iron Man',
          alterego: 'Tony Stark',
          description: 'Genius billionaire',
          powers: ['Armor', 'Flight']
        }
        """
        When method post
        Then status 201
        And match response.name == 'Iron Man'

      Scenario: Create character (duplicate name)
        Given request
        """
        {
          name: 'Iron Man',
          alterego: 'Otro',
          description: 'Otro',
          powers: ['Armor']
        }
        """
        When method post
        Then status 400
        And match response.error == 'Character name already exists'

      Scenario: Create character (missing required fields)
        Given request
        """
        {
          name: '',
          alterego: '',
          description: '',
          powers: []
        }
        """
        When method post
        Then status 400
        And match response.name == 'Name is required'
        And match response.alterego == 'Alterego is required'
        And match response.description == 'Description is required'
        And match response.powers == 'Powers are required'

      Scenario: Update character (success)
        Given path '1'
        And request
        """
        {
          name: 'Iron Man',
          alterego: 'Tony Stark',
          description: 'Updated description',
          powers: ['Armor', 'Flight']
        }
        """
        When method put
        Then status 200
        And match response.description == 'Updated description'

      Scenario: Update character (not found)
        Given path '999'
        And request
        """
        {
          name: 'Iron Man',
          alterego: 'Tony Stark',
          description: 'Updated description',
          powers: ['Armor', 'Flight']
        }
        """
        When method put
        Then status 404
        And match response.error == 'Character not found'

      Scenario: Delete character (success)
        Given path '1'
        When method delete
        Then status 204

      Scenario: Delete character (not found)
        Given path '999'
        When method delete
        Then status 404
        And match response.error == 'Character not found'