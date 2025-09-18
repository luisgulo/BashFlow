#!/usr/bin/env bash
# License: GPLv3
# Author: Luis GuLo
# Version: 1.2

set -e

# 🧭 Detectar modo de instalación
if [[ "$EUID" -eq 0 ]]; then
  INSTALL_DIR="/opt/bashflow"
  BIN_DIR="/usr/local/bin"
  MODE="global"
else
  INSTALL_DIR="$HOME/bashflow"
  BIN_DIR="$HOME/.local/bin"
  MODE="local"
fi

echo "🔧 Instalando BashFlow en modo: $MODE"
echo "📁 Carpeta de instalación: $INSTALL_DIR"

# 📦 Crear carpetas destino
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

# 🧹 Limpiar instalación previa si existe
if [[ -d "$INSTALL_DIR" ]]; then
  echo "⚠️ Instalación previa detectada en $INSTALL_DIR"

  # 🛡️ Preservar vault si existe
  if [[ -d "$INSTALL_DIR/core/vault" ]]; then
    echo "📦 Preservando vault existente..."
    mv "$INSTALL_DIR/core/vault" /tmp/bashflow_vault_backup
  fi

  # 🛡️ Preservar inventory si existe
  if [[ -d "$INSTALL_DIR/core/inventory" ]]; then
    echo "📦 Preservando inventory existente..."
    mv "$INSTALL_DIR/core/inventory" /tmp/bashflow_inventory_backup
  fi

  echo "🧹 Eliminando instalación previa..."
  rm -rf "$INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
fi


# 📥 Copiar archivos y carpetas manualmente (excluyendo logo e install.sh)
echo "📦 Copiando archivos..."

# Archivos raíz
for file in bashflow.sh vault.sh LICENSE README.md CHANGELOG.md CONTRIBUTING.md; do
  cp "$file" "$INSTALL_DIR/"
done

# Carpetas completas
for dir in core community_modules user_modules docs examples; do
  cp -r "$dir" "$INSTALL_DIR/"
done

# 🔁 Restaurar vault si fue preservado
if [[ -d "/tmp/bashflow_vault_backup" ]]; then
  echo "🔁 Restaurando vault..."
  rm -rf "$INSTALL_DIR/core/vault"
  mv /tmp/bashflow_vault_backup "$INSTALL_DIR/core/vault"
fi

# 🔁 Restaurar inventory si fue preservado
if [[ -d "/tmp/bashflow_inventory_backup" ]]; then
  echo "🔁 Restaurando inventory..."
  rm -rf "$INSTALL_DIR/core/inventory"
  mv /tmp/bashflow_inventory_backup "$INSTALL_DIR/core/inventory"
fi

# 🔗 Crear symlinks en el PATH
ln -sf "$INSTALL_DIR/bashflow.sh" "$BIN_DIR/bashflow"
ln -sf "$INSTALL_DIR/vault.sh" "$BIN_DIR/bashflow-vault"
ln -sf "$INSTALL_DIR/core/utils/bashflow-doc.sh" "$BIN_DIR/bashflow-doc"
ln -sf "$INSTALL_DIR/core/utils/bashflow-check.sh" "$BIN_DIR/bashflow-check"
ln -sf "$INSTALL_DIR/core/utils/vault-init.sh" "$BIN_DIR/vault-init"

# 🧠 Añadir BASHFLOW_HOME al entorno
PROFILE_FILE="$HOME/.bashrc"
[[ "$SHELL" == *zsh ]] && PROFILE_FILE="$HOME/.zshrc"

if ! grep -q "BASHFLOW_HOME" "$PROFILE_FILE"; then
  echo "export BASHFLOW_HOME=\"$INSTALL_DIR\"" >> "$PROFILE_FILE"
  echo "export PATH=\"\$PATH:$BIN_DIR\"" >> "$PROFILE_FILE"
  echo "✅ Variables añadidas a $PROFILE_FILE"
else
  echo "ℹ️ BASHFLOW_HOME ya está definido en $PROFILE_FILE"
fi

# ✅ Finalización
echo ""
echo "🎉 Instalación completada correctamente."
echo "📦 Proyecto instalado en: $INSTALL_DIR"
echo "🔗 Symlinks creados en: $BIN_DIR"
echo "🧠 Recuerda reiniciar tu terminal o ejecutar: source $PROFILE_FILE"
echo "👉 Puedes ejecutar 'bashflow' desde cualquier terminal."
