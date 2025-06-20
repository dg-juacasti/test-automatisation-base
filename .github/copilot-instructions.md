<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Instrucciones para Pruebas Automatizadas con Karate - Marvel Characters API

## Descripción del Proyecto

Este proyecto es una base para pruebas automatizadas usando Karate, Java y Gradle. El objetivo es implementar pruebas para todos los endpoints de la API REST de Marvel Characters utilizando la colección Postman proporcionada.

## Estructura del Proyecto

```
test-automatisation-bcochaba/
├── build.gradle (Configuración de dependencias y plugins)
├── src/
│   └── test/
│       ├── java/
│       │   └── KarateBasicTest.java (Clase para ejecutar las pruebas)
│       └── resources/
│           └── karate-test.feature (Archivo donde implementamos todos los escenarios de prueba)
└── gradle/
    └── wrapper/ (Archivos del wrapper de Gradle)
```

## Endpoints a Probar

Debemos implementar pruebas para los siguientes 10 endpoints de la API Marvel Characters:

1. **GET /testuser/api/characters** - Obtener todos los personajes
2. **GET /testuser/api/characters/{id}** - Obtener personaje por ID (exitoso)
3. **GET /testuser/api/characters/{id}** - Obtener personaje por ID (no existe)
4. **POST /testuser/api/characters** - Crear personaje (exitoso)
5. **POST /testuser/api/characters** - Crear personaje (nombre duplicado)
6. **POST /testuser/api/characters** - Crear personaje (faltan campos requeridos)
7. **PUT /testuser/api/characters/{id}** - Actualizar personaje (exitoso)
8. **PUT /testuser/api/characters/{id}** - Actualizar personaje (no existe)
9. **DELETE /testuser/api/characters/{id}** - Eliminar personaje (exitoso)
10. **DELETE /testuser/api/characters/{id}** - Eliminar personaje (no existe)

## Pasos para Implementar las Pruebas

1. **Configurar el entorno base:**
   - Definir la URL base y encabezados comunes
   - Agregar la configuración SSL necesaria

2. **Implementar escenarios de prueba:**
   - Cada endpoint debe tener su propio escenario de prueba
   - Las validaciones deben coincidir con las respuestas esperadas según la documentación

3. **Seguir la estructura de escenario de Karate:**
   - Usar `Given` para configurar la petición
   - Usar `When` para ejecutar el método HTTP
   - Usar `Then` para validar la respuesta

4. **Crear flujos completos:**
   - Utilizar la funcionalidad de creación, lectura, actualización y eliminación (CRUD)
   - Asegurar que un escenario crea los datos necesarios para los siguientes escenarios

## Implementación Detallada

A continuación se muestra la estructura completa de la implementación de pruebas para los 10 endpoints:

```gherkin
Feature: Tests de la API Marvel Characters

Background:
  * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * configure ssl = true
  * def username = 'testuser'
  * def basePath = '/' + username + '/api/characters'
  * def characterRequest = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
  * def characterUpdateRequest = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
  * def invalidCharacterRequest = { name: '', alterego: '', description: '', powers: [] }
  * def headers = { 'Content-Type': 'application/json' }

# 1. Obtener todos los personajes (al inicio sin datos)
Scenario: Obtener todos los personajes - lista vacía inicial
  Given path basePath
  When method GET
  Then status 200
  And match response == []

# 2. Crear personaje (exitoso)
Scenario: Crear personaje exitosamente
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  And match response.id == '#notnull'
  And match response.name == characterRequest.name
  And match response.alterego == characterRequest.alterego
  And match response.description == characterRequest.description
  And match response.powers == characterRequest.powers
  * def characterId = response.id

# 3. Obtener personaje por ID (exitoso)
Scenario: Obtener personaje por ID existente
  # Primero creamos un personaje para asegurarnos que existe
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora obtenemos el personaje por su ID
  Given path basePath + '/' + characterId
  When method GET
  Then status 200
  And match response.id == characterId
  And match response.name == characterRequest.name

# 4. Crear personaje con nombre duplicado
Scenario: Crear personaje con nombre duplicado debe fallar
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201

  # Intentamos crear otro con el mismo nombre
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 400
  And match response.error == 'Character name already exists'

# 5. Crear personaje con campos requeridos faltantes
Scenario: Crear personaje con campos requeridos faltantes debe fallar
  Given path basePath
  And request invalidCharacterRequest
  And headers headers
  When method POST
  Then status 400
  And match response.name == 'Name is required'
  And match response.alterego == 'Alterego is required'
  And match response.description == 'Description is required'
  And match response.powers == 'Powers are required'

# 6. Obtener todos los personajes (con datos)
Scenario: Obtener todos los personajes después de crear uno
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201

  # Ahora verificamos que la lista no esté vacía
  Given path basePath
  When method GET
  Then status 200
  And match response != []
  And match response[*].name contains 'Iron Man'

# 7. Actualizar personaje (exitoso)
Scenario: Actualizar personaje existente
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora actualizamos el personaje
  Given path basePath + '/' + characterId
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 200
  And match response.id == characterId
  And match response.name == characterUpdateRequest.name
  And match response.description == characterUpdateRequest.description

# 8. Actualizar personaje que no existe
Scenario: Actualizar personaje que no existe debe fallar
  Given path basePath + '/999'
  And request characterUpdateRequest
  And headers headers
  When method PUT
  Then status 404
  And match response.error == 'Character not found'

# 9. Eliminar personaje (exitoso)
Scenario: Eliminar personaje existente
  # Primero creamos un personaje
  Given path basePath
  And request characterRequest
  And headers headers
  When method POST
  Then status 201
  * def characterId = response.id

  # Ahora eliminamos el personaje
  Given path basePath + '/' + characterId
  When method DELETE
  Then status 204

  # Verificamos que ya no exista
  Given path basePath + '/' + characterId
  When method GET
  Then status 404

# 10. Eliminar personaje que no existe
Scenario: Eliminar personaje que no existe debe fallar
  Given path basePath + '/999'
  When method DELETE
  Then status 404
  And match response.error == 'Character not found'
```

## Consejos y Buenas Prácticas para Karate

1. **Reutilización de código:**
   - Usa variables definidas en el `Background` para evitar repetir información
   - Define llamadas comunes como funciones en archivos `.js` separados

2. **Validación de respuestas:**
   - Usa `match` para validar la estructura y contenido de las respuestas
   - Puedes usar comodines como `#string`, `#number`, `#boolean`, `#array`, `#object` y `#notnull`
   - Para arrays, puedes usar `contains`, `contains only` y `!contains`

3. **Manejo de datos:**
   - Crea datos de prueba dinámicos usando JavaScript
   - Usa `karate.randomString()` y `karate.random(n)` para generar datos aleatorios

4. **Control de flujo:**
   - Usa `callonce` para llamadas que solo necesitas ejecutar una vez
   - Usa `call` para reutilizar escenarios como funciones

5. **Depuración:**
   - Usa `print` para mostrar valores durante la ejecución
   - Revisa los reportes generados en `karate-reports/` para análisis detallado

## Errores comunes a evitar

1. No configurar correctamente los headers (Content-Type)
2. No manejar las dependencias entre escenarios correctamente
3. Olvidar la configuración SSL cuando es necesaria
4. No validar correctamente las estructuras de respuesta
5. No usar el formato adecuado para las peticiones JSON

## Ejecución de Pruebas

Para ejecutar las pruebas, se debe seguir las instrucciones del README.md:

```sh
./gradlew test
```

o en Windows:

```sh
gradlew test
```

Los reportes se generarán en la carpeta `karate-reports/`.
