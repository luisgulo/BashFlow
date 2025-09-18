# 📜 Changelog — `vault-remote.sh`

Este documento registra los cambios realizados en el módulo `vault-remote.sh`, encargado de sincronizar secretos cifrados entre el vault local y remoto.

This document records changes made to the `vault-remote.sh` module, which is responsible for synchronizing encrypted secrets between the local and remote vaults.

---

## 🇪🇸 Historial de versiones

### 🧩 v1.0 — [2025-09-19]
- Versión inicial del módulo `vault-remote`
- Soporte para acciones:
  - `push`: envía un secreto local al host remoto
  - `pull`: recupera un secreto remoto al vault local
  - `sync`: sincroniza todos los secretos locales hacia el host remoto
- Uso de `scp` y `ssh` para transferencia segura
- Ruta remota configurable mediante `remote_path`
- Soporte para ejecución con `sudo` mediante `become=true`
- Mensajes de trazabilidad (`📤`, `📥`, `🔄`, `❌`)
- Validación de existencia de secretos antes de transferir

---
---

## 🇬🇧 Version History

### 🧩 v1.0 — [2025-09-19]
- Initial release of `vault-remote` module  
- Supported actions:
  - `push`: sends a local secret to the remote host  
  - `pull`: retrieves a remote secret into the local vault  
  - `sync`: synchronizes all local secrets to the remote host  
- Secure transfer using `scp` and `ssh`  
- Configurable remote path via `remote_path`  
- Support for `sudo` execution via `become=true`  
- Trace messages (`📤`, `📥`, `🔄`, `❌`)  
- Secret existence validation before transfer  
