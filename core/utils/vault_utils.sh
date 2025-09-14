#!/bin/bash
# Utility: vault_utils
# Description: Funciones para acceso seguro al vault de BashFlow
# Author: Luis GuLo
# Version: 1.0
# Dependencies: gpg

VAULT_DIR="${VAULT_DIR:-core/vault}"
VAULT_KEY="${VAULT_KEY:-~/.bashflow.key}"

get_secret() {
  local key="$1"
  local value

  if [ ! -f "$VAULT_DIR/$key.gpg" ]; then
    echo "❌ [vault] Secreto '$key' no encontrado en $VAULT_DIR"
    return 1
  fi

  value=$(gpg --quiet --batch --yes --passphrase-file "$VAULT_KEY" -d "$VAULT_DIR/$key.gpg" 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "❌ [vault] Error al descifrar '$key'"
    return 1
  fi

  echo "$value"
}
