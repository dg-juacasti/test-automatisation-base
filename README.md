# Pruebas Automatizadas de la API Marvel Characters

Este proyecto contiene pruebas automatizadas usando Karate Framework para la API REST de personajes Marvel.

## Estructura del Proyecto

```
src/
  test/
    java/
      helpers/
        DataGenerator.java        # Clase para generar datos aleatorios
      KarateBasicTest.java        # Clase que ejecuta las pruebas
    resources/
      karate-config.js            # Configuración de Karate
      marvel/
        get.feature               # Pruebas de operaciones GET
        post.feature              # Pruebas de operaciones POST
        put.feature               # Pruebas de operaciones PUT
        delete.feature            # Pruebas de operaciones DELETE
        flow.feature              # Pruebas de flujo completo CRUD
```

## Casos de Prueba Implementados

1. **Operaciones GET**
   - Obtener todos los personajes
   - Obtener un personaje por ID (existente)
   - Obtener un personaje por ID (no existente)

2. **Operaciones POST**
   - Crear un personaje exitosamente
   - Intentar crear un personaje con nombre duplicado
   - Intentar crear un personaje con campos requeridos faltantes

3. **Operaciones PUT**
   - Actualizar un personaje exitosamente
   - Intentar actualizar un personaje que no existe

4. **Operaciones DELETE**
   - Eliminar un personaje exitosamente
   - Intentar eliminar un personaje que no existe

5. **Flujo Completo**
   - Crear, obtener, actualizar y eliminar un personaje en un flujo completo

## Cómo Ejecutar las Pruebas

### Usando Gradle

```bash
./gradlew test
```

### Desde un IDE

Ejecuta la clase `KarateBasicTest.java` como una prueba JUnit.

## Características

- **Datos Aleatorios**: Todas las pruebas utilizan datos aleatorios para evitar colisiones
- **Validación Completa**: Se validan todos los campos y formatos de respuesta
- **Pruebas Independientes**: Cada prueba crea sus propios datos para asegurar independencia
- **Escenarios Completos**: Se cubren tanto casos exitosos como de error

## Tecnologías Utilizadas

- Java 17
- Karate Framework 1.4.1
- JUnit 5
- Gradle
