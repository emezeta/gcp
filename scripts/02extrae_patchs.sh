#!/bin/bash
# 02extrae_parches.sh
# Busca commits relacionados con archivos conflictivos y extrae patches
# Uso: ./02extrae_parches.sh [serie]

source "$(dirname "$0")/gcp.conf"

script_header "EXTRAER PATCHES RELACIONADOS"

# Determinar serie a usar
if [ -n "$1" ]; then
    serie="$1"
else
    serie=$(cat "$SERIES_COUNTER_FILE" 2>/dev/null || echo "1")
fi

echo "Usando serie: S$serie"
echo ""

# Verificar lista de archivos
archivos_lista="$PATCHES_TMP/$DEFAULT_FILE_LIST"

if [ ! -f "$archivos_lista" ]; then
    echo "Error: No se encuentra la lista de archivos: $archivos_lista"
    echo ""
    echo "Primero ejecuta: ./01crea_lista_archivos.sh"
    exit 1
fi

# Archivo para lista de commits encontrados
commits_list="$PATCHES_TMP/$DEFAULT_COMMITS_LIST"

echo "Buscando commits relacionados con archivos conflictivos..."
echo "Archivos a buscar: $(wc -l < "$archivos_lista")"
echo ""

# Limpiar lista de commits anterior
> "$commits_list"

# Contadores
total_commits=0
archivos_procesados=0

# Para cada archivo en la lista, buscar commits relacionados
while IFS= read -r archivo; do
    [ -z "$archivo" ] && continue
    
    echo "Buscando commits para: $archivo"
    
    # Buscar commits que modificaron este archivo
    if (cd "$REPO_ORIGEN" && \
        git log --oneline --since="$DEFAULT_SINCE_DATE" -- "$archivo" 2>/dev/null); then
        
        # Extraer hashes y sujetos
        (cd "$REPO_ORIGEN" && \
         git log --oneline --since="$DEFAULT_SINCE_DATE" --format="%H%x09%s" -- "$archivo" 2>/dev/null) \
         >> "$commits_list"
        
        encontrados=$(cd "$REPO_ORIGEN" && \
                     git log --oneline --since="$DEFAULT_SINCE_DATE" -- "$archivo" 2>/dev/null | wc -l)
        
        echo "  Encontrados: $encontrados commits"
        archivos_procesados=$((archivos_procesados + 1))
    else
        echo "  No se encontraron commits o error en búsqueda"
    fi
    
done < "$archivos_lista"

# Eliminar duplicados (mismo commit para múltiples archivos)
sort -u "$commits_list" > "${commits_list}.tmp"
mv "${commits_list}.tmp" "$commits_list"

total_commits=$(wc -l < "$commits_list" | tr -d ' ')

echo ""
echo "Total commits encontrados: $total_commits"
echo "Commits guardados en: $commits_list"
echo ""

if [ "$total_commits" -eq 0 ]; then
    echo "No se encontraron commits relacionados."
    echo "Puedes intentar:"
    echo "  1. Ajustar DEFAULT_SINCE_DATE en gcp-config.sh"
    echo "  2. Buscar manualmente con git log"
    exit 0
fi

# Extraer patches
echo "Extrayendo patches a candidates/..."
echo ""

extraidos=0
omitidos=0

# Para cada commit encontrado
while IFS=$'\t' read -r commit_hash commit_subject; do
    [ -z "$commit_hash" ] && continue
    
    # Verificar si ya procesamos este commit
    if is_hash_processed "$commit_hash"; then
        short_hash="${commit_hash:0:8}"
        echo "  Ya procesado: $short_hash - $commit_subject"
        omitidos=$((omitidos + 1))
        continue
    fi
    
    # Obtener siguiente número para esta serie
    patch_num=$(get_next_patch_number "$serie")
    
    # Crear nombre descriptivo
    patch_name=$(format_patch_name "$serie" "$patch_num" "$commit_subject")
    patch_file="$PATCHES_CANDIDATES/$patch_name"
    
    echo "  Extrayendo: $patch_name"
    
    # Extraer patch
    if (cd "$REPO_ORIGEN" && git format-patch -1 "$commit_hash" --stdout > "$patch_file" 2>/dev/null); then
        # Registrar hash procesado
        if register_hash "$commit_hash"; then
            echo "    OK: Extraído y registrado"
            extraidos=$((extraidos + 1))
        else
            echo "    Advertencia: Extraído pero no registrado"
            extraidos=$((extraidos + 1))
        fi
    else
        echo "    Error: No se pudo extraer $commit_hash"
        rm -f "$patch_file"
    fi
    
done < "$commits_list"

echo ""
echo "Resumen extracción:"
echo "  Extraídos:  $extraidos patches nuevos"
echo "  Omitidos:   $omitidos commits ya procesados"
echo "  Total:      $((extraidos + omitidos)) commits en lista"

if [ "$extraidos" -gt 0 ]; then
    echo ""
    echo "Patches disponibles en: $PATCHES_CANDIDATES/"
    ls -la "$PATCHES_CANDIDATES/S${serie}_"*.patch 2>/dev/null || echo "  (No hay patches visibles para S${serie})"
fi

echo ""
