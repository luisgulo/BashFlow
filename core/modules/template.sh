#!/usr/bin/env bash
# Module: template
# Description: Genera archivos a partir de plantillas con variables {{var}}
# Author: Luis GuLo
# Version: 0.2
# Dependencies: bash, sed

# 🧭 Detección de raíz del proyecto
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
TEMPLATE_DIR="$PROJECT_ROOT/core/templates"

template_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local src="${args[src]}"
  local dest="${args[dest]}"
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Validar plantilla
  local template_path="$TEMPLATE_DIR/$src"
  if [[ ! -f "$template_path" ]]; then
    echo "❌ [template] Plantilla no encontrada: $template_path"
    return 1
  fi

  # Leer contenido
  local content
  content=$(cat "$template_path")

  # Reemplazar variables {{var}} por su valor
  for key in "${!args[@]}"; do
    [[ "$key" == "src" || "$key" == "dest" || "$key" == "become" ]] && continue
    content=$(echo "$content" | sed "s|{{${key}}}|${args[$key]}|g")
  done

  # Escribir archivo
  echo "$content" | $prefix tee "$dest" > /dev/null
  echo "✅ [template] Archivo generado: $dest"
}
