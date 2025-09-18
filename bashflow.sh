#!/bin/bash
# BashFlow Playbook Runner
# License: GPLv3
# Author: Luis GuLo
# Version: 1.3

set -e

# ─────────────────────────────────────────────
# 🧭 Detección de la raíz del proyecto
# ─────────────────────────────────────────────
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
INVENTORY="$PROJECT_ROOT/hosts.yaml"

# ─────────────────────────────────────────────
# 🔧 Configuración
# ─────────────────────────────────────────────
PLAYBOOK=""
HOST=""
GROUP=""
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
    -g|--group)
      GROUP="$2"
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

if [ -z "$HOST" ] && [ -z "$GROUP" ]; then
  echo "❌ Debes especificar un host (-h) o un grupo (-g)"
  exit 1
fi

# ─────────────────────────────────────────────
# 📖 Cargar tareas desde YAML
# ─────────────────────────────────────────────
TASKS_JSON=$(yq '.' "$PLAYBOOK" | jq '.tasks')
if [ "$TASKS_JSON" == "null" ]; then
  echo "❌ No se encontraron tareas en el playbook."
  exit 1
fi

NUM_TASKS=$(echo "$TASKS_JSON" | jq 'length')

# ─────────────────────────────────────────────
# 🔁 Resolución de hosts
# ─────────────────────────────────────────────
if [ -n "$GROUP" ]; then
  HOSTS=$(yq ".all.children.\"$GROUP\".hosts | keys | .[]" "$INVENTORY")
  if [ -z "$HOSTS" ]; then
    echo "❌ Grupo '$GROUP' no encontrado en el inventario."
    exit 1
  fi
else
  HOSTS="$HOST"
fi

# ─────────────────────────────────────────────
# 🔁 Ejecutar tareas por host
# ─────────────────────────────────────────────
for CURRENT_HOST in $HOSTS; do
  HOST_IP=$(yq ".all.hosts.\"$CURRENT_HOST\".ansible_host" "$INVENTORY")
  BECOME=$(yq ".all.hosts.\"$CURRENT_HOST\".become" "$INVENTORY")
  LABEL=$(yq ".all.hosts.\"$CURRENT_HOST\".label" "$INVENTORY")

  echo "🖥️ Host: $CURRENT_HOST ($HOST_IP)"

  for ((i=0; i<NUM_TASKS; i++)); do
    NAME=$(echo "$TASKS_JSON" | jq -r ".[$i].name")
    MODULE=$(echo "$TASKS_JSON" | jq -r ".[$i].module")
    ARGS=$(echo "$TASKS_JSON" | jq -c ".[$i].args")

    echo "🔧 Ejecutando tarea: \"$NAME\" (módulo: \"$MODULE\")"

    MODULE_PATH="$PROJECT_ROOT/core/modules/${MODULE}.sh"
    if [ ! -f "$MODULE_PATH" ]; then
      echo "❌ Módulo no encontrado: $MODULE_PATH"
      continue
    fi

    source "$MODULE_PATH"

    ARG_KEYS=$(echo "$ARGS" | jq -r 'keys[]')
    ARG_VALUES=()
    for key in $ARG_KEYS; do
      value=$(echo "$ARGS" | jq -r ".[\"$key\"]")
      value="${value//\{\{ name \}\}/$CURRENT_HOST}"
      value="${value//\{\{ label \}\}/$LABEL}"
      ARG_VALUES+=("${key}=${value}")
    done

    if declare -f "${MODULE}_task" > /dev/null; then
      "${MODULE}_task" "$HOST_IP" "${ARG_VALUES[@]}"
    elif declare -f "${MODULE}Task" > /dev/null; then
      "${MODULE}Task" "$HOST_IP" "${ARG_VALUES[@]}"
    else
      echo "❌ Función de ejecución no encontrada en módulo: $MODULE"
    fi

    echo ""
  done
done
