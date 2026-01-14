#!/bin/bash
# 00init.sh
# Inicializa y verifica entorno GCP
# Uso: ./00init.sh

# Cargar configuración centralizada
source "$(dirname "$0")/gcp.conf"

# Mostrar configuración
script_header "INICIALIZAR GCP"
show_config

# Crear estructura de directorios
create_directories

echo ""
echo "Directorio base: $PATCHES_BASE"
echo ""

# INICIALIZAR SISTEMA DE ESTADO
echo "Inicializando sistema de estado..."

# Crear archivos de estado si no existen
touch "$PROCESSED_COMMITS_LOG"
touch "$SERIES_COUNTER_FILE"

# Función para registrar hashes de parches existentes
register_existing_patches() {
    local dir="$1"
    local count=0

    if [ -d "$dir" ]; then
        for patch_file in "$dir"/*.patch; do
            [ -f "$patch_file" ] || continue

            hash=$(extract_hash_from_patch "$patch_file")
            if [ -n "$hash" ]; then
                if ! grep -q "^$hash$" "$PROCESSED_COMMITS_LOG"; then
                    echo "$hash" >> "$PROCESSED_COMMITS_LOG"
                    count=$((count + 1))
                fi
            fi
        done
    fi
    echo "$count"
}

echo "Registrando hashes de parches existentes..."

# Registrar parches de todas las carpetas
registered_pending=$(register_existing_patches "$PATCHES_PENDING")
registered_applied=$(register_existing_patches "$PATCHES_APPLIED")
registered_candidates=$(register_existing_patches "$PATCHES_CANDIDATES")

total_registered=$((registered_pending + registered_applied + registered_candidates))
echo "  Pending:   $registered_pending hashes"
echo "  Applied:   $registered_applied hashes"
echo "  Candidates: $registered_candidates hashes"
echo "  Total:     $total_registered hashes registrados"

# DETERMINAR PRÓXIMA SERIE
echo ""
echo "Determinando próxima serie..."

next_series=1
max_series_found=0

# Buscar la serie más alta en los nombres de parches existentes
for dir in "$PATCHES_PENDING" "$PATCHES_APPLIED" "$PATCHES_CANDIDATES"; do
    if [ -d "$dir" ]; then
        for patch_file in "$dir"/*.patch; do
            [ -f "$patch_file" ] || continue
            patch_name=$(basename "$patch_file")
            
            # Extraer número de serie del nombre (S1_001-patch.patch → 1)
            if [[ "$patch_name" =~ ^S([0-9]+)_ ]]; then
                series_num="${BASH_REMATCH[1]}"
                if [ "$series_num" -gt "$max_series_found" ]; then
                    max_series_found="$series_num"
                fi
            fi
        done
    fi
done

if [ "$max_series_found" -gt 0 ]; then
    next_series=$((max_series_found + 1))
fi

# Guardar próxima serie
echo "$next_series" > "$SERIES_COUNTER_FILE"
echo "  Serie más alta encontrada: S$max_series_found"
echo "  Próxima serie: S$next_series"

# Verificar repositorios
echo ""
echo "Verificando repositorios..."

# Verificar repositorio origen
echo "Repositorio origen: $REPO_ORIGEN"
if [ -d "$REPO_ORIGEN" ]; then
    cd "$REPO_ORIGEN" 2>/dev/null && \
        echo "  Existe - Rama: $(git branch --show-current 2>/dev/null || echo 'desconocida')" || \
        echo "  Existe pero no es repositorio git"
else
    echo "  NO EXISTE"
fi

# Verificar repositorio destino
echo "Repositorio destino: $REPO_DESTINO"
if [ -d "$REPO_DESTINO" ]; then
    cd "$REPO_DESTINO" 2>/dev/null && \
        echo "  Existe - Rama: $(git branch --show-current 2>/dev/null || echo 'desconocida')" || \
        echo "  Existe pero no es repositorio git"
else
    echo "  NO EXISTE"
fi

# Verificar scripts
echo ""
echo "Verificando scripts GCP..."
for script in 01crea_lista_archivos.sh 02extraer_parches.sh 04aplica_commits.sh 05diagnostica_fallas.sh; do
    if [ -f "$PATCHES_SCRIPTS/$script" ]; then
        echo "  OK: $script"
    else
        echo "  FALTANTE: $script"
    fi
done

echo ""
echo "Inicialización completa."
echo "Estructura lista en: $PATCHES_BASE"
echo "Estado: $total_registered hashes registrados, próxima serie: S$next_series"
