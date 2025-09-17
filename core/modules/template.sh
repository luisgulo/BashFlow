#!/usr/bin/env bash
# Module: template
# Description: Genera archivos a partir de plantillas con variables {{var}}, bucles, includes y delimitadores configurables
# Author: Luis GuLo
# Version: 0.3
# Dependencies: bash, sed, tee, grep, cat

# 🧭 Detección de raíz del proyecto
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
TEMPLATE_DIR="$PROJECT_ROOT/core/templates"

template_task() {
  local host="$1"; shift
  declare -A args
  local start_delim="{{" end_delim="}}" strict="false"
  declare -A vars

  # Parsear argumentos
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    case "$key" in
      src) src="$value" ;;
      dest) dest="$value" ;;
      become) become="$value" ;;
      delimiters)
        start_delim="${value%% *}"
        end_delim="${value#* }"
        ;;
      strict) strict="$value" ;;
      *) vars["$key"]="$value" ;;
    esac
  done

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  local template_path="$TEMPLATE_DIR/$src"
  [[ ! -f "$template_path" ]] && echo "    ❌ [template] Plantilla no encontrada: $template_path" && return 1

  local rendered=""
  local line loop_active="false" loop_key="" loop_buffer=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Inclusión de fragmentos
    if [[ "$line" =~ ${start_delim}[[:space:]]*include[[:space:]]*\"([^\"]+)\"[[:space:]]*${end_delim} ]]; then
      include_file="${BASH_REMATCH[1]}"
      include_path="$TEMPLATE_DIR/$include_file"
      [[ -f "$include_path" ]] && rendered+=$(cat "$include_path")$'\n'
      continue
    fi

    # Inicio de bucle
    if [[ "$line" =~ ^#LOOP[[:space:]]+([a-zA-Z0-9_]+)$ ]]; then
      loop_active="true"
      loop_key="${BASH_REMATCH[1]}"
      loop_buffer=()
      continue
    fi

    # Fin de bucle
    if [[ "$line" == "#ENDLOOP" ]]; then
      loop_active="false"
      IFS=',' read -r -a items <<< "${vars[$loop_key]}"
      for item in "${items[@]}"; do
        for loop_line in "${loop_buffer[@]}"; do
          rendered+=$(replace_vars "$loop_line" "$item" "$start_delim" "$end_delim")$'\n'
        done
      done
      continue
    fi

    # Acumulación de líneas en bucle
    if [[ "$loop_active" == "true" ]]; then
      loop_buffer+=("$line")
      continue
    fi

    # Línea normal
    rendered+=$(replace_vars "$line" "" "$start_delim" "$end_delim")$'\n'
  done < "$template_path"

  # Validación de variables no definidas
  if [[ "$strict" == "true" ]]; then
    missing=$(echo "$rendered" | grep -o "${start_delim}[^${end_delim}]*${end_delim}" | sort -u)
    if [[ -n "$missing" ]]; then
      echo "    ❌ [template] Variables no definidas:"
      echo "$missing"
      return 1
    fi
  fi

  echo "$rendered" | $prefix tee "$dest" > /dev/null
  echo "    ✅ [template] Archivo generado: $dest"
}

replace_vars() {
  local line="$1"
  local item="$2"
  local start_delim="$3"
  local end_delim="$4"
  for key in "${!vars[@]}"; do
    line="${line//${start_delim}${key}${end_delim}/${vars[$key]}}"
  done
  [[ -n "$item" ]] && line="${line//${start_delim}item${end_delim}/$item}"
  echo "$line"
}


check_dependencies_template() {
  local missing=()
  for cmd in sed tee grep cat; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "    ❌ [template] Dependencias faltantes: ${missing[*]}"
      return 1
    else
      echo "    ✅ [template] $cmd disponible."
    fi
  done
}