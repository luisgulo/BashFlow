#!/bin/bash
# BashFlow Environment Checker
# Author: Luis
# Version: 0.1

MODULE_PATHS=("core/modules" "user_modules" "community_modules")
GLOBAL_TOOLS=("yq" "ssh" "scp")

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
  load_and_check_modules
  echo ""
  echo "✅ Verificación completada."
}

main "$@"
