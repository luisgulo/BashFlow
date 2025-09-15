#!/bin/bash
# Module: docker
# Description: Gestiona contenedores Docker (run, stop, remove, build, exec)
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, docker
# Usage:
#   docker_task "$host" "$action" "$name" "$image" "$cmd" "$dockerfile" "$context" "$become"

docker_task() {
  local host="$1"
  local action="$2"       # present | absent | stopped | build | exec
  local name="$3"
  local image="$4"
  local cmd="$5"
  local dockerfile="$6"
  local context="$7"
  local become="$8"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    present)
      ssh "$host" "$prefix docker ps -a --format '{{.Names}}' | grep -w '$name' &> /dev/null || $prefix docker run -d --name '$name' '$image'"
      ;;
    stopped)
      ssh "$host" "$prefix docker ps --format '{{.Names}}' | grep -w '$name' &> /dev/null && $prefix docker stop '$name'"
      ;;
    absent)
      ssh "$host" "$prefix docker ps -a --format '{{.Names}}' | grep -w '$name' &> /dev/null && $prefix docker rm -f '$name'"
      ;;
    build)
      ssh "$host" "$prefix docker image inspect '$image' &> /dev/null || $prefix docker build -t '$image' -f '$dockerfile' '$context'"
      ;;
    exec)
      ssh "$host" "$prefix docker ps --format '{{.Names}}' | grep -w '$name' &> /dev/null && $prefix docker exec '$name' $cmd"
      ;;
    *)
      echo "❌ [docker] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_docker() {
  if ! command -v ssh &> /dev/null; then
    echo "❌ [docker] ssh no está disponible."
    return 1
  fi
  echo "✅ [docker] ssh disponible."

  if ! command -v docker &> /dev/null; then
    echo "⚠️  [docker] docker no disponible localmente. Se asumirá que existe en el host remoto."
  else
    echo "✅ [docker] docker disponible localmente."
  fi
  return 0
}
