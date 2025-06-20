<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

Este proyecto es una base para pruebas automatizadas usando Karate, Java y Gradle.

## Estructura estándar del proyecto

```
src/
└── test/
    ├── java/
    │   └── utils/
    │   ├── karateBasicTest
    │   ├── MarvelApiTest       
    └── resources/
        └── karate-configs.js 
        ├── karate-test.feature
        ├── marvelCharactersApi.feature
        └── marvelE2e.feature 
```

> **IMPORTANTE**: 
> 1. Todos los archivos `.feature` DEBEN crearse en la ruta `src/test/java/resources/marvelCharactersApi/`.
> 2. Estas rutas son estándar para TODOS los proyectos y NO deben modificarse.

---        

## Objetivo

Crear escenarios `.feature` con enfoque senior: estandarizado, limpio, escalable y mantenible.  
        
### Fuentes de entrada y estrategias de generación

- **La entrada es una colección Postman:** Se usarán sus requests y ejemplos de respuesta para generar los JSON necesarios y construir los escenarios para cada caso de uso.

---

## 1. Convenciones y nombres

| Elemento            | Convención                      | Ejemplo                                 |
|---------------------|----------------------------------|-----------------------------------------|
| Archivo `.feature`  | nombreCamelCase.feature         | crearCuentaNuevaApi.feature           |
| Carpeta de features | nombre del proyecto o servicio  | src/test/java/resources/marvelCharactersApi |
| Carpeta de JSON     | nombre del servicio             | src/test/resources/data/tre_msa_savings_account |           |
| Tags escenario      | @id:N @descripcion @resultado   | @id:1 @crearCuentaKyc @solicitudExitosa200 |
| Escenarios          | T-API-ID-CAN-Descripción        | T-API-BTPMCDP-118-CA01-Crear cuenta exitosamente 201 - karate |

>
> **Nota sobre variables de entorno:** Es OBLIGATORIO usar las variables definidas en `karate-config.js` para las URLs de los microservicios. Estas variables deben tener el prefijo `port_` seguido del nombre del microservicio en snake_case. Si la variable que necesitas no existe en `karate-config.js`, debes añadirla siguiendo esta convención.
>
> **Nota sobre archivos .feature:** El nombre del archivo `.feature` debe estar en formato camelCase y ser descriptivo de la funcionalidad que se está automatizando. Por ejemplo, `crearCuentaCliente.feature`, `consultarProductoActivo.feature`, `validarTransaccionSegura.feature`. Asegúrate de que el nombre refleje claramente el propósito de las pruebas contenidas en el archivo.

---

## 2. Plantilla estándar de Feature

```gherkin
@REQ_[HISTORIA-ID] @HU[ID-SIN-PREFIJO] @descripcion_historia @nombre_microservicio @Agente2 @E2 @iniciativa_descripcion
Feature: [HISTORIA-ID] Nombre de la funcionalidad (microservicio para...)
  Background:
    * url port_nombre_microservicio
    * path '/ruta/a/endpoint'
    * def generarHeaders =
      """
      function() {
        return {
          "X-Guid": "88212f38-cc02-4083-a763-8cc09a933840",
          "X-Flow": "onboard",
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers    @id:1 @tag_descriptivo @resultado_esperado
  Scenario: T-API-[HISTORIA-ID]-CA01-Descripción acción resultado código - karate
    * def jsonData = read('classpath:data/microservicio/datos_request.json')
    And request jsonData
    When method POST
    Then status 200
    # And match response != null
    # And match response.data != null

    Examples:
      | read('classpath:data/microservicio/datos_ejemplo.json') |
```

> **Importante:** Todos los features DEBEN incluir los siguientes tags en la primera línea:
> - `@REQ_[HISTORIA-ID]`: Número de la historia de usuario (ej: @REQ_BTPMCDP-118)
> - `@HU[ID-SIN-PREFIJO]`: ID de la historia de usuario sin prefijo (ej: @HU118)
> - `@descripcion_historia`: Descripción breve de la historia de usuario en snake_case (ej: @account_creation_savings)
> - `@nombre_microservicio`: Nombre del microservicio con guion bajo (ej: @tre_msa_savings_account). Si el nombre original contiene guiones, debe convertirse a guiones bajos.
> - `@Agente2 @E2`: Tags fijos que deben ir siempre
> - `@iniciativa_descripcion`: Descripción corta de la iniciativa en snake_case (ej: @iniciativa_cuentas)
>
> Donde `[HISTORIA-ID]` debe ser reemplazado con el ID real de la historia de usuario que estás automatizando (ej: BTPMCDP-118).

---

## 3. JSON de ejemplo (`src/test/resources/data/usuarios/usuarios_validos.json`)

```json
[
  {
    "nombre": "Marco Clavijo",
    "email": "marco@test.com",
    "rol": "admin"
  },
  {
    "nombre": "Erick Torres",
    "email": "etorres@test.com",
    "rol": "usuario"
  }
]
```

---

## 4. Buenas prácticas de código limpio

- Reutiliza `Background` para `baseUrl`, autenticación y headers comunes.
- Divide escenarios por criterio de aceptación (no más de uno por escenario).
- Centraliza y reutiliza datos de prueba en `src/test/resources/data/...`.
- No hardcodees valores repetitivos (usar `karate-config.js` o archivos JSON).
- Usa `Scenario Outline` cuando haya múltiples combinaciones de datos.
- Agrupa features por proyecto en `src/test/java/com/pichincha/features`.
- **Cada feature debe tener los tags obligatorios**: `@REQ_[HISTORIA-ID] @funcionalidad @nombre_microservicio @Agente2 @E2`
- **Los escenarios deben tener el formato**: `T-API-[HISTORIA-ID]-CAXX-Descripción acción resultado código - karate`
- **Cada feature debe incluir por defecto al menos estos escenarios**:
    - Escenario para errores de validación (HTTP status 400)
    - Escenario para errores internos del servidor (HTTP status 500)
- **Solicita siempre el ID de la historia de usuario** antes de comenzar a crear un feature, para poder incluirlo correctamente en todos los lugares necesarios.
- **Gestión de variables de entorno**:
    - Las URL de los microservicios DEBEN definirse en `karate-config.js` con el formato `port_nombre_microservicio`
    - Nunca usar URLs hardcodeadas en los features, siempre usar las variables definidas en `karate-config.js`
    - Al empezar un nuevo proyecto, verificar si el microservicio ya está definido en `karate-config.js` y añadirlo si no lo está
    - Usar siempre snake_case (guiones bajos) para los nombres de microservicios, independientemente de su nombre original

---

## 5. Validaciones estándar recomendadas

| Tipo de validación | Ejemplo                                           |
|--------------------|---------------------------------------------------|
| Status             | `Then status 201`                                 |
| Campo presente     | `# And match response.id != null`                 |
| Error específico   | `Then status 409`<br>`# And match response.message == 'Ya existe'` |
| Esquema JSON       | `# And match response == karate.read('schema.json')`|
| Múltiples validaciones | `# And match response.status == 200`<br>`# And match response.data != null` |

> **Importante:** Todas las validaciones de tipo `match` deben estar comentadas en la plantilla inicial como sugerencias. Para cada escenario, se deben incluir exactamente 2 matchers comentados que sean específicos para ese caso. El desarrollador debe descomentarlas según sus necesidades específicas y puede añadir validaciones adicionales si lo requiere.

---

## 6. karate-config.js base (`src/test/java/karate-config.js`)

```javascript
function fn() {
  var env = karate.env || 'local';
  
  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080'
  };
  
  // URLs para todos los microservicios (nombrados con formato port_nombre_microservicio)
  config.port_tre_msa_savings_account = 'http://localhost:8081/tre-msa-savings-account';
  config.port_onb_msa_bs_rt_account_detail = 'http://localhost:8082/onb-msa-bs-rt-account-detail';
  config.port_cdp_msa_bs_scheduled_savings_account = 'http://localhost:8083/cdp-msa-bs-scheduled-savings-account';
  config.port_tre_msa_brms = 'http://localhost:8084/tre-msa-brms';
  // Agrega todos los microservicios que utiliza tu proyecto
  
  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'https://api-dev.empresa.com';
    config.port_tre_msa_savings_account = 'https://api-dev.empresa.com/tre-msa-savings-account';
    config.port_onb_msa_bs_rt_account_detail = 'https://api-dev.empresa.com/onb-msa-bs-rt-account-detail';
    config.port_cdp_msa_bs_scheduled_savings_account = 'https://api-dev.empresa.com/cdp-msa-bs-scheduled-savings-account';
    config.port_tre_msa_brms = 'https://api-dev.empresa.com/tre-msa-brms';
    // Actualiza las URLs para cada microservicio en este entorno
  } 
  else if (env == 'qa') {
    config.baseUrl = 'https://api-qa.empresa.com';
    config.port_tre_msa_savings_account = 'https://api-qa.empresa.com/tre-msa-savings-account';
    config.port_onb_msa_bs_rt_account_detail = 'https://api-qa.empresa.com/onb-msa-bs-rt-account-detail';
    config.port_cdp_msa_bs_scheduled_savings_account = 'https://api-qa.empresa.com/cdp-msa-bs-scheduled-savings-account';
    config.port_tre_msa_brms = 'https://api-qa.empresa.com/tre-msa-brms';
    // Actualiza las URLs para cada microservicio en este entorno
  }
  
  return config;
}
```