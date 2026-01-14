#!/bin/bash
# 05diagnostica_fallas.sh
# Analiza patches que fallaron al aplicar
# Uso: ./05diagnostica_fallas.sh

source "$(dirname "$0")/gcp.conf"

script_header "DIAGNOSTICAR FALLAS"

echo "Analizando patches fallidos en: $PATCHES_PENDING"
echo ""

# Verificar si hay patches pendientes
if [ ! -d "$PATCHES_PENDING" ] || [ -z "$(ls -A "$PATCHES_PENDING"/*.patch 2>/dev/null)" ]; then
    echo "No hay patches fallidos para analizar."
    echo ""
    echo "Los patches en pending/ son aquellos que fallaron al aplicar."
    echo "Si acabas de empezar, primero aplica un parche Pandora:"
    echo "  git am $PATCHES_PANDORA/pandora.patch"
    exit 0
fi

# Contadores por tipo de error
error_archivos=0
error_contexto=0
error_otro=0
total=0

echo "Patches a analizar:"
echo "-------------------"

# Analizar cada patch fallido
for patch_file in "$PATCHES_PENDING"/*.patch; do
    [ -f "$patch_file" ] || continue
    
    patch_name=$(basename "$patch_file")
    total=$((total + 1))
    
    echo ""
    echo "$patch_name:"
    echo "  Probando aplicación..."
    
    # Intentar aplicar con --reject para diagnóstico
    temp_output=$(mktemp)
    (cd "$REPO_DESTINO" && git apply --reject --whitespace=fix "$patch_file" 2>&1) > "$temp_output"
    
    # Clasificar error
    if grep -q "No such file or directory" "$temp_output"; then
        echo "  ERROR: Archivos faltantes"
        error_archivos=$((error_archivos + 1))
        
        # Extraer nombres de archivos faltantes
        archivos_faltantes=$(grep -o "error: .*: No such file or directory" "$temp_output" | \
                           sed 's/error: //' | sed 's/: No such file or directory//')
        for archivo in $archivos_faltantes; do
            echo "    - $archivo"
        done
        
    elif grep -q "patch does not apply" "$temp_output" || \
         grep -q "hunk failed" "$temp_output"; then
        echo "  ERROR: Cambios de contexto"
        error_contexto=$((error_contexto + 1))
        
        # Contar hunks fallidos
        hunks_fallidos=$(grep -c "hunk failed" "$temp_output")
        echo "    Hunks fallidos: $hunks_fallidos"
        
    else
        echo "  ERROR: Otro tipo"
        error_otro=$((error_otro + 1))
        
        # Mostrar primeras líneas del error
        echo "    $(head -1 "$temp_output")"
    fi
    
    # Limpiar archivos .rej generados
    (cd "$REPO_DESTINO" && rm -f *.rej 2>/dev/null)
    rm -f "$temp_output"
done

echo ""
echo "RESUMEN DE DIAGNÓSTICO:"
echo "  Total patches analizados: $total"
echo "  Archivos faltantes: $error_archivos"
echo "  Cambios de contexto: $error_contexto"
echo "  Otros errores: $error_otro"
echo ""

# Recomendaciones basadas en diagnóstico
if [ "$error_archivos" -gt 0 ]; then
    echo "RECOMENDACIÓN para archivos faltantes:"
    echo "  Ejecuta: ./01crea_lista_archivos.sh"
    echo "  Luego: ./02extraer_parches.sh"
    echo ""
fi

if [ "$error_contexto" -gt 0 ]; then
    echo "RECOMENDACIÓN para cambios de contexto:"
    echo "  Estos patches necesitan ajuste manual."
    echo "  Revisa los archivos .rej generados (si los hay)."
    echo "  Puedes usar 'git apply --reject' y ajustar manualmente."
    echo ""
fi

if [ "$total" -eq 0 ]; then
    echo "No se encontraron patches para diagnosticar."
fi

echo ""
