#!/bin/bash
# BashFlow Vault Manager
# License: GPLv3
# Author: Luis GuLo
# Version: 1.2
# Dependencies: gpg

VAULT_DIR="core/vault"
VAULT_KEY="${VAULT_KEY:-$HOME/.bashflow.key}"     # Clave simétrica
VAULT_PUBKEY="${VAULT_PUBKEY:-$HOME/.bashflow.pub}" # Clave pública
VAULT_RECIPIENT="${VAULT_RECIPIENT:-}"            # ID de clave pública (opcional)

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

decrypt_secret() {
  local key="$1"
  gpg --quiet --batch --yes --passphrase-file "$VAULT_KEY" -d "$VAULT_DIR/$key.gpg" 2>/dev/null || \
  gpg --quiet --batch --yes -d "$VAULT_DIR/$key.gpg"
}

list_secrets() {
  ls "$VAULT_DIR"/*.gpg 2>/dev/null | sed 's/.*\/\(.*\)\.gpg/\1/'
}

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
    get)
      decrypt_secret "$key"
      ;;
    add)
      encrypt_secret "$key" "$value"
      ;;
    list)
      list_secrets
      ;;
    *)
      echo "❌ [vault] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_vault() {
  if ! command -v gpg &> /dev/null; then
    echo "❌ [vault] gpg no está disponible."
    return 1
  fi
  echo "✅ [vault] gpg disponible."
  return 0
}

main() {
  case "$1" in
    add)
      read -s -p "🔑 Valor para '$2': " value
      echo ""
      encrypt_secret "$2" "$value"
      ;;
    get)
      decrypt_secret "$2"
      ;;
    list)
      list_secrets
      ;;
    *)
      echo "Uso: vault.sh {add|get|list} <clave>"
      ;;
  esac
}

# Ejecutar solo si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
