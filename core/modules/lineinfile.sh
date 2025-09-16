#!/usr/bin/env bash
# Module: lineinfile
# Description: Asegura la presencia o reemplazo de una línea en un archivo
# Author: Luis GuLo
# Version: 0.1
# Dependencies: grep, sed, tee, awk

lineinfile_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local path="${args[path]}"
  local line="${args[line]}"
  local regexp="${args[regexp]}"
  local insert_after="${args[insert_after]}"
  local create="${args[create]:-true}"
  local backup="${args[backup]:-true}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Crear archivo si no existe
  if [[ ! -f "$path" ]]; then
    if [[ "$create" == "true" ]]; then
      echo "📄 [lineinfile] Creando archivo: $path"
      touch "$path"
    else
      echo "❌ [lineinfile] El archivo no existe y create=false"
      return 1
    fi
  fi

  # Crear copia de seguridad
  if [[ "$backup" == "true" ]]; then
    cp "$path" "$path.bak"
    echo "📦 Copia de seguridad creada: $path.bak"
  fi

  # Si existe regexp, reemplazar línea
  if [[ -n "$regexp" ]]; then
    if grep -Eq "$regexp" "$path"; then
      echo "🔁 [lineinfile] Reemplazando línea que coincide con: $regexp"
      $prefix sed -i "s|$regexp|$line|" "$path"
      return 0
    fi
  fi

  # Si insert_after está definido
  if [[ -n "$insert_after" ]]; then
    if grep -q "$insert_after" "$path"; then
      echo "➕ [lineinfile] Insertando después de: $insert_after"
      $prefix sed -i "/$insert_after/a $line" "$path"
      return 0
    fi
  fi

  # Si la línea ya existe, no hacer nada
  if grep -Fxq "$line" "$path"; then
    echo "✅ [lineinfile] Línea ya presente: \"$line\""
    return 0
  fi

  # Añadir al final
  echo "➕ [lineinfile] Añadiendo línea al final"
  echo "$line" | $prefix tee -a "$path" > /dev/null
}

check_dependencies_lineinfile() {
  local missing=()
  for cmd in grep sed tee awk; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "❌ [lineinfile] Dependencias faltantes: ${missing[*]}"
    return 1
  fi
}
