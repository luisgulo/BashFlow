#!/usr/bin/env bash
# Module: useradd
# Description: Crea usuarios en el sistema con opciones personalizadas
# Author: Luis GuLo
# Version: 0.1
# Dependencies: id, useradd, sudo

useradd_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local name="${args[name]}"
  local shell="${args[shell]:-/bin/bash}"
  local home="${args[home]:-/home/$name}"
  local groups="${args[groups]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  if id "$name" &>/dev/null; then
    echo "    ✅ [useradd] Usuario '$name' ya existe"
    return 0
  fi

  local cmd="$prefix useradd -m -d \"$home\" -s \"$shell\" \"$name\""
  [ -n "$groups" ] && cmd="$cmd -G \"$groups\""

  eval "$cmd" && echo "    ✅ [useradd] Usuario '$name' creado"
}

check_dependencies_useradd() {
  local missing=()
  for cmd in id sudo; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
    if [[ ${#missing[@]} -gt 0 ]]; then
      echo "    ❌ [useradd] Dependencias faltantes: ${missing[*]}"
      return 1
    else
      echo "    ✅ [useradd] $cmd disponible."    
    fi
  done
}
