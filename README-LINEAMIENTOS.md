Lineamientos para la creación de pruebas con Karate:
Estructura del archivo .feature:

Título:

Usar un título claro que describa la funcionalidad probada.

Ejemplo: Feature: Validar estructura básica de personajes.

Background:

Aquí se definen variables globales que se utilizarán en todos los escenarios.

Incluye configuraciones comunes como la URL base, el usuario de prueba, o cualquier parámetro de configuración que se comparta entre los escenarios.

gherkin
Copiar
Editar
Background:
* def baseUrl = karate.get('baseUrl')
* def testUser = karate.get('testUser')
* def endpoint = baseUrl + '/' + testUser + '/api/characters'
  Definición de Escenarios:

Escenarios deben seguir una estructura clara.

Incluye pasos de Given, When, Then, y And.

Given: Precondiciones necesarias para el escenario.

When: La acción o método que estamos probando.

Then: Verificación de la respuesta o comportamiento esperado.

gherkin
Copiar
Editar
Scenario: Obtener personajes y validar estructura básica
Given url endpoint
When method GET
Then status 200
And match response == '#[]'
* assert response.length > 0
  And match each response contains { id: '#notnull' }
  And match each response contains { name: '#string' }
  And match each response contains { alterego: '#string' }
  gherkin
  Copiar
  Editar
  Scenario: Validar tipos de propiedades en personajes
  Given url endpoint
  When method GET
  Then status 200
  And match response != null
  And match each response contains {
  id: '#number',
  name: '#string',
  alterego: '#string',
  description: '#string'
  }
  Uso de Variables y Configuración:

Se recomienda externalizar la URL base y otros parámetros importantes a karate-config.js.

Asegúrate de utilizar karate.get() para obtener valores desde el archivo de configuración.

Ejemplo de karate-config.js:

js
Copiar
Editar
function fn() {
var config = {};
config.baseUrl = karate.properties['baseUrlConf'] || 'http://default-url.com';
config.testUser = karate.properties['testUserConf'] || 'testuser';
return config;
}
Y en el .feature:

gherkin
Copiar
Editar
* def baseUrl = karate.get('baseUrl')
* def testUser = karate.get('testUser')
  Verificación de Respuestas:

Siempre realiza verificaciones para asegurarte de que la respuesta tiene el formato esperado.

Usa match para validar JSON o XML, y assert para verificar valores numéricos o lógicos.

gherkin
Copiar
Editar
And match response == { "id": "#number", "name": "#string", "alterego": "#string" }
Manejo de Excepciones y Errores:

Usa karate.fail() para crear pruebas negativas que verifiquen el manejo adecuado de errores.

Ejemplo de prueba para manejar un error 404:

gherkin
Copiar
Editar
Scenario: Obtener personaje no existente
Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters/nonexistent'
When method GET
Then status 404
And match response.message == 'Not Found'
Etiquetas para Clasificación:

Usa etiquetas para facilitar la ejecución de pruebas específicas.

Ejemplo: @validar-personajes @listar-personajes @API.

gherkin
Copiar
Editar
@validar-personajes
Scenario: Obtener personajes y validar estructura básica
Given url endpoint
When method GET
Then status 200
And match response == '#[]'
Organización y Limpieza:

Organiza las pruebas en subcarpetas para mantener la estructura clara y modular.

Las carpetas pueden ser por tipo de prueba (funcional, regresión, etc.), o por API (usuarios, personajes, etc.).

Ejemplo de estructura de carpetas:

bash
Copiar
Editar
src/test/resources/
├── MarvelCharactersApi/
│   ├── MCGetCharacters.feature
│   ├── MCAddCharacter.feature
│   └── ...
├── Utils/
│   └── helpers.js
└── ...
Consideraciones para API con Autenticación:

Si la API requiere autenticación (por ejemplo, token Bearer), guarda el token en karate-config.js o como propiedad de sistema y añádelo al header.

gherkin
Copiar
Editar
Background:
* def authHeader = { Authorization: 'Bearer ' + karate.get('accessToken') }
* configure headers = authHeader
  Logs y Depuración:

Usa karate.log() para registrar información útil durante la ejecución de pruebas, como respuestas de la API o valores de variables.

js
Copiar
Editar
karate.log('Base URL:', config.baseUrl);
Ejemplo Completo de un Archivo .feature:
gherkin
Copiar
Editar
@REQ_PQBP-636
@id:1
@MarvelCharactersApi
@listar-personajes

Feature: Validar estructura básica de personajes

Background:
* def baseUrl = karate.get('baseUrl')
* def testUser = karate.get('testUser')
* def endpoint = baseUrl + '/' + testUser + '/api/characters'

Scenario: Obtener personajes y validar estructura básica
Given url endpoint
When method GET
Then status 200
And match response == '#[]'
* assert response.length > 0
  And match each response contains { id: '#notnull' }
  And match each response contains { name: '#string' }
  And match each response contains { alterego: '#string' }

Scenario: Validar tipos de propiedades en personajes
Given url endpoint
When method GET
Then status 200
And match response != null
And match each response contains {
id: '#number',
name: '#string',
alterego: '#string',
description: '#string'
}

Scenario: Validar que los personajes tienen poderes
Given url endpoint
When method GET
Then status 200
And match each response.powers != null
Resumen de Buenas Prácticas:
Organiza bien tu estructura de archivos.

Usa siempre variables configuradas en karate-config.js.

Usa etiquetas para clasificar los tests.

Asegúrate de que cada escenario tenga un propósito claro y esté bien estructurado.

Verifica las respuestas de la API de forma exhaustiva utilizando match.

Utiliza herramientas de depuración como karate.log() para ayudar a identificar problemas.

Espero que este conjunto de lineamientos te sea útil para mantener una estructura ordenada y fácil de gestionar en tus pruebas de Karate. Si necesitas ajustar algo más, ¡avísame!