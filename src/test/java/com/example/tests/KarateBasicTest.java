package com.example.tests;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.AfterAll;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

import static org.junit.jupiter.api.Assertions.assertEquals;

class KarateBasicTest {
    
    private static final Logger logger = Logger.getLogger(KarateBasicTest.class.getName());
    private static final String KARATE_OUTPUT_PATH = "build/karate-reports";
    
    @BeforeAll
    static void beforeAll() {
        // Configurar properties del sistema
        System.setProperty("karate.ssl", "true");
        System.setProperty("karate.env", "test");
        
        // Configurar logging
        logger.setLevel(Level.INFO);
        logger.info("Iniciando configuración de pruebas Karate");
        
        // Crear directorio de reportes si no existe
        File karateOutputDir = new File(KARATE_OUTPUT_PATH);
        if (!karateOutputDir.exists()) {
            karateOutputDir.mkdirs();
            logger.info("Directorio de reportes creado: " + KARATE_OUTPUT_PATH);
        }
    }
    
    @Test
    void testMarvelCharactersAPI() {
        logger.info("Ejecutando pruebas completas de Marvel Characters API...");
        
        // Ejecutar todas las pruebas del archivo karate-test.feature
        Results results = Runner.path("classpath:karate-test.feature")
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .outputHtmlReport(true)
                .reportDir(KARATE_OUTPUT_PATH)
                .parallel(1);
        
        logger.info("Pruebas ejecutadas. Escenarios totales: " + results.getScenariosTotal());
        logger.info("Escenarios exitosos: " + (results.getScenariosTotal() - results.getFailCount()));
        logger.info("Escenarios fallidos: " + results.getFailCount());
        
        if (results.getFailCount() > 0) {
            logger.severe("Algunas pruebas fallaron. Revisar el reporte en: " + KARATE_OUTPUT_PATH);
        }
        
        // Generar reporte de Cucumber
        generateCucumberReport();
        
        // Verificar que todas las pruebas pasaron
        assertEquals(0, results.getFailCount(), 
            "Hay " + results.getFailCount() + " escenarios que fallaron");
    }
    
    private void generateCucumberReport() {
        logger.info("Generando reporte de Cucumber...");
        
        try {
            Collection<File> jsonFiles = org.apache.commons.io.FileUtils.listFiles(
                new File(KARATE_OUTPUT_PATH), 
                new String[]{"json"}, 
                true);
            
            List<String> jsonPaths = new ArrayList<>();
            for (File file : jsonFiles) {
                jsonPaths.add(file.getAbsolutePath());
            }
            
            if (!jsonPaths.isEmpty()) {
                Configuration config = new Configuration(new File(KARATE_OUTPUT_PATH), "Karate Test Report");
                config.setBuildNumber("1.0");
                config.addClassifications("Platform", System.getProperty("os.name"));
                config.addClassifications("Java Version", System.getProperty("java.version"));
                config.addClassifications("Environment", "Test");
                
                ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
                reportBuilder.generateReports();
                
                logger.info("Reporte de Cucumber generado exitosamente en: " + KARATE_OUTPUT_PATH);
            } else {
                logger.warning("No se encontraron archivos JSON para generar el reporte");
            }
            
        } catch (Exception e) {
            logger.severe("Error al generar reporte de Cucumber: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @AfterAll
    static void afterAll() {
        logger.info("Pruebas de Karate finalizadas");
        logger.info("Los reportes están disponibles en: " + KARATE_OUTPUT_PATH);
    }
}
