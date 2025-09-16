#!/bin/bash
# BashFlow Environment Checker
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1

MODULE_PATHS=("core/modules" "user_modules" "community_modules")
GLOBAL_TOOLS=("bash" "ssh" "scp" "git" "curl" "jq" "yq" "gpg")
REQUIRED_PATHS=(
  "core/modules"
  "core/utils"
  "core/examples"
  "core/docs"
  "user_modules"
  "community_modules"
  "bashflow.sh"
  "vault.sh"
)

check_global_tools() {
  echo "🔍 Verificando herramientas globales..."
  local missing=0
  for tool in "${GLOBAL_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
      echo "❌ $tool no encontrado"
      missing=1
    else
      echo "✅ $tool disponible"
    fi
  done
  return $missing
}

check_structure() {
  echo ""
  echo "📁 Verificando estructura de BashFlow..."
  local missing=0
  for path in "${REQUIRED_PATHS[@]}"; do
    if [ ! -e "$path" ]; then
      echo "❌ Falta: $path"
      missing=1
    else
      echo "✅ Encontrado: $path"
    fi
  done
  return $missing
}

load_and_check_modules() {
  echo ""
  echo "🔍 Verificando módulos BashFlow..."
  for dir in "${MODULE_PATHS[@]}"; do
    [ -d "$dir" ] || continue
    for mod in "$dir"/*.sh; do
      [ -f "$mod" ] && source "$mod"
    done
  done

  # Ejecutar funciones check_dependencies_<modulo>
  for func in $(declare -F | awk '{print $3}' | grep '^check_dependencies_'); do
    echo ""
    echo "🔧 Ejecutando $func..."
    $func || echo "⚠️  Dependencias incompletas en $func"
  done
}

main() {
  echo "🧪 BashFlow Environment Check"
  echo "============================="

  check_global_tools
  check_structure
  load_and_check_modules

  echo ""
  echo "✅ Verificación completada."
}

main "$@"
