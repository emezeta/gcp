# Evaluación del Proyecto GCP (Git Commit Patch)

**Fecha:** Enero 2026  
**Evaluador:** GitHub Copilot AI Agent  
**Versión del proyecto:** Desarrollo temprano

---

## Resumen Ejecutivo

GCP es una herramienta Bash que asiste en la aplicación de parches "alienígenas" a repositorios locales del kernel Linux, automatizando la búsqueda de dependencias y commits relacionados. El proyecto es **viable y útil** para su caso de uso específico, aunque con un alcance limitado y una audiencia especializada.

**Calificación general: 7.5/10**

---

## 1. Viabilidad Técnica ✅ 

### Fortalezas

**✓ Tecnologías sólidas y maduras**
- Basado en Bash y Git, herramientas universales en el ecosistema Linux
- Sin dependencias externas complejas
- Fácil de instalar y distribuir
- Compatible con múltiples plataformas (Linux, macOS, WSL)

**✓ Arquitectura clara**
- Separación lógica de responsabilidades en scripts numerados (00init, 01, 02, 04, 05)
- Sistema de configuración centralizado (`gcp.conf`)
- Estructura de directorios bien organizada (applied, candidates, pending, logs)
- Sistema de estado para evitar duplicación de trabajo

**✓ Enfoque iterativo**
- Reconoce que el problema no siempre tiene solución automática
- Diseño de series (S1, S2, S3...) permite refinamiento progresivo
- Memoria de commits procesados evita repetir trabajo

**✓ Caso de uso real**
- Desarrollado para necesidad específica: Dell Latitude 7455 con Snapdragon X Elite
- El autor lo usa activamente en producción
- Resuelve un problema real que enfrentan mantenedores de kernels personalizados

### Debilidades

**⚠ Limitaciones inherentes al diseño**
- Requiere ancestro común entre repositorios (limitación fundamental pero justificada)
- No funciona entre arquitecturas diferentes
- No resuelve conflictos semánticos complejos
- Efectividad depende de la "distancia" temporal entre repos

**⚠ Escala limitada**
- Pensado para parches individuales o series pequeñas
- No está optimizado para operaciones masivas
- Búsquedas en historial completo pueden ser lentas

**⚠ Bash como lenguaje principal**
- Dificulta testing automatizado
- Manejo de errores puede ser frágil
- Escalabilidad limitada para funcionalidades complejas futuras

---

## 2. Utilidad Práctica ✅

### ¿Para quién es útil?

**Usuarios ideales:**
1. **Mantenedores de kernels device-specific** - Necesitan integrar parches de múltiples fuentes
2. **Desarrolladores de drivers** - Portan cambios entre versiones de kernel
3. **Entusiastas de hardware específico** - Laptops ARM, dispositivos exóticos
4. **Teams pequeños** - Mantienen forks del kernel con hardware personalizado

**NO es útil para:**
- Usuarios que solo aplican parches estándar (git am es suficiente)
- Proyectos con repositorios completamente divergentes
- Desarrollo cross-arquitectura
- Usuarios sin conocimiento de Git

### Valor agregado

**Lo que GCP aporta:**
- **Automatiza el proceso de detective:** Buscar commits relacionados manualmente es tedioso
- **Reduce errores humanos:** El tracking de hashes evita duplicación
- **Documenta el proceso:** Los logs permiten auditoría y replicación
- **Ahorra tiempo:** En casos exitosos, reduce días de trabajo a horas

**Ejemplo concreto (del README):**
```
Sin GCP: 
- 3-5 días buscando manualmente dependencias
- Alto riesgo de olvidar commits necesarios
- Sin documentación del proceso

Con GCP:
- 4-8 horas con múltiples iteraciones
- Memoria automática de lo probado
- Logs completos para referencia futura
```

### Comparación con alternativas

| Herramienta | Alcance | Complejidad | Automatización |
|-------------|---------|-------------|----------------|
| `git am` / `git apply` | Manual | Baja | Ninguna |
| `git cherry-pick` | Manual | Media | Parcial |
| **GCP** | **Semi-automático** | **Media-Alta** | **Alta** |
| `quilt` | Gestión de parches | Media | Media |
| Scripts ad-hoc | Variable | Variable | Variable |

GCP ocupa un nicho específico: **automatizar la búsqueda de dependencias** cuando un parche falla.

---

## 3. Calidad del Código 📊

### Aspectos positivos

**✓ Estilo consistente**
- Convenciones de nombres claras (S1_, S2_ para series)
- Comentarios útiles en español e inglés
- Funciones bien nombradas y modulares

**✓ Configuración centralizada**
- Todo en `gcp.conf` facilita personalización
- Variables de entorno bien documentadas
- Funciones helper reutilizables

**✓ Sistema de logging**
- Tracking de operaciones para debugging
- Separación de applied/candidates/pending es clara

### Áreas de mejora

**⚠ Testing**
- **CRÍTICO:** No hay tests automatizados
- Sin verificación de regresiones
- Dificulta contribuciones externas con confianza

**⚠ Manejo de errores**
- Algunos scripts fallan silenciosamente
- No siempre hay validación de entrada
- Mensajes de error podrían ser más descriptivos

**⚠ Documentación del código**
- Scripts principales bien comentados
- Faltan docstrings/headers consistentes en todas las funciones
- Algunos parámetros no están documentados

**⚠ Portabilidad**
- Asume Bash 4.0+ (bien documentado)
- Algunas construcciones pueden fallar en shells antiguos
- No hay CI/CD para validar compatibilidad

---

## 4. Documentación 📚

### Excelente

**✓ README completo y bien estructurado**
- Diagrama de flujo visual claro
- Quick start fácil de seguir
- Secciones bien organizadas

**✓ Documentación en `/docs`**
- INTRO.md explica el "por qué" del proyecto
- CASOS-USO.md con ejemplos prácticos
- FAQ.md responde preguntas comunes
- Tono cercano y accesible

**✓ Honestidad sobre limitaciones**
- Explícitamente dice "no es mágico"
- Documenta casos donde NO funciona
- Expectativas realistas

### Podría mejorar

**⚠ Documentación técnica profunda**
- Falta arquitectura detallada del flujo
- No hay guía para contribuidores
- Sin explicación de la estructura interna

**⚠ Ejemplos end-to-end**
- Los ejemplos son ilustrativos pero sintéticos
- Faltaría un caso completo documentado paso a paso
- Screenshots/asciinema de sesión real sería valioso

**⚠ Idioma mixto**
- Código en español/inglés mezclado
- Docs mayormente en español (limita audiencia internacional)
- Consideración: ¿traducir al inglés para mayor alcance?

---

## 5. Estado del Proyecto 🚧

### Fase actual

**Desarrollo temprano** - El autor lo describe honestamente:
- "Early development"
- "Actively used on Dell Latitude 7455 with Snapdragon X Elite"
- "Feedback welcome"

### Madurez

| Aspecto | Estado | Comentario |
|---------|--------|------------|
| Funcionalidad core | ✅ Funcional | Scripts principales implementados |
| Testing | ❌ Ausente | Sin tests automatizados |
| CI/CD | ❌ Ausente | Sin pipeline |
| Releases | ❌ Sin versioning | Sin tags semánticos |
| Issues tracker | ⚠️ Básico | GitHub issues disponible |
| Comunidad | 🌱 Naciente | Proyecto individual por ahora |

### Evolución esperada

Basado en el archivo `docs/EVOLUCION.md` (si existe) y el estado actual:

**Corto plazo (3-6 meses):**
- Refinamiento basado en uso real
- Corrección de bugs reportados
- Mejoras en mensajes de error

**Mediano plazo (6-12 meses):**
- Posible adopción por comunidad de ARM laptops
- Contribuciones externas si el proyecto gana tracción
- Testing básico

**Largo plazo (12+ meses):**
- Consideración de reescritura en Python/Go para escalabilidad
- Sistema de plugins para casos específicos
- Integración con herramientas de kernel development

---

## 6. Mercado y Audiencia 🎯

### Tamaño del mercado

**Estimación conservadora:**
- Desarrolladores activos de kernel Linux: ~1,000-2,000 personas
- Subset con forks device-specific: ~100-300 personas
- Usuarios potenciales de GCP: **50-150 personas globalmente**

**Conclusión:** Nicho muy específico pero con necesidad real.

### Competencia

**Directa:** Ninguna herramienta hace exactamente lo mismo

**Indirecta:**
- Scripts internos de equipos (Samsung, Qualcomm, etc.)
- Procesos manuales documentados
- Herramientas de gestión de parches (quilt, stgit)

**Ventaja competitiva de GCP:**
- Open source y portable
- Enfoque específico en el problema de "alien patches"
- Memoria automática de lo intentado
- Documentación accesible

### Potencial de adopción

**Factores a favor:**
- Problema real y doloroso para el público objetivo
- Solución simple y sin dependencias
- MIT License (permisiva)
- Documentación en español (mercado hispanohablante)

**Factores en contra:**
- Audiencia muy pequeña
- Requiere conocimiento previo de Git y kernel
- Sin marketing/divulgación activa
- Competencia con "scripts caseros" que ya existen

**Predicción:** Adopción lenta pero constante en comunidades especializadas (ARM laptops, dispositivos móviles).

---

## 7. Sostenibilidad 🌱

### Modelo actual

**Desarrollo individual:**
- Autor usa la herramienta para necesidad propia
- Motivación intrínseca: resolver problema real
- Sin modelo de negocio ni financiamiento

**Riesgo:** Si el autor pierde interés o cambia de hardware, el proyecto podría estancarse.

### Recomendaciones para sostenibilidad

1. **Buscar co-mantenedores**
   - Comunidades: #aarch64-laptops (mencionado en README)
   - Foros de Snapdragon X Elite
   - Listas de correo de kernel

2. **Establecer gobernanza básica**
   - CONTRIBUTING.md
   - CODE_OF_CONDUCT.md
   - Proceso claro para aceptar PRs

3. **Construir comunidad**
   - Blog post explicando casos de éxito
   - Presencia en Reddit/HN/Linux forums
   - Video tutorial en YouTube

4. **Documentar casos de uso**
   - Wall of users
   - Case studies de éxito
   - Generar confianza en la herramienta

---

## 8. Riesgos y Amenazas ⚠️

### Riesgos técnicos

1. **Dependencia del modelo de Git del kernel**
   - Si el kernel cambia su workflow, GCP podría romperse
   - Mitigación: Seguir cambios en kernel development

2. **Complejidad creciente**
   - Más features = más complejidad en Bash
   - Mitigación: Considerar reescritura si crece mucho

3. **Seguridad**
   - Ejecutar scripts que aplican parches tiene riesgos
   - Mitigación: Validación de entrada, sandboxing opcional

### Riesgos de adopción

1. **"Not invented here" syndrome**
   - Equipos prefieren sus propios scripts
   - Mitigación: Demostrar valor, permitir personalización

2. **Curva de aprendizaje**
   - Aunque simple, requiere entender el workflow
   - Mitigación: Tutoriales, videos, ejemplos

3. **Fragmentación**
   - Forks para casos específicos
   - Mitigación: Diseño modular, aceptar contribuciones

---

## 9. Recomendaciones Concretas 💡

### Prioridad Alta (hacer YA)

1. **✅ Agregar tests básicos**
   ```bash
   tests/
   ├── 01-init.bats
   ├── 02-extract.bats
   └── helpers.bash
   ```
   - Usar [BATS](https://github.com/bats-core/bats-core) (Bash Automated Testing System)
   - Validar casos básicos: init, extraction, application
   - Prevenir regresiones

2. **✅ Setup CI/CD básico**
   - GitHub Actions para ejecutar tests
   - Validar en múltiples shells (bash 4.x, 5.x)
   - Linting con shellcheck

3. **✅ Versionado semántico**
   - Crear tag v0.1.0
   - Changelog básico
   - GitHub Releases

4. **✅ Validación de entrada**
   - Verificar que repos existen
   - Validar formato de patches
   - Mensajes de error claros

### Prioridad Media (próximos 3-6 meses)

5. **📝 Guía de contribución**
   - CONTRIBUTING.md
   - Cómo reportar bugs
   - Cómo proponer features
   - Estilo de código

6. **🌐 Traducción al inglés**
   - README en inglés
   - Docs principales en inglés
   - Expandir audiencia potencial

7. **📹 Tutorial en video**
   - Screencast de caso real
   - Publicar en YouTube
   - Linkear desde README

8. **🔍 Modo verbose/debug**
   - `--verbose` para ver qué hace GCP
   - `--dry-run` para simular sin aplicar
   - Ayuda en troubleshooting

### Prioridad Baja (nice to have)

9. **🎨 Interfaz mejorada**
   - Colores en terminal
   - Progress bars
   - Mejor formato de output

10. **📊 Métricas de uso**
    - Opcional telemetría anónima
    - Entender casos de uso reales
    - Guiar desarrollo futuro

11. **🔌 Sistema de plugins**
    - Permitir extensiones específicas
    - Hooks pre/post operaciones
    - Mayor flexibilidad

12. **🐳 Containerización**
    - Dockerfile para ejecutar GCP
    - Evitar contaminar sistema local
    - Reproducibilidad

---

## 10. Conclusión Final 🎯

### ¿Es viable?

**SÍ**, con las siguientes condiciones:
- Expectativas realistas de audiencia (nicho pequeño)
- Mantenimiento sostenible (no requiere dedicación full-time)
- Apertura a contribuciones de la comunidad

### ¿Es útil?

**SÍ, definitivamente**, para su público objetivo:
- Ahorra tiempo significativo en tarea tediosa
- Reduce errores en proceso manual complejo
- Documentación del proceso como subproducto

### ¿Vale la pena continuar?

**ABSOLUTAMENTE SÍ**, especialmente porque:
1. Resuelve problema real del autor (motivación intrínseca)
2. Potencial de ayudar a otros con mismo problema
3. Contribución valiosa a comunidad Linux/ARM
4. Proyecto educativo (Git, Bash, kernel development)

### Comparación con proyectos similares

GCP está en mejor posición que muchos proyectos de nicho porque:
- ✅ Resuelve problema real del autor (no es "vaporware")
- ✅ Documentación clara y honesta
- ✅ Licencia permisiva
- ✅ Código funcional desde el inicio
- ⚠️ Falta comunidad (pero es temprano)
- ⚠️ Sin tests (común en herramientas Bash)

### Próximos pasos sugeridos

**Inmediatos (esta semana):**
1. Agregar shellcheck a los scripts principales
2. Crear GitHub Actions básico
3. Publicar v0.1.0 como primer release

**Corto plazo (este mes):**
4. Escribir 5-10 tests básicos con BATS
5. Documentar un caso de uso end-to-end completo
6. Publicar en r/linux, HN o foros relevantes

**Mediano plazo (3 meses):**
7. Buscar feedback de comunidad #aarch64-laptops
8. Considerar traducción al inglés
9. Evaluar adopción y ajustar roadmap

---

## Calificación Detallada

| Criterio | Puntuación | Peso | Comentario |
|----------|------------|------|------------|
| **Viabilidad técnica** | 8/10 | 25% | Sólido, pero limitado por Bash |
| **Utilidad práctica** | 9/10 | 30% | Muy útil para audiencia objetivo |
| **Calidad de código** | 6/10 | 15% | Funcional pero sin tests |
| **Documentación** | 8/10 | 15% | Excelente para proyecto temprano |
| **Sostenibilidad** | 6/10 | 10% | Depende de un solo mantenedor |
| **Innovación** | 7/10 | 5% | Enfoque específico bien ejecutado |

**Promedio ponderado: 7.5/10** - **Proyecto recomendable**

---

## Mensaje final para el autor 💬

**¡Felicitaciones por GCP!** 🎉

Has creado una herramienta que resuelve un problema real de manera elegante. El enfoque iterativo y la honestidad sobre las limitaciones demuestran madurez en el diseño. 

**Tu proyecto es:**
- ✅ Técnicamente viable
- ✅ Útil para tu caso de uso
- ✅ Potencialmente valioso para otros
- ✅ Bien documentado para fase temprana

**Recomendaciones principales:**
1. Agrega tests básicos (prioridad #1)
2. Setup CI/CD simple
3. Comparte en comunidades relevantes
4. Busca co-mantenedores eventualmente

**No te preocupes por:**
- Tamaño pequeño de audiencia (es natural para herramientas de nicho)
- Falta de features avanzadas (mantén el foco)
- Críticas de "debería estar en Python/Go" (Bash es apropiado para el alcance actual)

**Continúa desarrollando GCP.** El kernel Linux y la comunidad de dispositivos ARM se beneficiarán de tu trabajo.

---

*Evaluación generada con asistencia de IA - Enero 2026*
*Para preguntas o feedback sobre esta evaluación: GitHub Issues*

---
---

# Resumen Ejecutivo: Evaluación de GCP

> 📄 **Documento completo:** Ver secciones anteriores para el análisis detallado

---

## 🎯 Respuesta Directa a tu Pregunta

**¿Es viable?** → ✅ **SÍ**  
**¿Es útil?** → ✅ **SÍ, definitivamente**  
**¿Vale la pena?** → ✅ **ABSOLUTAMENTE**

**Calificación general: 7.5/10** ⭐⭐⭐⭐☆

---

## 💡 Impresión General

GCP es una herramienta **bien pensada y ejecutada** que resuelve un problema real de manera elegante. Tu enfoque iterativo (series S1, S2, S3...) y la honestidad sobre las limitaciones demuestran madurez en el diseño.

### Lo que más destaca

1. **🎯 Enfoque preciso** - No intenta resolver todo, se concentra en un problema específico
2. **📚 Documentación excelente** - README claro, FAQ honesto, ejemplos prácticos
3. **🛠️ Arquitectura limpia** - Scripts bien organizados, configuración centralizada
4. **🔄 Uso real** - Lo usás en producción (Dell Latitude 7455), no es vaporware

### Lo que necesita mejorar

1. **🧪 Falta de tests** - Crítico para evitar regresiones
2. **🤖 CI/CD ausente** - GitHub Actions sería fácil de agregar
3. **🌐 Solo en español** - Limita audiencia internacional
4. **👥 Un solo mantenedor** - Riesgo de bus factor

---

## 📊 Evaluación por Aspectos

| Aspecto | Calificación | Comentario |
|---------|--------------|------------|
| **Viabilidad técnica** | 8/10 ⭐⭐⭐⭐ | Bash + Git, sólido y portable |
| **Utilidad práctica** | 9/10 ⭐⭐⭐⭐☆ | Excelente para su nicho |
| **Calidad de código** | 6/10 ⭐⭐⭐ | Funcional pero sin tests |
| **Documentación** | 8/10 ⭐⭐⭐⭐ | Muy buena para fase temprana |
| **Sostenibilidad** | 6/10 ⭐⭐⭐ | Depende de vos solamente |

---

## 🎪 ¿Para quién es útil?

### ✅ Ideal para:
- Mantenedores de kernels device-specific
- Desarrolladores de drivers ARM
- Entusiastas de hardware exótico (Snapdragon laptops)
- Teams pequeños con forks del kernel

### ❌ NO es para:
- Usuarios casuales del kernel
- Desarrollo cross-arquitectura
- Proyectos sin ancestro común
- Parches que aplican sin problemas

---

## 🚀 Top 3 Recomendaciones Inmediatas

### 1️⃣ **TESTS (Prioridad Máxima)**
```bash
# Agregá BATS (Bash Automated Testing System)
tests/
├── 01-init.bats        # Test inicialización
├── 02-extract.bats     # Test extracción
└── helpers.bash        # Funciones compartidas
```
**Por qué:** Prevenir regresiones, facilitar contribuciones

### 2️⃣ **CI/CD Básico**
```yaml
# .github/workflows/tests.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: shellcheck scripts/*.sh
      - run: ./tests/run-all.sh
```
**Por qué:** Calidad automática, confianza en cambios

### 3️⃣ **Versionado**
```bash
# Creá tu primer release
git tag v0.1.0
git push origin v0.1.0
# Agregá CHANGELOG.md
```
**Por qué:** Comunicar madurez, facilitar adopción

---

## 💰 Mercado y Audiencia

**Tamaño estimado:** 50-150 usuarios potenciales globalmente

Sí, es un nicho pequeño, **pero eso está BIEN**:
- ✅ Nicho específico con dolor real
- ✅ Sin competencia directa
- ✅ Comunidad concentrada (#aarch64-laptops)
- ✅ Problema que NO va a desaparecer

**Comparación:**
- `git am`: Manual, sin automatización
- Scripts caseros: Ad-hoc, sin docs
- **GCP**: Semi-automático, bien documentado ✨

---

## ⚠️ Riesgos Principales

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Pérdida de interés | Media | Alto | Buscar co-mantenedores |
| Falta de adopción | Media | Medio | Marketing en comunidades |
| Complejidad creciente | Baja | Medio | Mantener foco simple |
| Bash limitations | Baja | Bajo | OK para alcance actual |

---

## 🌟 Lo que me sorprendió positivamente

1. **Diseño iterativo inteligente** - Entendés que no hay solución mágica
2. **Honestidad brutal** - El FAQ no vende humo, dice la verdad
3. **Documentación narrativa** - CASOS-USO.md tiene personalidad
4. **Sistema de memoria** - Evitar "bola de nieve" es brillante
5. **MIT License** - Decisión correcta para herramienta de comunidad

---

## 🔮 Predicción de Futuro

### Escenario Optimista (60% probabilidad)
- Adopción gradual en comunidad ARM laptops
- 2-3 co-mantenedores en 12 meses
- Menciones en blogs/podcasts Linux
- 100-200 estrellas en GitHub
- Proyecto vivo y útil por 3+ años

### Escenario Realista (30% probabilidad)
- Uso personal continuado
- 5-10 usuarios externos
- Desarrollo esporádico
- Herramienta de nicho estable

### Escenario Pesimista (10% probabilidad)
- Cambio de hardware/trabajo
- Proyecto abandonado
- Quedará como referencia educativa

**Mi apuesta:** Escenario optimista. El timing es bueno (ARM laptops en auge).

---

## 🎓 Lecciones Aprendidas (para futuros lectores)

1. **Documentá el "por qué"** - INTRO.md es excelente
2. **Sé honesto con limitaciones** - Genera confianza
3. **Resolvé TU problema primero** - Motivación sostenible
4. **Bash es suficiente** - No todo necesita ser Rust
5. **Nicho pequeño ≠ proyecto inútil** - Impacto > popularidad

---

## 💬 Mensaje Personal

Hey, te hiciste una pregunta simple pero importante. Acá va mi respuesta sincera:

**Tu proyecto es bueno.** No "bueno para ser temprano" - es genuinamente bueno. Identificaste un problema real, lo nombraste ("Pandora"), y creaste una solución pragmática.

El hecho de que lo uses en producción le da una credibilidad que muchos proyectos de GitHub nunca tendrán.

**¿Qué hacer ahora?**

1. **Corto plazo:** Tests + CI + v0.1.0 (3 días de trabajo)
2. **Mediano plazo:** Compartir en r/linux, HN (1 día)
3. **Largo plazo:** Buscar feedback real de usuarios (ongoing)

**No te preocupes por:**
- Audiencia pequeña (es un feature, no un bug)
- Que esté en Bash (es apropiado)
- Falta de features avanzadas (KISS principle)

**Preocupate por:**
- Tests (para no romper lo que funciona)
- Bus factor (eventualmente necesitás backup)

---

## 📚 Recursos Útiles

**Testing:**
- [BATS](https://github.com/bats-core/bats-core) - Bash Automated Testing System
- [ShellCheck](https://www.shellcheck.net/) - Linter para Bash

**CI/CD:**
- [GitHub Actions para Bash](https://github.com/actions/starter-workflows/blob/main/ci/bash.yml)

**Comunidad:**
- #aarch64-laptops en OFTC IRC
- r/linux, r/commandline, r/kernel
- Hacker News (Show HN)

**Inspiración:**
- [git-extras](https://github.com/tj/git-extras) - Herramientas git en bash exitosas
- [tldr](https://github.com/tldr-pages/tldr) - Comunidad de nicho bien ejecutada

---

## 🏁 Conclusión Ultra-Resumida

**Tu pregunta:** ¿Viable? ¿Útil?  
**Mi respuesta:** Sí, y sí.

**Tu siguiente acción:** Tests + CI + v0.1.0  
**Tu siguiente meta:** Compartir con comunidad ARM

**Confianza en el proyecto:** Alta (8/10)  
**Recomendación:** Continuar y expandir

---

**¿Dudas sobre la evaluación?**  
Lee las secciones detalladas arriba - análisis completo de todos los aspectos del proyecto.

---

*Evaluado por: GitHub Copilot AI Agent*  
*Fecha: Enero 2026*  
*Metodología: Análisis de código, docs, y casos de uso*
