# Reto Automatización de Servicios con Karate

## 🚀 Descripción
Este proyecto implementa pruebas automatizadas E2E sobre la API pública **Swagger Petstore** utilizando el framework **Karate**.  
Se cubren escenarios completos de creación, consulta, actualización y búsqueda de mascotas.

---

## 📂 Estructura del Proyecto

```bash
RetoAutomatizacionServicios/
├─ build.gradle
├─ settings.gradle
├─ gradlew
├─ gradlew.bat
├─ .gitignore
├─ README.md
├─ conclusiones.txt
└─ src
   └─ test
      ├─ java
      │  ├─ karate
      │  │  └─ TestParallel.java
      │  └─ transversal
      │     ├─ GetName.java
      │     └─ SimpleIdGenerator.java
      └─ resources
         ├─ karate
         │  └─ pet_store_e2e.feature
         ├─ jsonRequest
         │  └─ addPet.json
         ├─ karate-config.js
         └─ logback-test.xml
```

---

## ✅ Casos cubiertos

Feature: **pet_store_e2e.feature** (4 escenarios separados)

- `@add_pet` → add pet  
- `@get_by_id` → add pet and find by id  
- `@update_pet` → add pet and update status  
- `@find_by_status` → add pet and find by status  

Cada escenario es independiente: genera su propio `petId` y datos dinámicos usando utilidades Java.

---

## ▶️ Ejecución de pruebas

Para ejecutar las pruebas:

```bash
./gradlew test
```

Esto dispara el runner:

- **TestParallel.java** → ejecuta todos los features bajo `classpath:karate` en paralelo (2 hilos).

---

## 📊 Reportes

Karate genera sus propios reportes en:  

- `build/karate-reports/` → HTML con detalle de cada escenario.  

Además, el runner **TestParallel** genera reportes Cucumber en:  

- `target/`

---

## 📝 Logs útiles

Actualmente el proyecto ya incluye configuración para logs claros en:  
`src/test/resources/logback-test.xml`

```xml
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>%d{HH:mm:ss.SSS} [%level] %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- Menos ruido de librerías -->
    <logger name="org.apache.http" level="WARN"/>
    <logger name="io.netty" level="WARN"/>
    <logger name="com.jayway.jsonpath" level="WARN"/>

    <!-- Karate: INFO muestra los request/response; DEBUG si quieres más detalle -->
    <logger name="com.intuit.karate" level="INFO"/>

    <root level="INFO">
        <appender-ref ref="STDOUT"/>
    </root>
</configuration>
```

Y en `build.gradle` ya está configurado `testLogging` para mostrar resultados completos:

```groovy
tasks.withType(Test).configureEach {
    testLogging {
        events "PASSED", "FAILED", "SKIPPED", "STANDARD_OUT", "STANDARD_ERROR"
        exceptionFormat "full"
        showExceptions true
        showCauses true
        showStackTraces true
        showStandardStreams true
    }
}
```

---

## 📌 Notas finales

- Los escenarios usan `retry` para manejar consistencia eventual de la API Petstore.  
- Cada ejecución genera datos únicos (`id`, `name`) para evitar colisiones.  
- Revisa `conclusiones.txt` para un resumen de hallazgos y aprendizajes.

---

✨ Proyecto de práctica con Karate DSL + Gradle
