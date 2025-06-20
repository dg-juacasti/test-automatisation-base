@echo off
echo Ejecutando pruebas de Karate para Marvel Characters API...
echo.

:: Limpiar antes de ejecutar
call gradlew clean

:: Ejecutar pruebas
call gradlew test

:: Generar y copiar reportes
call gradlew karateReport

echo.
echo Pruebas completadas. Los reportes están en la carpeta 'karate-reports'
echo.
pause
