#!/bin/bash
# Module: package
# Description: Instala, actualiza o elimina paquetes .deb/.rpm según el gestor disponible
# Author: Luis GuLo
# Version: 2.0
# Dependencies: ssh

package_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local name="${args[name]}"
  local state="${args[state]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Detectar gestor de paquetes en el host remoto
  local pkg_mgr
  pkg_mgr=$(ssh "$host" "command -v apt-get || command -v apt || command -v dnf || command -v yum")

  if [ -z "$pkg_mgr" ]; then
    echo "❌ [package] No se detectó gestor de paquetes compatible en el host."
    return 1
  fi

  case "$pkg_mgr" in
    *apt*)
      package_apt "$host" "$name" "$state" "$prefix"
      ;;
    *yum*|*dnf*)
      package_rpm "$host" "$name" "$state" "$prefix"
      ;;
    *)
      echo "❌ [package] Gestor '$pkg_mgr' no soportado."
      return 1
      ;;
  esac
}

package_apt() {
  local host="$1"
  local name="$2"
  local state="$3"
  local prefix="$4"

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
      echo "❌ [package] Estado '$state' no soportado para APT."
      return 1
      ;;
  esac
}

package_rpm() {
  local host="$1"
  local name="$2"
  local state="$3"
  local prefix="$4"

  local check_cmd="rpm -q '$name' &> /dev/null"
  local install_cmd="$prefix yum install -y '$name' || $prefix dnf install -y '$name'"
  local remove_cmd="$prefix yum remove -y '$name' || $prefix dnf remove -y '$name'"
  local upgrade_cmd="$prefix yum update -y '$name' || $prefix dnf upgrade -y '$name'"

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
      echo "❌ [package] Estado '$state' no soportado para RPM."
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
  return 0
}
