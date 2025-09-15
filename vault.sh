#!/bin/bash
# BashFlow Vault Manager
# Author: Luis GuLo
# Version: 0.1
# Dependencies: gpg

VAULT_DIR="core/vault"
VAULT_KEY="${VAULT_KEY:-~/.bashflow.key}"  # Clave simétrica

encrypt_secret() {
  local key="$1"
  local value="$2"
  echo "$value" | gpg --symmetric --batch --yes --passphrase-file "$VAULT_KEY" -o "$VAULT_DIR/$key.gpg"
  echo "🔐 Secreto '$key' guardado."
}

decrypt_secret() {
  local key="$1"
  gpg --quiet --batch --yes --passphrase-file "$VAULT_KEY" -d "$VAULT_DIR/$key.gpg"
}

list_secrets() {
  ls "$VAULT_DIR"/*.gpg 2>/dev/null | sed 's/.*\/\(.*\)\.gpg/\1/'
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

main "$@"
