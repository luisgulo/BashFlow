#!/bin/bash
# BashFlow Playbook Runner
# License: GPLv3
# Author: Luis GuLo
# Version: 1.1

set -e

# ─────────────────────────────────────────────
# 🔧 Configuración
# ─────────────────────────────────────────────
PLAYBOOK=""
HOST=""
DEBUG=false

get_version() {
  local script_path="$(realpath "$0")"
  local version_line
  version_line=$(grep -E '^# Version:' "$script_path" | head -n1)
  echo "${version_line/#\# Version:/BashFlow version:}"
  echo "Ubicación: $script_path"
}


# ─────────────────────────────────────────────
# 📦 Parsing de argumentos
# ─────────────────────────────────────────────

if [[ "$1" == "version" ]]; then
  get_version
  exit 0
fi


while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file)
      PLAYBOOK="$2"
      shift 2
      ;;
    -h|--host)
      HOST="$2"
      shift 2
      ;;
    --debug)
      DEBUG=true
      shift
      ;;
    *)
      echo "❌ Opción desconocida: $1"
      exit 1
      ;;
  esac
done

# ─────────────────────────────────────────────
# ✅ Validaciones iniciales
# ─────────────────────────────────────────────
if [ -z "$PLAYBOOK" ]; then
  echo "❌ Playbook no especificado. Usa -f <archivo.yaml>"
  exit 1
fi

if [ ! -f "$PLAYBOOK" ]; then
  echo "❌ Playbook no encontrado: $PLAYBOOK"
  exit 1
fi

if [ -z "$HOST" ]; then
  echo "❌ Host remoto no especificado. Usa -h <usuario@host>"
  exit 1
fi

# ─────────────────────────────────────────────
# 📖 Cargar tareas desde YAML
# ─────────────────────────────────────────────
#TASKS_JSON=$(yq -o=json '.' "$PLAYBOOK" | jq '.tasks')
TASKS_JSON=$(yq '.' "$PLAYBOOK" | jq '.tasks')

if [ "$TASKS_JSON" == "null" ]; then
  echo "❌ No se encontraron tareas en el playbook."
  exit 1
fi

# ─────────────────────────────────────────────
# 🔁 Ejecutar tareas
# ─────────────────────────────────────────────
NUM_TASKS=$(echo "$TASKS_JSON" | jq 'length')

for ((i=0; i<NUM_TASKS; i++)); do
  NAME=$(echo "$TASKS_JSON" | jq -r ".[$i].name")
  MODULE=$(echo "$TASKS_JSON" | jq -r ".[$i].module")
  ARGS=$(echo "$TASKS_JSON" | jq -c ".[$i].args")

  echo "🔧 Ejecutando tarea: \"$NAME\" (módulo: \"$MODULE\")"

  MODULE_PATH="core/modules/${MODULE}.sh"
  if [ ! -f "$MODULE_PATH" ]; then
    echo "❌ Módulo no encontrado: $MODULE_PATH"
    continue
  fi

  source "$MODULE_PATH"

  # Extraer argumentos dinámicamente
  ARG_KEYS=$(echo "$ARGS" | jq -r 'keys[]')
  ARG_VALUES=()
  for key in $ARG_KEYS; do
    value=$(echo "$ARGS" | jq -r ".[\"$key\"]")
    ARG_VALUES+=("${key}=${value}")
  done

  # Ejecutar función del módulo
  if declare -f "${MODULE}_task" > /dev/null; then
    "${MODULE}_task" "$HOST" "${ARG_VALUES[@]}"
  elif declare -f "${MODULE}Task" > /dev/null; then
    "${MODULE}Task" "$HOST" "${ARG_VALUES[@]}"
  else
    echo "❌ Función de ejecución no encontrada en módulo: $MODULE"
  fi

  echo ""
done
