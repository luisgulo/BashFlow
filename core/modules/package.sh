#!/bin/bash
# Module: package
# Description: Instala, actualiza o elimina paquetes usando apt (soporte inicial para .deb)
# Author: Luis GuLo
# Version: 0.1
# Dependencies: ssh, apt
# Usage:
#   package_task "$host" "$name" "$state" "$become"

package_task() {
  local host="$1"
  local name="$2"
  local state="$3"
  local become="$4"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Detectar si el paquete ya está instalado
  local check_cmd="dpkg -s $name &> /dev/null"
  local install_cmd="$prefix apt-get update && $prefix apt-get install -y $name"
  local remove_cmd="$prefix apt-get remove -y $name"

  case "$state" in
    present)
      ssh "$host" "$check_cmd || $install_cmd"
      ;;
    absent)
      ssh "$host" "$check_cmd && $remove_cmd"
      ;;
    latest)
      ssh "$host" "$check_cmd && $prefix apt-get update && $prefix apt-get install --only-upgrade -y $name || $install_cmd"
      ;;
    *)
      echo "❌ [package] Estado '$state' no soportado."
      return 1
      ;;
  esac
}

check_dependencies_package() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [package] ssh no está disponible."
    return 1
  fi
  echo "✅ [package] ssh disponible."

  # Verificación local de apt (solo informativa)
  if ! command -v apt-get &> /dev/null; then
    echo "⚠️  [package] apt-get no disponible localmente. Se asumirá que existe en el host remoto."
  else
    echo "✅ [package] apt-get disponible localmente."
  fi
  return 0
}
