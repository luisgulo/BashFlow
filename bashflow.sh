#!/bin/bash
# BashFlow Controller
# Author: Luis GuLo
# Version: 0.1

set -e

# 📁 Rutas de módulos
MODULE_PATHS=("core/modules" "user_modules" "community_modules")

# 🔧 Cargar todos los módulos
load_modules() {
  for dir in "${MODULE_PATHS[@]}"; do
    [ -d "$dir" ] || continue
    for mod in "$dir"/*.sh; do
      [ -f "$mod" ] && source "$mod"
    done
  done
}

# 🧪 Verificar dependencias globales
check_global_dependencies() {
  if ! command -v yq &> /dev/null; then
    echo "❌ yq no está instalado. Instálalo para continuar."
    exit 1
  fi
}

# 📦 Ejecutar tareas
execute_tasks() {
  local playbook="$1"
  local hosts=($(yq '.hosts[]' "$playbook"))
  local task_count=$(yq '.tasks | length' "$playbook")

  for ((i=0; i<task_count; i++)); do
    local name=$(yq ".tasks[$i].name" "$playbook")
    local module=$(yq ".tasks[$i].module" "$playbook")
    local args=$(yq ".tasks[$i].args" "$playbook")

    echo "🔧 Ejecutando tarea: $name (módulo: $module)"

    for host in "${hosts[@]}"; do
      echo "➡️  Host: $host"

      case "$module" in
        run)
          local cmd=$(yq ".tasks[$i].args.command" "$playbook")
          local become=$(yq ".tasks[$i].args.become" "$playbook")
          run_task "$host" "$cmd" "$become"
          ;;
        copy)
          local src=$(yq ".tasks[$i].args.src" "$playbook")
          local dest=$(yq ".tasks[$i].args.dest" "$playbook")
          local mode=$(yq ".tasks[$i].args.mode" "$playbook")
          local become=$(yq ".tasks[$i].args.become" "$playbook")
          copy_task "$host" "$src" "$dest" "$mode" "$become"
          ;;
        service)
          local name=$(yq ".tasks[$i].args.name" "$playbook")
          local action=$(yq ".tasks[$i].args.action" "$playbook")
          local become=$(yq ".tasks[$i].args.become" "$playbook")
          service_task "$host" "$name" "$action" "$become"
          ;;
        *)
          echo "❌ Módulo '$module' no reconocido."
          ;;
      esac
    done
  done
}

# 🚀 Punto de entrada
main() {
  local playbook="$1"
  [ -f "$playbook" ] || { echo "❌ Playbook no encontrado: $playbook"; exit 1; }

  check_global_dependencies
  load_modules
  execute_tasks "$playbook"
}

main "$@"
