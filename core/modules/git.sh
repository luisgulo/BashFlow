#!/bin/bash
# Module: git
# Description: Gestiona repositorios Git en hosts remotos (clone, pull, checkout, fetch-file)
# Author: Luis GuLo
# Version: 1.1
# Dependencies: ssh, git, curl, tar
# Usage:
#   git_task "$host" "$action" "$repo" "$dest" "$branch" "$file_path" "$become"

git_task() {
  local host="$1"
  local action="$2"       # clone | pull | checkout | fetch-file
  local repo="$3"
  local dest="$4"
  local branch="$5"
  local file_path="$6"
  local become="$7"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    clone)
      ssh "$host" "[ -d '$dest/.git' ] || $prefix git clone '$repo' '$dest'"
      ;;
    pull)
      ssh "$host" "[ -d '$dest/.git' ] && cd '$dest' && $prefix git pull"
      ;;
    checkout)
      ssh "$host" "[ -d '$dest/.git' ] && cd '$dest' && $prefix git checkout '$branch'"
      ;;
    fetch-file)
      fetch_file_from_repo "$host" "$repo" "$branch" "$file_path" "$dest" "$become"
      ;;
    *)
      echo "❌ [git] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

fetch_file_from_repo() {
  local host="$1"
  local repo="$2"         # Puede ser URL, SSH o ruta local
  local branch="$3"
  local file_path="$4"
  local dest="$5"
  local become="$6"

  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  # Extraer archivo usando git archive (requiere acceso al repo)
  ssh "$host" "$prefix git archive --remote='$repo' '$branch' '$file_path' | $prefix tar -xO > '$dest'"
}

check_dependencies_git() {
  local missing=0
  for cmd in ssh git curl tar; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "❌ [git] $cmd no disponible."
      missing=1
    else
      echo "✅ [git] $cmd disponible."
    fi
  done
  return $missing
}
