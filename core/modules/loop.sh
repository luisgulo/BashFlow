#!/usr/bin/env bash
# Module: loop
# Description: Ejecuta un módulo sobre una lista o matriz de valores
# Author: Luis GuLo
# Version: 0.2
# Dependencies: bashflow, echo, tee

loop_task() {
  local host="$1"; shift
  declare -A args
  local items_raw="" secondary_raw="" target_module=""
  local fail_fast="true"
  declare -A module_args

  # Parsear argumentos
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    case "$key" in
      items) items_raw="$value" ;;
      secondary) secondary_raw="$value" ;;
      module) target_module="$value" ;;
      fail_fast) fail_fast="$value" ;;
      *) module_args["$key"]="$value" ;;
    esac
  done

  # Validación mínima
  if [[ -z "$items_raw" || -z "$target_module" ]]; then
    echo "  ❌ [loop] Faltan argumentos obligatorios: items=... module=..."
    return 1
  fi

  IFS=',' read -r -a items <<< "$items_raw"
  IFS=',' read -r -a secondary <<< "$secondary_raw"

  for item in "${items[@]}"; do
    # Detectar si es par clave:valor
    if [[ "$item" == *:* ]]; then
      item_key="${item%%:*}"
      item_value="${item#*:}"
    else
      item_key="$item"
      item_value=""
    fi

    if [[ -n "$secondary_raw" ]]; then
      for sec in "${secondary[@]}"; do
        run_module "$host" "$target_module" "$item" "$item_key" "$item_value" "$sec" module_args || {
          echo "⚠️ [loop] Falló la iteración con '$item' y '$sec'"
          [[ "$fail_fast" == "true" ]] && return 1
        }
      done
    else
      run_module "$host" "$target_module" "$item" "$item_key" "$item_value" "" module_args || {
        echo "⚠️ [loop] Falló la iteración con '$item'"
        [[ "$fail_fast" == "true" ]] && return 1
      }
    fi
  done
}

run_module() {
  local host="$1"
  local module="$2"
  local item="$3"
  local item_key="$4"
  local item_value="$5"
  local secondary_item="$6"
  declare -n args_ref="$7"

  local call_args=()
  for key in "${!args_ref[@]}"; do
    value="${args_ref[$key]}"
    value="${value//\{\{item\}\}/$item}"
    value="${value//\{\{item_key\}\}/$item_key}"
    value="${value//\{\{item_value\}\}/$item_value}"
    value="${value//\{\{secondary_item\}\}/$secondary_item}"
    call_args+=("$key=$value")
  done

  echo "🔁 [loop] → $module con item='$item' secondary='$secondary_item'"
  bashflow run --host "$host" --module "$module" --args "${call_args[@]}"
}

check_dependencies_loop() {
  local missing=()
  for cmd in bashflow echo tee; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "  ❌ [loop] Dependencias faltantes: ${missing[*]}"
      return 1
    else
      echo "  ✅ [loop] $cmd disponible."    
    fi
  done
}
