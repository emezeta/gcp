#!/bin/bash
# 04aplica_patchs.sh
# Aplica patches desde candidates/ al repositorio destino
# Uso: ./04aplica_pstchs.sh [serie]

source "$(dirname "$0")/gcp.conf"

script_header "APLICAR PATCHES"

# Determinar serie a usar
if [ -n "$1" ]; then
    serie="$1"
else
    serie=$(cat "$SERIES_COUNTER_FILE" 2>/dev/null || echo "1")
fi

echo "Aplicando patches de la serie S$serie..."
echo ""

# Verificar repositorio destino
if [ ! -d "$REPO_DESTINO/.git" ]; then
    echo "Error: No es un repositorio git válido: $REPO_DESTINO"
    exit 1
fi

# Asegurar que estamos en la rama correcta
(cd "$REPO_DESTINO" && git checkout "$BRANCH_DESTINO" 2>/dev/null || true)

# Contadores
aplicados=0
fallados=0
total=0

# Buscar patches de esta serie en candidates/ (estructura plana)
for patch_file in "$PATCHES_CANDIDATES/S${serie}_"*.patch; do
    [ -f "$patch_file" ] || continue
    
    patch_name=$(basename "$patch_file")
    total=$((total + 1))
    
    echo "Procesando ($total): $patch_name"
    
    # Extraer hash del patch para registro
    hash=$(extract_hash_from_patch "$patch_file")
    
    # Intentar aplicar
    if (cd "$REPO_DESTINO" && git am --whitespace=fix "$patch_file" 2>&1); then
        # Éxito: mover a applied
        mv "$patch_file" "$PATCHES_APPLIED/"
        echo "  OK: Aplicado correctamente"
        aplicados=$((aplicados + 1))
        
        # Registrar hash si es posible
        if [ -n "$hash" ]; then
            register_hash "$hash"
        fi
    else
        # Falla: mover a pending
        mv "$patch_file" "$PATCHES_PENDING/"
        echo "  FALLO: Movido a pending/"
        fallados=$((fallados + 1))
        
        # Generar log de error
        (cd "$REPO_DESTINO" && git am --abort 2>/dev/null)
        echo "--- Error aplicando $patch_name ---" >> "$PATCHES_LOGS/errores_aplicacion.log"
        (cd "$REPO_DESTINO" && git apply --reject --whitespace=fix "$PATCHES_PENDING/$patch_name" 2>&1) >> "$PATCHES_LOGS/errores_aplicacion.log"
        echo "" >> "$PATCHES_LOGS/errores_aplicacion.log"
    fi
done

echo ""
echo "RESULTADO:"
echo "  Total procesados: $total"
echo "  Aplicados: $aplicados"
echo "  Fallados: $fallados"
echo ""

if [ "$total" -eq 0 ]; then
    echo "No se encontraron patches para la serie S$serie en candidates/"
    echo ""
    echo "Puede que:"
    echo "  1. No hayas extraído patches con 02extraer_parches.sh"
    echo "  2. Los patches estén en otra serie (actual: S$serie)"
    echo "  3. Necesites crear una nueva serie con 00init.sh"
fi

if [ "$fallados" -gt 0 ]; then
    echo "Patches fallados disponibles para diagnóstico en: $PATCHES_PENDING/"
    echo "Puedes analizarlos con: ./05diagnostica_fallas.sh"
    echo ""
    echo "Para continuar:"
    echo "  1. Analiza fallos: ./05diagnostica_fallas.sh"
    echo "  2. Crea nueva lista: ./01crea_lista_archivos.sh $PATCHES_LOGS/errores_aplicacion.log"
    echo "  3. Extrae nuevos patches: ./02extraer_parches.sh $((serie + 1))"
    echo "  4. Aplica nueva serie: ./04aplica_commits.sh $((serie + 1))"
fi

echo ""
