#!/bin/bash
# BashFlow Vault Initializer
# Author: Luis GuLo
# Version: 1.2
# Dependencies: gpg

VAULT_DIR="core/vault"
VAULT_KEY="${VAULT_KEY:-$HOME/.bashflow.key}"  # Clave simétrica por defecto
VAULT_PUBKEY="${VAULT_PUBKEY:-$HOME/.bashflow.pub}"  # Clave pública opcional

generate_key() {
  echo "🔐 Generando nueva clave simétrica..."
  head -c 64 /dev/urandom | base64 > "$VAULT_KEY"
  chmod 600 "$VAULT_KEY"
  echo "✅ Clave creada en $VAULT_KEY"
}

rotate_key() {
  echo "🔄 Rotando clave y re-cifrando secretos..."
  local OLD_KEY="$VAULT_KEY.old"

  cp "$VAULT_KEY" "$OLD_KEY"
  generate_key

  for file in "$VAULT_DIR"/*.gpg; do
    key=$(basename "$file" .gpg)
    echo "🔁 Re-cifrando '$key'..."
    gpg --quiet --batch --yes --passphrase-file "$OLD_KEY" -d "$file" | \
      gpg --symmetric --batch --yes --passphrase-file "$VAULT_KEY" -o "$VAULT_DIR/$key.gpg.new"

    mv "$VAULT_DIR/$key.gpg.new" "$VAULT_DIR/$key.gpg"
  done

  echo "✅ Rotación completada. Clave antigua guardada en $OLD_KEY"
}

status() {
  echo "📊 Estado del Vault"
  echo "-------------------"
  echo "🔐 Clave simétrica: $( [ -f "$VAULT_KEY" ] && echo '✅ presente' || echo '❌ ausente' )"
  echo "🔐 Clave pública:   $( [ -f "$VAULT_PUBKEY" ] && echo '✅ presente' || echo '❌ ausente' )"
  echo "📁 Ruta del vault:  $VAULT_DIR"
  echo "📦 Secretos:        $(ls "$VAULT_DIR"/*.gpg 2>/dev/null | wc -l)"
  echo "🕒 Última modificación: $(date -r "$VAULT_KEY" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"
}

generate_pubkey() {
  echo "🔐 Configurando cifrado asimétrico..."
  echo "⚠️  Se requiere que la clave pública esté exportada previamente con:"
  echo "    gpg --export -a 'usuario@dominio' > $VAULT_PUBKEY"
  if [ -f "$VAULT_PUBKEY" ]; then
    echo "✅ Clave pública detectada en $VAULT_PUBKEY"
  else
    echo "❌ Clave pública no encontrada. Exporta primero con GPG."
    exit 1
  fi
}

main() {
  case "$1" in
    --rotate)
      [ -f "$VAULT_KEY" ] || { echo "❌ No existe clave actual. Ejecuta sin --rotate primero."; exit 1; }
      rotate_key
      ;;
    --status)
      status
      ;;
    --asymmetric)
      generate_pubkey
      ;;
    *)
      if [ -f "$VAULT_KEY" ]; then
        echo "🔐 Clave ya existe en $VAULT_KEY"
      else
        generate_key
      fi
      ;;
  esac
}

main "$@"
