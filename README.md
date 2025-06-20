# Proyecto de Automatización de Pruebas con Karate, Java y Gradle

Este proyecto sirve como una base robusta para la implementación de pruebas automatizadas de APIs, utilizando el framework Karate DSL, Java y Gradle. Está diseñado para facilitar la creación y ejecución de pruebas de integración y regresión para colecciones de peticiones HTTP (similares a las de Postman), asegurando la calidad y el correcto funcionamiento de los servicios.

## ¿Qué se está probando?

Actualmente, este proyecto se enfoca en la automatización de pruebas para la **API de Personajes de Marvel**. Se están probando los siguientes aspectos:

- **Creación de Personajes**: Verificación del endpoint de creación de personajes, asegurando que los datos se persistan correctamente y que las respuestas sean las esperadas.
- **Obtención de Personajes**: Validación de los endpoints para listar y obtener personajes individuales, incluyendo la estructura de la respuesta, tipos de datos y manejo de casos donde el personaje no existe.
- **Actualización de Personajes**: Pruebas del endpoint de actualización para asegurar que los cambios se reflejen adecuadamente y que la API maneje correctamente las actualizaciones parciales o completas.
- **Eliminación de Personajes**: Verificación del proceso de eliminación de personajes, confirmando que los registros se remuevan de la base de datos y que la API responda con los códigos de estado apropiados (ej. 204 No Content para éxito, 404 Not Found para personajes inexistentes).

Las pruebas están organizadas en archivos `.feature` dentro de `src/test/resources/` y cubren diferentes escenarios para cada operación CRUD (Create, Read, Update, Delete) sobre la API de Personajes de Marvel.

## Instrucciones de uso

### 1. Descarga del proyecto

Clona este repositorio en tu máquina local:

```sh
git clone https://github.com/dg-juacasti/test-automatisation-base
cd karate-test
```

### 2. Escribe tus pruebas

- Implementa los escenarios de prueba en el archivo:
  - `src/test/resources/karate-test.feature`
- Usa la sintaxis de Karate para definir los escenarios y validaciones.

### 3. Ejecuta las pruebas

Asegúrate de tener Java 17, 18 o 21 instalado y activo. Luego ejecuta:

```sh
./gradlew test o gradlew test
```

Esto compilará el proyecto y ejecutará todas las pruebas automatizadas.

---

- Si tienes problemas de SSL, puedes agregar la línea `* configure ssl = true` en el `Background` de tu archivo `.feature`.
- Los reportes de ejecución se generarán en la carpeta `karate-reports/`.
