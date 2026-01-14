# GCP: Git Commit Patch

GCP es una herramienta de ayuda en el injerto de uno o varios parches «alienígenas» en una rama local de kernel de Linux basada en Git y Bash.

## La necesidad

Más allá de lo elemental, la "justificación" de GCP es mi falta de conocimientos y práctica en Git.
En un repositorio 'x' de un kernel Linux, encuentro una característica interesante o simplemente necesaria para el sistema de computadora, que quisiera probar o instalar a un repositorio personal. Estos repositorios será *origen* y *destino* que junto al *patch 0* serán los tres elementos que se necesitan para usar GCP. El patch 0, implementa la funcionalidad que nos interesa.

Es muy probable que en alguno o varios 'estados' de su trayectoria, ambos árboles Linux, hayan sido el mismo, o por lo menos muy cercanos.

La inocente intuición de novato es "extraigo el patch y lo aplico en mi kernel". **Ja. Ja. Ja.** Esto suele ser el comienzo de una pequeña odisea para capturar dependencias, configuraciones perdidas en el tree del repositorio de origen, etc. En general, estos procesos se convierten en una larga contienda con git como amigo... o enemigo! Especialmente si sos un novato.

GCP está pensado para ayudar en la aplicación de *un* patch alienígena sobre *un* repositorio destino tomando de *un* repositorio de origen.

## Base común

Una de las limitaciones de este GCP es que los repositorios, origen y destino de los commits/parches que se quiere «trasplantar» deberán tener un repositorio ancestro común. Cuanto más cercanos estén los repositorios entre sí en el tiempo, mejor funcionará GCP y mayores serán las posibilidades de éxito en los casos de uso.

Otra: ésto no está pensado para admitir cruces entre arquitecturas.

## La idea

La probabilidad de que la aplicación de un patch extraño aplique de una, es baja.
Primero lo primero, asegurarse de que el kernel de origen compila. Si lo hace, entonces tenemos la 'serie 0', que por lo general es un solo patch y no una serie en sí. Pero podrían ser dos, o más... En cualquier caso la 'serie 0' es el comienzo.

En este momento GCP funciona aceptablemente para una 'serie 0' de un patch. También nos gustó ponerle nombre a este patch: **"Pandora"**.

De entrada seguramente encuentres dependencias incumplidas, falta de funciones o simplemente código, configuraciones diferentes... Otra vez, si esto compila en el repo de origen, entonces allí está la solución. **Es la boca del agujero negro...** Es en este punto que entra GCP a jugar.

## GCP en acción

El primer intento habrá sido `git apply` ó `git am`. Analizando los logs del intento, seguramente se encuentren cosas como un archivo que no existe, una invocación al vacío, la ausencia de una constante, variable, estructura...

Entonces:
- GCP espera alguna de esas 'claves' como entrada para hacer búsquedas en el repo/rama de origen extrayendo de allí uno o varios commits/patchs vinculados a esas claves.
- Además de sus propios logs, GCP también creará una memoria de los patchs generados, enlazados al commit hash de origen. A medida que éste proceso avance, esta memoria/base de datos, tendrá importancia creciente.
- Pero ahora nos toca analizar qué es lo que pescó GCP en la primera ronda, la **serie 1**.
- Un análisis de los commits messages en estos patches, puede darnos una idea de prioridades de aplicación de uno o más candidatos. Aunque esto puede resultar insuficiente o ambiguo, es muy probable que un primer análisis nos oriente.

---

*Nota: Este desarrollo se llevó a cabo con asistencia de IA (DeepSeek y otras). Los fragmentos interesantes de los chats relacionados están disponibles como parte del Informe GCP.*

