#!/usr/bin/env bash
# Module: blockinfile
# Description: Inserta o actualiza bloques de texto delimitados en archivos
# Author: Luis GuLo
# Version: 0.1
# Dependencies: grep, sed, tee, awk

blockinfile_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local path="${args[path]}"
  local block="${args[block]}"
  local marker="${args[marker]:=BASHFLOW}"
  local create="${args[create]:-true}"
  local backup="${args[backup]:-true}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  local start="# BEGIN $marker"
  local end="# END $marker"

  if [[ ! -f "$path" ]]; then
    if [[ "$create" == "true" ]]; then
      echo "📄 [blockinfile] Creando archivo: $path"
      touch "$path"
    else
      echo "    ❌ [blockinfile] El archivo no existe y create=false"
      return 1
    fi
  fi

  if [[ "$backup" == "true" ]]; then
    cp "$path" "$path.bak"
    echo "📦 Copia de seguridad creada: $path.bak"
  fi

  # Eliminar bloque anterior si existe
  if grep -q "$start" "$path"; then
    echo "🔁 [blockinfile] Reemplazando bloque existente"
    $prefix sed -i "/$start/,/$end/d" "$path"
  fi

  # Insertar nuevo bloque
  echo "➕ [blockinfile] Insertando bloque delimitado"
  {
    echo "$start"
    echo "$block"
    echo "$end"
  } | $prefix tee -a "$path" > /dev/null
}

check_dependencies_blockinfile() {
  local missing=()
  for cmd in grep sed tee awk; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "    ❌ [blockinfile] Dependencias faltantes: ${missing[*]}"
      return 1
    else
      echo "    ✅ [blockinfile] $cmd disponible."     
    fi
  done
}
