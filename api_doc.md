# Marvel Characters API

API REST para gestión de personajes de Marvel, desarrollada en Java 17 + Spring Boot + Gradle.

## Despliegue de prueba

Ambiente de test: [http://bp-se-test-cabcd9b246a5.herokuapp.com](http://bp-se-test-cabcd9b246a5.herokuapp.com)

## Uso de la API

Todas las rutas requieren el parámetro de usuario (`{username}`) en el path:

```
http://bp-se-test-cabcd9b246a5.herokuapp.com/{username}/api/characters
```

Ejemplo usando el usuario `testuser`:

```
http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters
```

### Endpoints principales

#### Obtener todos los personajes
- **GET** `/ {username} /api/characters`

#### Obtener personaje por ID
- **GET** `/ {username} /api/characters/{id}`

#### Crear personaje
- **POST** `/ {username} /api/characters`
  - Body (JSON):
    ```json
    {
      "name": "Spider-Man",
      "alterego": "Peter Parker",
      "description": "Superhéroe arácnido de Marvel",
      "powers": ["Agilidad", "Sentido arácnido", "Trepar muros"]
    }
    ```

#### Actualizar personaje
- **PUT** `/ {username} /api/characters/{id}`
  - Body igual al POST

#### Eliminar personaje
- **DELETE** `/ {username} /api/characters/{id}`

### Respuestas y errores
- 400: Datos inválidos o personaje duplicado
- 404: Personaje no encontrado
- 500: Error interno

### Ejemplo con curl
```sh
curl -X POST \
  http://bp-se-test-cabcd9b246a5.herokuapp.com/testuser/api/characters \
  -H 'Content-Type: application/json' \
  -d '{
    "name": "Iron Man",
    "alterego": "Tony Stark",
    "description": "Genio, millonario, playboy, filántropo",
    "powers": ["Armadura", "Inteligencia"]
  }'
```

### Colección Postman
Incluida en el repo: `MarvelCharactersAPI.postman_collection.json`

---

## Levantar el proyecto localmente

1. **Requisitos previos:**
   - Java 17 instalado
   - Gradle (o usar el wrapper incluido: `./gradlew`)

2. **Clona el repositorio:**
   ```sh
   git clone https://github.com/dg-juacasti/bp-dev-test
   cd bp-dev-evaluation
   ```

3. **Construye el proyecto:**
   ```sh
   ./gradlew build o gradlew build
   ```

4. **Ejecuta la aplicación:**
   ```sh
   ./gradlew bootRun o gradlew bootRun
   ```
   o bien:
   ```sh
   java -jar app/build/libs/app-0.0.1-SNAPSHOT.jar
   ```

5. **La API estará disponible en:**
   - `http://localhost:8080/{username}/api/characters`

---

**Notas:**
- Cada usuario ({username}) tiene su propio espacio de personajes.
- Los logs están estructurados en formato JSON.
- Para dudas o problemas, abre un issue en este repositorio.

