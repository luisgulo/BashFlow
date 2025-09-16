#!/bin/bash
# License: GPLv3
# Module: docker
# Description: Gestiona contenedores Docker (run, stop, remove, build, exec)
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, docker
# Usage:
#   docker_task "$host" "$action" "$name" "$image" "$cmd" "$dockerfile" "$context" "$become"

docker_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local action="${args[action]}"
  local name="${args[name]}"
  local image="${args[image]}"
  local path="${args[path]}"
  local command="${args[command]}"
  local become="${args[become]}"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    present)
      ssh "$host" "$prefix docker ps -a --format '{{.Names}}' | grep -q '^$name$' || $prefix docker run -d --name '$name' '$image'"
      ;;
    stopped)
      ssh "$host" "$prefix docker ps --format '{{.Names}}' | grep -q '^$name$' && $prefix docker stop '$name'"
      ;;
    absent)
      ssh "$host" "$prefix docker ps -a --format '{{.Names}}' | grep -q '^$name$' && $prefix docker rm -f '$name'"
      ;;
    build)
      ssh "$host" "cd '$path' && $prefix docker build -t '$image' ."
      ;;
    exec)
      ssh "$host" "$prefix docker exec '$name' $command"
      ;;
    *)
      echo "  ❌ [docker] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_docker() {
  if ! command -v ssh &> /dev/null; then
    echo "  ❌ [docker] ssh no está disponible."
    return 1
  fi
  echo "  ✅ [docker] ssh disponible."

  if ! command -v docker &> /dev/null; then
    echo "⚠️  [docker] docker no disponible localmente. Se asumirá que existe en el host remoto."
  else
    echo "  ✅ [docker] docker disponible localmente."
  fi
  return 0
}
