# Información sobre Reportes de Karate

## Generación de Reportes

Al ejecutar las pruebas con Karate DSL utilizando el comando `gradlew test` (Windows) o `./gradlew test` (Linux/Mac), los reportes se generan automáticamente en la carpeta `karate-reports/` en la raíz del proyecto.

## Estructura de Reportes

La carpeta `karate-reports/` contendrá los siguientes archivos:

- `karate-summary.html` - Resumen general de todas las pruebas ejecutadas
- `karate-tags.html` - Resumen organizado por tags (si se utilizan)
- Archivos HTML individuales para cada escenario ejecutado
- Archivos JSON con datos detallados de ejecución

## Cómo Visualizar los Reportes

1. Navega a la carpeta `karate-reports/` después de ejecutar las pruebas
2. Abre el archivo `karate-summary.html` en tu navegador web
3. Desde allí puedes navegar a los reportes detallados de cada escenario

## Información que Ofrecen los Reportes

- **Estado de la Ejecución**: Pasado/Fallido para cada escenario
- **Tiempo de Ejecución**: Duración de cada prueba
- **Detalles de Petición/Respuesta**: Información detallada de cada llamada HTTP
- **Log Completo**: Registro paso a paso de la ejecución
- **Errores**: Detalles de los fallos encontrados

## Consejos para Analizar los Reportes

1. Comienza por el resumen general para identificar escenarios fallidos
2. Para escenarios fallidos, revisa el detalle para entender la causa del error
3. Analiza los tiempos de respuesta para identificar posibles cuellos de botella
4. Utiliza la información de petición/respuesta para verificar los datos enviados y recibidos

## Personalización de Reportes

Si necesitas personalizar el formato de los reportes, puedes configurarlo en el archivo `KarateBasicTest.java` utilizando las opciones de configuración de Karate.

## Consejos para Depuración

- Añade pasos con `print` en tu archivo feature para depurar variables durante la ejecución
- Utiliza `karate.log()` para registrar información en el log
- Agrega la anotación `@debug` antes de un escenario para ejecutarlo en modo debug

---

Para más información sobre reportes en Karate, consulta la [documentación oficial](https://github.com/karatelabs/karate#html-reports).
