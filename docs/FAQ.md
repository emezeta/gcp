

## 🤔 ¿GCP es una herramienta automágica que aplica cualquier parche?

**Ojalá!** GCP es una **herramienta de asistencia**. Te ayuda a encontrar commits relacionados en el repositorio de origen cuando un parche no aplica. Pero no resuelve conflictos complejos, no entiende la semántica del código y no puede adivinar la intención del programador original. **Vos seguís siendo el piloto.**

## 🔍 ¿Qué necesito sí o sí para usar GCP?

Tres ingredientes básicos:
1. **Repositorio Origen:** El kernel de donde salió el parche, con su historial completo.
2. **Repositorio Destino:** Tu kernel, donde querés aplicar el parche.
3. **Patch 0:** El parche "alienígena" que querés injertar.

**Condición crítica:** Ambos repositorios deben tener un **ancestro común en el historial de Git**. Si son proyectos totalmente distintos, GCP no puede ayudar.

## ⏳ ¿Qué tan cercanos deben ser los repositorios?

La regla es simple: **cuanto más, mejor**. Si los árboles se bifurcaron hace 2 versiones, hay buena chance. Si se bifurcaron hace 10 años... preparate para una odisea. GCP funciona buscando en el historial, y a mayor distancia temporal, más cambios estructurales puede haber.

## 🏗️ ¿Sirve para parches entre arquitecturas diferentes?

**No.** Si el parche es para ARM y tu kernel es x86_64, GCP no es la herramienta adecuada. Asume que la arquitectura objetivo es la misma. Esto es por cómo funciona el código del kernel y las configuraciones específicas de cada arch.

## 💾 ¿La "memoria" de GCP se guarda para otra vez?

Por ahora, GCP crea archivos de log y memoria en el directorio donde se ejecuta, con nombres que incluyen timestamps y hashes. **No los borres** si querés retomar un proceso más tarde. En futuras versiones podríamos implementar una base de datos más persistente.

## ❌ ¿Qué tipos de errores maneja mejor GCP?

Los **errores por "falta de"** son su especialidad:
- `archivo.c: No such file or directory`
- `error: 'CONFIG_ALGO' undeclared`
- `function 'funcion_rara' not defined`
- `unknown type name 'estructura_oculta'`

Los **errores por conflicto de merging** (esos `<<<<<<< HEAD` que dan terror) tenés que resolverlos a mano, como con cualquier merge conflict.

## 🐌 ¿Por qué GCP es tan lento a veces?

Porque está haciendo búsquedas en el historial completo del repositorio origen, que para el kernel de Linux puede ser enorme. Además, cada ronda implica operaciones de Git (aplicar parches, revertir, buscar commits). **Paciencia, que está haciendo trabajo de detective.**

## 🆘 ¿GCP me garantiza que el parche va a aplicar?

**De ninguna manera.** Lo que garantiza es que te va a ayudar a explorar el espacio del problema de manera más sistemática. Podés terminar con:
- El parche aplicado perfectamente (¡éxito!)
- Una serie de parches que aplican pero el kernel no compila
- La conclusión de que el trasplante es inviable sin cambios mayores
- Un nuevo conocimiento íntimo de esa parte del kernel

## 🤝 ¿Cómo contribuyo o reporto un problema?

El proyecto está en GitLab. Podés:
1. Abrir un issue con el error que encontraste.
2. Proponer mejoras al código Bash (es simple, pero tiene sus mañas).
3. Compartir tu experiencia, aunque haya sido frustrante. Todas las anécdotas ayudan.

---

*¿Tenés otra pregunta que no está acá? Probablemente ya sea un caso de uso interesante para documentar. ¡Contala!*
