#!/bin/bash
# 01crea_lista_archivos.sh
# Crea lista de archivos conflictivos basada en errores de aplicación
# Uso: ./01crea_lista_archivos.sh [archivo_log]

source "$(dirname "$0")/gcp.conf"

script_header "CREAR LISTA DE ARCHIVOS CONFLICTIVOS"

# Determinar archivo de log a usar
if [ -n "$1" ]; then
    log_file="$1"
else
    log_file="$PATCHES_LOGS/$DEFAULT_LOG_FILE"
fi

if [ ! -f "$log_file" ]; then
    echo "Error: No se encuentra el archivo de log: $log_file"
    echo ""
    echo "Primero debes intentar aplicar un parche para generar errores."
    echo "Coloca el parche Pandora en $PATCHES_PANDORA/ y ejecuta:"
    echo "  git am $PATCHES_PANDORA/pandora.patch 2>&1 | tee $log_file"
    exit 1
fi

echo "Analizando log: $log_file"
echo ""

# Archivo de salida
output_file="$PATCHES_TMP/$DEFAULT_FILE_LIST"

# Patrones para buscar archivos faltantes
echo "Buscando archivos faltantes en el log..."
echo ""

# Limpiar archivo de salida si existe
> "$output_file"

# Buscar errores de "No such file or directory"
grep -o "error: .*: No such file or directory" "$log_file" | \
    sed 's/error: //' | sed 's/: No such file or directory//' | \
    sort -u > "$output_file"

# Contar resultados
count=$(wc -l < "$output_file" | tr -d ' ')

if [ "$count" -gt 0 ]; then
    echo "Encontrados $count archivos conflictivos:"
    echo "----------------------------------------"
    cat "$output_file"
    echo ""
    echo "Lista guardada en: $output_file"
else
    echo "No se encontraron errores de archivos faltantes."
    echo ""
    echo "Tip: Puede que los errores sean de otro tipo (contexto, funciones, etc.)"
    echo "Revisa el log manualmente o usa 05diagnostica_fallas.sh"
fi

echo ""
