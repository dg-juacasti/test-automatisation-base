function fn() {


    var utils = {


        randomString: function(length, prefix) {
            var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
            var result = prefix || '';
            for (var i = 0; i < (length || 8); i++) {
                result += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return result;
        },


        randomInt: function(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
        },

        randomElement: function(array) {
            return array[Math.floor(Math.random() * array.length)];
        },


        randomElements: function(array, count) {
            var shuffled = array.slice().sort(function() { return 0.5 - Math.random(); });
            return shuffled.slice(0, Math.min(count || 2, array.length));
        },


        uniqueTimestamp: function() {
            return Date.now() + '-' + Math.floor(Math.random() * 1000);
        }
    };

    // Datos base para generación de personajes
    var marvelData = {
        names: [
            'Spider', 'Iron', 'Captain', 'Thor', 'Hulk', 'Black', 'Doctor', 'Ant',
            'Wasp', 'Falcon', 'Vision', 'Scarlet', 'Quicksilver', 'Winter', 'War',
            'Nova', 'Star', 'Rocket', 'Groot', 'Gamora', 'Drax', 'Mantis',
            'Phoenix', 'Storm', 'Wolverine', 'Cyclops', 'Beast', 'Angel', 'Iceman'
        ],

        suffixes: [
            'Man', 'Woman', 'Girl', 'Boy', 'Lord', 'Master', 'Knight', 'Guardian',
            'Warrior', 'Hunter', 'Blade', 'Shield', 'Force', 'Power', 'Prime'
        ],

        alterEgos: [
            'Peter Parker', 'Tony Stark', 'Steve Rogers', 'Bruce Banner', 'Natasha Romanoff',
            'Thor Odinson', 'Clint Barton', 'Wanda Maximoff', 'Pietro Maximoff', 'James Barnes',
            'Sam Wilson', 'Scott Lang', 'Hope van Dyne', 'Carol Danvers', 'Stephen Strange',
            'T\'Challa', 'Shuri', 'Okoye', 'Nakia', 'Erik Killmonger', 'Janet van Dyne',
            'Hank Pym', 'Luis Gonzalez', 'Dave Smith', 'Kurt Russell', 'Maria Hill'
        ],

        powers: [
            'Super Strength', 'Flight', 'Invisibility', 'Telepathy', 'Telekinesis',
            'Super Speed', 'Energy Projection', 'Force Fields', 'Healing Factor',
            'Enhanced Agility', 'Wall Crawling', 'Web Shooting', 'Arctic Breath',
            'Heat Vision', 'X-Ray Vision', 'Super Hearing', 'Invulnerability',
            'Shape Shifting', 'Time Manipulation', 'Dimensional Travel',
            'Energy Absorption', 'Matter Manipulation', 'Precognition',
            'Astral Projection', 'Elemental Control', 'Magnetism', 'Gravity Control',
            'Size Manipulation', 'Density Control', 'Phasing', 'Duplication'
        ],

        descriptions: [
            'A powerful superhero dedicated to protecting the innocent',
            'Guardian of justice with incredible abilities',
            'Defender of Earth against cosmic threats',
            'Master of ancient mystical arts',
            'Technological genius with advanced equipment',
            'Enhanced human with extraordinary skills',
            'Cosmic entity with reality-altering powers',
            'Time-traveling warrior from the future',
            'Interdimensional being with vast knowledge',
            'Genetically enhanced super-soldier'
        ]
    };

    return {

        // Generador de personaje completamente aleatorio
        generateRandomCharacter: function(options) {
            options = options || {};
            var timestamp = utils.uniqueTimestamp();

            var name = options.name || (
                utils.randomElement(marvelData.names) +
                (Math.random() > 0.5 ? ' ' + utils.randomElement(marvelData.suffixes) : '') +
                (options.includeTimestamp !== false ? ' ' + timestamp : '')
            );

            var alterego = options.alterego || utils.randomElement(marvelData.alterEgos);
            var description = options.description || utils.randomElement(marvelData.descriptions);
            var powers = options.powers || utils.randomElements(marvelData.powers, utils.randomInt(2, 4));

            return {
                name: name,
                alterego: alterego,
                description: description,
                powers: powers,
                _metadata: {
                    timestamp: timestamp,
                    generated: new Date().toISOString()
                }
            };
        },

        // Generador de personaje con nombre específico
        generateCharacterWithName: function(baseName, suffix) {
            var timestamp = utils.uniqueTimestamp();
            var fullName = baseName + (suffix ? ' ' + suffix : '') + ' ' + timestamp;

            return this.generateRandomCharacter({
                name: fullName,
                includeTimestamp: false
            });
        },

        // Generador de datos inválidos para testing negativo
        generateInvalidCharacter: function(invalidationType) {
            var character = this.generateRandomCharacter();

            switch(invalidationType) {
                case 'missing_name':
                    delete character.name;
                    break;
                case 'empty_name':
                    character.name = '';
                    break;
                case 'null_name':
                    character.name = null;
                    break;
                case 'empty_powers':
                    character.powers = [];
                    break;
                case 'null_powers':
                    character.powers = null;
                    break;
                case 'invalid_powers_type':
                    character.powers = 'not an array';
                    break;
                case 'missing_powers':
                    delete character.powers;
                    break;
                case 'too_long_name':
                    character.name = utils.randomString(1000, 'VeryLongName');
                    break;
                case 'special_characters':
                    character.name = 'Test@#$%^&*(){}[]|\\:";\'<>?,./';
                    break;
                default:
                    delete character.name;
            }

            return character;
        },

        // Generador de batch de personajes para testing de volumen
        generateCharacterBatch: function(count, baseNamePrefix) {
            var characters = [];
            for (var i = 0; i < count; i++) {
                var character = this.generateCharacterWithName(
                    baseNamePrefix || 'BatchTest',
                    'Character' + (i + 1)
                );
                characters.push(character);
            }
            return characters;
        },

        // Generador de personajes con datos específicos para testing
        generateTestSuiteCharacters: function() {
            return {
                crud: this.generateCharacterWithName('CRUD-Test'),
                validation: this.generateCharacterWithName('Validation-Test'),
                performance: this.generateCharacterBatch(5, 'Performance'),
                security: this.generateCharacterWithName('Security-Test', 'SQLInjection\'; DROP TABLE--'),
                boundary: {
                    minimal: {
                        name: 'MinimalTest-' + utils.uniqueTimestamp(),
                        powers: ['Basic Power']
                    },
                    maximal: this.generateRandomCharacter({
                        name: 'MaximalTest-' + utils.randomString(50),
                        description: utils.randomString(500, 'Very detailed description: '),
                        powers: utils.randomElements(marvelData.powers, 10)
                    })
                }
            };
        },

        // Utilidades expuestas
        utils: utils,
        data: marvelData
    };
}