#!/bin/bash
# Module: package
# Description: Gestiona paquetes .deb en sistemas basados en APT
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, apt

package_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local name="${args[name]}"
  local state="${args[state]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  local check_cmd="dpkg -s '$name' &> /dev/null"
  local install_cmd="$prefix apt-get update && $prefix apt-get install -y '$name'"
  local remove_cmd="$prefix apt-get remove -y '$name'"
  local upgrade_cmd="$prefix apt-get update && $prefix apt-get install --only-upgrade -y '$name'"

  case "$state" in
    present)
      ssh "$host" "$check_cmd || $install_cmd"
      ;;
    absent)
      ssh "$host" "$check_cmd && $remove_cmd"
      ;;
    latest)
      ssh "$host" "$check_cmd && $upgrade_cmd || $install_cmd"
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

  if ! command -v apt-get &> /dev/null; then
    echo "⚠️  [package] apt-get no disponible localmente. Se asumirá que existe en el host remoto."
  else
    echo "✅ [package] apt-get disponible localmente."
  fi
  return 0
}
