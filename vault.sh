#!/usr/bin/env bash
# BashFlow Vault Manager
# License: GPLv3
# Author: Luis GuLo
# Version: 1.4
# Dependencies: gpg

set -e

# 🧭 Detección de la raíz del proyecto
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"

# 📁 Rutas clave
VAULT_DIR="$PROJECT_ROOT/core/vault"
VAULT_KEY="${VAULT_KEY:-$HOME/.bashflow.key}"       # Clave simétrica
VAULT_PUBKEY="${VAULT_PUBKEY:-$HOME/.bashflow.pub}" # Clave pública
VAULT_RECIPIENT="${VAULT_RECIPIENT:-}"              # ID de clave pública (opcional)

# 🔐 Cifrar secreto
encrypt_secret() {
  local key="$1"
  local value="$2"

  if [ -f "$VAULT_PUBKEY" ]; then
    echo "🔐 Usando cifrado asimétrico para '$key'"
    echo "$value" | gpg --encrypt --armor --batch --yes --recipient "$VAULT_RECIPIENT" -o "$VAULT_DIR/$key.gpg"
  elif [ -f "$VAULT_KEY" ]; then
    echo "🔐 Usando cifrado simétrico para '$key'"
    echo "$value" | gpg --symmetric --batch --yes --passphrase-file "$VAULT_KEY" -o "$VAULT_DIR/$key.gpg"
  else
    echo "❌ No se encontró clave para cifrar. Ejecuta vault-init.sh primero."
    return 1
  fi

  echo "✅ Secreto '$key' guardado en $VAULT_DIR"
}

# 🔓 Descifrar secreto
decrypt_secret() {
  local key="$1"
  gpg --quiet --batch --yes --passphrase-file "$VAULT_KEY" -d "$VAULT_DIR/$key.gpg" 2>/dev/null || \
  gpg --quiet --batch --yes -d "$VAULT_DIR/$key.gpg"
}

# 📋 Listar secretos
list_secrets() {
  ls "$VAULT_DIR"/*.gpg 2>/dev/null | sed 's|.*/\(.*\)\.gpg|\1|'
}

# 🧠 Verificar existencia
secret_exists() {
  local key="$1"
  [[ -f "$VAULT_DIR/$key.gpg" ]]
}

# 🗑️ Eliminar secreto
remove_secret() {
  local key="$1"
  rm -f "$VAULT_DIR/$key.gpg" && echo "🗑️ Secreto '$key' eliminado."
}

# ✏️ Editar secreto
edit_secret() {
  local key="$1"
  local current
  current=$(decrypt_secret "$key")
  read -s -p "🔑 Nuevo valor para '$key': " new_value
  echo ""
  encrypt_secret "$key" "$new_value"
}

# 📤 Exportar secretos como entorno
export_secrets() {
  for file in "$VAULT_DIR"/*.gpg; do
    varname="$(basename "$file" .gpg)"
    value="$(decrypt_secret "$varname")"
    echo "export $varname=\"$value\""
  done
}

# 🎯 Acción principal
vault_task() {
  local host="$1"; shift
  declare -A args
  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    args["$key"]="$value"
  done

  local action="${args[action]}"
  local key="${args[key]}"
  local value="${args[value]}"
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    get|show)
      decrypt_secret "$key"
      ;;
    add)
      encrypt_secret "$key" "$value"
      ;;
    edit)
      edit_secret "$key"
      ;;
    remove)
      remove_secret "$key"
      ;;
    exists)
      secret_exists "$key"
      ;;
    list)
      list_secrets
      ;;
    export)
      export_secrets
      ;;
    *)
      echo "❌ [vault] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

# 🔍 Verificar dependencias
check_dependencies_vault() {
  if ! command -v gpg &> /dev/null; then
    echo "❌ [vault] gpg no está disponible."
    return 1
  fi
  echo "✅ [vault] gpg disponible."
  return 0
}

# 🧪 CLI directa
main() {
  case "$1" in
    add)
      read -s -p "🔑 Valor para '$2': " value
      echo ""
      encrypt_secret "$2" "$value"
      ;;
    get|show)
      decrypt_secret "$2"
      ;;
    edit)
      edit_secret "$2"
      ;;
    remove)
      remove_secret "$2"
      ;;
    list)
      list_secrets
      ;;
    export)
      export_secrets
      ;;
    exists)
      secret_exists "$2" && echo "✅ Existe" || echo "❌ No existe"
      ;;
    *)
      echo "Uso: vault.sh {add|get|show|edit|remove|list|export|exists} <clave>"
      ;;
  esac
}

# 🚀 Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
