# Informe GCP: Notas de Evolución

Este documento registra el viaje, desde la idea hasta la herramienta, con sus vueltas, ayudas y reflexiones.

## Génesis: La Frustración como Motor

Todo comenzó con un parche para el driver de la WiFi que no aplicaba. El error era críptico, el repositorio origen tenía 6 meses más de desarrollo, y yo tenía dos opciones: abandonar o meterme en una madriguera de conejo. Elegí la madriguera.

Después de horas de `git log -S`, `git blame` y café frío, me di cuenta que estaba haciendo un trabajo **mecánico pero no trivial**: rastrear dependencias a través del historial. "Esto debería poder automatizarse", pensé. Y así nació la justificación de GCP.

## Diseño: Principios no Negociables

Desde el día 0, GCP tuvo que cumplir con:
1. **Ser una herramienta Bash**: Para correr en cualquier lado sin dependencias exóticas.
2. **No ser invasiva**: No modificar repositorios permanentemente sin confirmación explícita.
3. **Ser transparente**: Mostrar todo lo que hace, cada búsqueda, cada resultado.
4. **Preservar el contexto**: Mantener links a los commits originales para trazabilidad.

El nombre "Git Commit Patch" es deliberadamente redundante, como para que quede claro qué ámbito cubre.

## Asistencia Clave: El Rol de la IA

**Aclaración importante:** GCP fue concebido y dirigido por un humano (yo), pero varias partes complejas fueron **discutidas, exploradas y refinadas con asistencia de IA**, específicamente DeepSeek y otras.

### ¿Qué ayudó la IA?
- **Estructura de lógica de búsqueda:** Cómo transformar un error de compilación en una query para `git log`.
- **Manejo de casos bordes:** Qué hacer cuando un archivo fue renombrado múltiples veces.
- **Optimización:** Cómo buscar eficientemente sin saturar la memoria.
- **Documentación:** Organización de este mismo informe y los textos explicativos.

### Fragmento de un diálogo ilustrativo:
> **Yo:** "Necesito que GCP, cuando falle por un archivo faltante, busque no solo ese archivo sino también includes relacionados."
> **Asistente:** "Podés usar `git log --follow` para rastrear renombres, y `git grep` en commits antiguos para encontrar dónde se movieron las definiciones. Pero cuidado con el rendimiento..."
> **Yo:** "Entiendo. Hagamos primero la búsqueda simple y si no encuentra, que pregunte si hacer búsqueda profunda."

Estos intercambios fueron cruciales para convertir una idea vaga en un flujo de trabajo concreto.

## Hitos de Desarrollo

### Versión 0.1 (Primera Luz)
- Búsqueda básica por mensajes de error.
- Aplicación automática de commits encontrados.
- Logs en texto plano.

**Lección:** Sin memoria entre rondas, GCP podía entrar en bucles infinitos. Descubrimiento doloroso.

### Versión 0.5 (Memoria y Criterio)
- Sistema de memoria con hashes.
- Posibilidad de elegir qué commits de la SERIE 1 probar.
- Mejores mensajes de progreso.

**Lección:** Los usuarios (yo) necesitamos sentir control, no automatización ciega.

### Versión Actual (Estable pero Joven)
- Manejo de múltiples tipos de errores.
- Nombre del patch "Pandora" como homenaje a "abrir la caja".
- Integración con workflow normal de Git.

## Filosofía: Por Qué GCP es Así

GCP encarna algunas creencias:
1. **Las herramientas deben extender la capacidad, no reemplazar el criterio.** Por eso GCP sugiere, no decide.
2. **La transparencia crea confianza.** Cada acción de GCP es explicable.
3. **Lo "suficientemente bueno" es mejor que lo "perfecto pero inacabado".** GCP podría ser más inteligente, pero primero necesita existir y ser útil.

## Futuro Posible (Si el interés existe)

Caminos que podríamos explorar:
- **Interfaz interactiva:** Tipo menú para seleccionar commits.
- **Detección de refactors automáticos:** Usando análisis de similitud de código.
- **Integración con `git bisect`:** Para encontrar el commit exacto donde se rompe la compatibilidad.
- **Comunidad:** Si otros se suman, adaptar GCP a otros proyectos además del kernel.

## Agradecimientos Finales

A la comunidad del kernel, por documentar aunque a veces sea críptico.
A los desarrolladores de Git, por hacer una herramienta tan poderosa.
A las IA asistentes, por ser pacientes interlocutoras técnicas.
Y a cualquiera que lea esto, por considerar que este problema merecía una herramienta propia.

---

*Este informe es vivo. Se actualizará con nuevas lecciones, fracasos y (ojalá) éxitos.*