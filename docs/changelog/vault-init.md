# 📜 Changelog — `vault-init.sh`

Este documento registra los cambios realizados en el script `vault-init.sh`, encargado de inicializar y mantener el sistema de cifrado de BashFlow.

This document records changes made to the `vault-init.sh` script, which is responsible for initializing and maintaining the BashFlow encryption system.

---

## 🇪🇸 Historial de versiones

### 🧩 v1.2 — [2025-09-19]
- Mejora de trazas con emojis (`🔐`, `🔄`, `📊`, `❌`)
- Implementación de `--status` para mostrar estado del vault
- Implementación de `--asymmetric` para verificar clave pública exportada
- Validación de existencia de clave antes de rotar
- Mensajes claros de éxito y advertencia
- Alias `vault-init` creado desde `core/utils/vault-init.sh`

---

### 🧩 v1.1 — [2025-08-25]
- Soporte para rotación de clave simétrica (`--rotate`)
- Re-cifrado automático de todos los secretos existentes
- Backup de clave antigua como `.bashflow.key.old`

---

### 🧩 v1.0 — [2025-08-10]
- Creación inicial del script `vault-init.sh`
- Generación de clave simétrica segura (`head | base64`)
- Protección de permisos (`chmod 600`)
- Integración con `core/vault/` como ruta de secretos

---
---

## 🇬🇧 Version History

### 🧩 v1.2 — [2025-09-19]
- Improved trace messages with emojis (`🔐`, `🔄`, `📊`, `❌`)
- Added `--status` to display vault status
- Added `--asymmetric` to verify exported public key
- Key existence check before rotation
- Clear success and warning messages
- Alias `vault-init` created from `core/utils/vault-init.sh`

---

### 🧩 v1.1 — [2025-08-25]
- Support for symmetric key rotation (`--rotate`)
- Automatic re-encryption of all existing secrets
- Backup of old key as `.bashflow.key.old`

---

### 🧩 v1.0 — [2025-08-10]
- Initial creation of `vault-init.sh` script
- Secure symmetric key generation (`head | base64`)
- Permission protection (`chmod 600`)
- Integration with `core/vault/` as secret storage path
