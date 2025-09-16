#!/bin/bash
# BashFlow Module Template Generator
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0

MODULE_NAME="$1"
MODULE_DIR="core/modules"
MODULE_FILE="$MODULE_DIR/$MODULE_NAME.sh"

if [ -z "$MODULE_NAME" ]; then
  echo "❌ Uso: module-template.sh <nombre_modulo>"
  exit 1
fi

if [ -f "$MODULE_FILE" ]; then
  echo "⚠️ El módulo '$MODULE_NAME' ya existe en $MODULE_DIR"
  exit 1
fi

mkdir -p "$MODULE_DIR"

cat > "$MODULE_FILE" <<EOF
#!/bin/bash
# Module: $MODULE_NAME
# Description: <descripción breve del módulo>
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0
# Dependencies: <comandos externos si aplica>

${MODULE_NAME}_task() {
  local host="\$1"; shift
  declare -A args
  for arg in "\$@"; do
    key="\${arg%%=*}"
    value="\${arg#*=}"
    args["\$key"]="\$value"
  done

  echo "🚧 Ejecutando módulo '$MODULE_NAME' en \$host"
  # Aquí va la lógica principal
}

check_dependencies_$MODULE_NAME() {
  # Verifica herramientas necesarias
  for cmd in <comando1> <comando2>; do
    if ! command -v "\$cmd" &> /dev/null; then
      echo "  ❌ [$MODULE_NAME] Falta: \$cmd"
      return 1
    fi
  done
  echo "  ✅ [$MODULE_NAME] Dependencias OK"
  return 0
}
EOF

chmod +x "$MODULE_FILE"
echo "✅ Módulo '$MODULE_NAME' creado en $MODULE_FILE"
