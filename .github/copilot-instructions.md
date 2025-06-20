# Instrucciones para Pruebas Automatizadas con Karate DSL y Postman

Este documento proporciona instrucciones detalladas sobre cómo implementar pruebas automatizadas usando la colección de Postman proporcionada (Marvel Characters API) en el framework Karate DSL.

## Requisitos Previos

- Java 17, 18 o 21 instalado y configurado
- Gradle instalado (o usar el wrapper incluido en el proyecto)
- Conocimientos básicos de sintaxis Gherkin/Karate DSL
- Colección de Postman de la API Marvel Characters (disponible en `.github/MarvelCharactersAPI.postman_collection.json`)

## Estructura del Proyecto

```
test-automatisation-base/
│
├── .github/                        # Documentación y recursos de GitHub
│   └── MarvelCharactersAPI.postman_collection.json   # Colección Postman
│
├── gradle/                         # Configuración de Gradle
│
├── src/
│   └── test/
│       ├── java/
│       │   └── KarateBasicTest.java    # Clase principal para ejecutar pruebas
│       │
│       └── resources/
│           ├── karate-test.feature     # Archivo de pruebas Karate
│           └── data/                   # Directorio para archivos de datos JSON
│
├── build.gradle                    # Configuración del proyecto
├── gradlew                         # Script de Gradle para Linux/Mac
├── gradlew.bat                     # Script de Gradle para Windows
└── README.md                       # Documentación general
```

## Paso 1: Comprender la Colección Postman

La colección `MarvelCharactersAPI.postman_collection.json` contiene las siguientes peticiones:

1. **Obtener todos los personajes** - GET `/testuser/api/characters`
2. **Obtener personaje por ID** - GET `/testuser/api/characters/{id}`
3. **Crear personaje** - POST `/testuser/api/characters`
4. **Actualizar personaje** - PUT `/testuser/api/characters/{id}`
5. **Eliminar personaje** - DELETE `/testuser/api/characters/{id}`
6. **Filtrar personajes por nombre** - GET `/testuser/api/characters?name={name}`
7. **Filtrar personajes por poder** - GET `/testuser/api/characters?power={power}`
8. **Obtener estadísticas de personajes** - GET `/testuser/api/characters/stats`
9. **Actualizar poder específico** - PATCH `/testuser/api/characters/{id}/powers`
10. **Verificar disponibilidad de API** - GET `/testuser/api/health`

Cada petición incluye ejemplos de respuestas esperadas y casos de prueba (exitosos y de error).

## Paso 2: Implementar las Pruebas en Karate DSL

### Configuración del Archivo Feature

Edita el archivo `src/test/resources/karate-test.feature` y configura el entorno base:

```gherkin
Feature: Marvel Characters API Tests

Background:
  * def baseUrl = 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  * def username = 'testuser'
  * url baseUrl + '/' + username + '/api/characters'
  * configure ssl = true
  * def characterSchema = { id: '#number', name: '#string', alterego: '#string', description: '#string', powers: '#array' }
  
  # Datos de prueba para crear/actualizar personajes
  * def ironMan = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
  * def invalidCharacter = { name: '', alterego: '', description: '', powers: [] }
```

### Implementar Escenarios de Prueba

A continuación, implementa los escenarios para cada petición de la colección:

```gherkin
Scenario: Obtener todos los personajes
  Given path ''
  When method GET
  Then status 200
  And match response == '#array'

Scenario: Crear un personaje exitosamente
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  And match response contains characterSchema
  And match response.name == ironMan.name
  * def createdId = response.id

Scenario: Validar error al crear personaje con nombre duplicado
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Intentamos crear otro con el mismo nombre
  Given path ''
  And request ironMan
  When method POST
  Then status 400
  And match response.message == '#string'
  And match response.message contains 'duplicate'

Scenario: Validar error al crear personaje con datos inválidos
  Given path ''
  And request invalidCharacter
  When method POST
  Then status 400
  And match response.message == '#string'

Scenario: Obtener un personaje por ID
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo consultamos por ID
  Given path '/' + createdId
  When method GET
  Then status 200
  And match response contains characterSchema
  And match response.id == createdId

Scenario: Obtener un personaje que no existe
  Given path '/99999'
  When method GET
  Then status 404

Scenario: Actualizar un personaje exitosamente
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo actualizamos
  * def updatedIronMan = { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight', 'Intelligence'] }
  Given path '/' + createdId
  And request updatedIronMan
  When method PUT
  Then status 200
  And match response.description == 'Updated description'
  And match response.powers contains 'Intelligence'

Scenario: Actualizar un personaje que no existe
  Given path '/99999'
  And request ironMan
  When method PUT
  Then status 404

Scenario: Eliminar un personaje exitosamente
  # Primero creamos un personaje
  Given path ''
  And request ironMan
  When method POST
  Then status 201
  * def createdId = response.id
  
  # Luego lo eliminamos
  Given path '/' + createdId
  When method DELETE
  Then status 200
  
  # Verificamos que se haya eliminado
  Given path '/' + createdId
  When method GET
  Then status 404

Scenario: Eliminar un personaje que no existe
  Given path '/99999'
  When method DELETE
  Then status 404
```

## Paso 3: Ejecutar las Pruebas

Para ejecutar las pruebas, usa el siguiente comando desde la raíz del proyecto:

```bash
# En Windows
gradlew test

# En Linux/Mac
./gradlew test
```

## Paso 4: Revisar los Resultados

Una vez completada la ejecución, los informes se generarán en la carpeta `karate-reports/`. Abre el archivo HTML generado en tu navegador para revisar los resultados.

## Consejos para la Implementación

1. **Datos Dinámicos**: Utiliza generación aleatoria de datos para evitar colisiones de nombres.
   ```gherkin
   * def randomName = 'Character-' + java.util.UUID.randomUUID()
   ```

2. **Compartir Datos entre Escenarios**: Para escenarios dependientes, considera usar la característica de encadenamiento (chaining) de escenarios:
   ```gherkin
   Scenario: Flujo completo - crear, consultar, actualizar y eliminar
   ```

3. **Variables de Entorno**: Si necesitas probar contra diferentes entornos, usa archivos de configuración.

4. **Manejo de Errores**: Añade aserciones robustas para validar mensajes de error:
   ```gherkin
   And match response.message contains 'error'
   ```

5. **Esquemas de Validación**: Utiliza esquemas más complejos para validar estructuras JSON.

## Problemas Comunes

- **Errores SSL**: Ya está configurado con `* configure ssl = true` en el Background.
- **Tiempo de Espera**: Si la API tarda en responder, ajusta el tiempo de espera:
  ```gherkin
  * configure readTimeout = 10000
  ```
- **Errores de Codificación**: Asegúrate de que los archivos estén en UTF-8.

## Ejemplo de Flujo Completo

```gherkin
Scenario: Flujo completo de CRUD de personaje
  # Crear
  Given path ''
  * def uniqueName = 'Hero-' + java.util.UUID.randomUUID()
  * def testCharacter = { name: '#(uniqueName)', alterego: 'Secret Identity', description: 'Test hero', powers: ['Testing'] }
  And request testCharacter
  When method POST
  Then status 201
  * def id = response.id
  
  # Leer
  Given path '/' + id
  When method GET
  Then status 200
  And match response.name == uniqueName
  
  # Actualizar
  * def updatedCharacter = { name: '#(uniqueName)', alterego: 'New Identity', description: 'Updated description', powers: ['Testing', 'Debugging'] }
  Given path '/' + id
  And request updatedCharacter
  When method PUT
  Then status 200
  And match response.description == 'Updated description'
  
  # Eliminar
  Given path '/' + id
  When method DELETE
  Then status 200
  
  # Verificar eliminación
  Given path '/' + id
  When method GET
  Then status 404
```
