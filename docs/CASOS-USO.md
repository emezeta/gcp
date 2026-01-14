# Casos de Uso: Ejemplos Concretos

Acá te mostramos cómo GCP se pone los guantes en situaciones reales (o casi).

## Escenario 1: El Parche Solitario

**Situación:** Encontraste un parche que activa una optimización genial para tu SSD, pero viene de un kernel más nuevo.

```bash
# Tenés estos tres elementos:
ORIGEN=~/fuentes/linux-nuevo
DESTINO=~/fuentes/linux-mio
PATCH=~/descargas/mejora-ssd.patch
```

# El clásico "git am" falla:
cd $DESTINO
git am $PATCH
# ERROR: archivo 'drivers/block/nvme.c' no existe

# Ahí entra GCP:
gcp --origen $ORIGEN --destino $DESTINO --patch $PATCH

# GCP va a:
# 1. Analizar el error del archivo faltante
# 2. Buscar en $ORIGEN commits que hayan creado/modificado ese archivo
# 3. Generar una SERIE 1 con esos commits relacionados
# 4. Probar aplicar la serie completa

Lo que puede pasar después: GCP te muestra que pescó 3 commits relacionados con la creación de nvme.c y cambios en headers. Vos revisás, quizás alguno no aplica porque toca código que ya tenés diferente. Elegís seguir con 2 de los 3, y probás otra ronda.


## Escenario 2: La Dependencia de Config

Situación: Un parche que depende de una opción de configuración que en tu kernel no está activada.
bash

# Error típico:
# error: 'CONFIG_FANTASMICO' undeclared here (not in a function)

# GCP puede ayudar a rastrear:
# 1. En qué commit se introdujo CONFIG_FANTASMICO
# 2. Qué otros parches dependen de él
# 3. Si hay una secuencia lógica de aplicación

# Usá el mensaje de error como pista:
gcp --origen $ORIGEN --destino $DESTINO --patch $PATCH --clave "CONFIG_FANTASMICO"

# GCP buscará en el historial del origen menciones a ese CONFIG_


## Escenario 3: El Refactor que Rompe Todo

Situación: El parche modifica funciones que en tu kernel tienen otro nombre o están en otro archivo por un refactor que se hizo después de que se bifurcaran los árboles.
bash

# GCP, con su modo "rastreador":
gcp --origen $ORIGEN --destino $DESTINO --patch $PATCH --modo rastreo-profundo

# En este modo, GCP no solo busca el código exacto sino también:
# - Funciones renombradas (usando git log --follow)
# - Código movido entre archivos
# - Cambios en firmas de funciones


## Flujo de Trabajo Recomendado

    Primero, lo obvio: Intentá aplicar el parche con git am o git apply y guardá los errores.

    Iniciá GCP con las rutas básicas, sin miedo.

    Revisá lo que pescó: La SERIE 1 es tu nuevo punto de partida. Leé los mensajes de commit.

    Tomá decisiones: No todos los commits pescados son necesarios. A veces conviene probar de a uno.

    Iterá: Usá la memoria de GCP para no dar vueltas en círculo. Si en la ronda 3 seguís igual que en la 1, replanteate si el trasplante es viable.

    Cuando aplique: ¡Celebrá! Y considerá mandar un comentario sobre cómo fue el proceso.

Recordá: GCP es como un amigo que te ayuda a buscar las piezas del rompecabezas, pero vos tenés que decidir cómo armarlo.

