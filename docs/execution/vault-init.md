# 🔐 Script: vault-init

## 🇪🇸 Descripción

El script `vault-init` inicializa el sistema de cifrado de BashFlow, generando una clave simétrica segura para proteger los secretos almacenados en `core/vault`. También permite rotar la clave existente, verificar el estado del vault y configurar cifrado asimétrico mediante claves públicas exportadas con GPG.

Este script se encuentra en `core/utils/vault-init.sh` y se accede mediante el alias `vault-init`.

---

## 🧩 Acciones disponibles

| Opción         | Descripción                                                                 |
|----------------|------------------------------------------------------------------------------|
| *(sin argumentos)* | Genera una nueva clave simétrica si no existe                            |
| `--rotate`     | Rota la clave actual y re-cifra todos los secretos                          |
| `--status`     | Muestra el estado actual del vault y claves                                 |
| `--asymmetric` | Verifica la existencia de una clave pública exportada para cifrado asimétrico |

---

## ▶️ Ejemplos de uso

```bash
vault-init                # Genera clave simétrica si no existe
vault-init --status       # Muestra estado del vault
vault-init --rotate       # Rota clave y re-cifra secretos
vault-init --asymmetric   # Verifica clave pública exportada
```

---

## 📁 Archivos utilizados

| Ruta                  | Descripción                                      |
|-----------------------|--------------------------------------------------|
| `core/vault/`         | Carpeta donde se almacenan los secretos cifrados |
| `~/.bashflow.key`     | Clave simétrica generada por defecto             |
| `~/.bashflow.pub`     | Clave pública exportada para cifrado asimétrico |

---

## 🧠 Trazas esperadas

```bash
🔐 Generando nueva clave simétrica...
✅ Clave creada en /home/user/.bashflow.key

🔄 Rotando clave y re-cifrando secretos...
🔁 Re-cifrando 'API_TOKEN'...
✅ Rotación completada. Clave antigua guardada en /home/user/.bashflow.key.old

📊 Estado del Vault
-------------------
🔐 Clave simétrica: ✅ presente
🔐 Clave pública:   ❌ ausente
📁 Ruta del vault:  core/vault
📦 Secretos:        3
🕒 Última modificación: 2025-09-19 00:44:12
```

---

## ⚠️ Advertencias

- La rotación de clave sobrescribe los secretos cifrados. Se recomienda hacer backup antes.
- El cifrado asimétrico requiere exportar previamente la clave pública con:
  ```bash
  gpg --export -a 'usuario@dominio' > ~/.bashflow.pub
  ```
- La clave simétrica debe mantenerse privada y segura. No compartir ni versionar.

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/vault-init.md`](../changelog/vault-init.md)

---
---


## 🔐 Script: vault-init

## 🇬🇧 Description

The `vault-init` script initializes BashFlow’s encryption system by generating a secure symmetric key to protect secrets stored in `core/vault`. It also allows rotating the existing key, checking vault status, and configuring asymmetric encryption using a previously exported GPG public key.

This script is located at `core/utils/vault-init.sh` and is accessed via the alias `vault-init`.

---

## 🧩 Available Actions

| Option         | Description                                                                 |
|----------------|------------------------------------------------------------------------------|
| *(no arguments)* | Generates a new symmetric key if none exists                              |
| `--rotate`     | Rotates the current key and re-encrypts all secrets                         |
| `--status`     | Displays the current vault and key status                                   |
| `--asymmetric` | Verifies the presence of an exported public key for asymmetric encryption   |

---

## ▶️ Usage Examples

```bash
vault-init                # Generate symmetric key if missing
vault-init --status       # Show vault status
vault-init --rotate       # Rotate key and re-encrypt secrets
vault-init --asymmetric   # Check for exported public key
```

---

## 📁 Key Files Used

| Path                  | Description                                      |
|-----------------------|--------------------------------------------------|
| `core/vault/`         | Folder where encrypted secrets are stored        |
| `~/.bashflow.key`     | Default symmetric key                            |
| `~/.bashflow.pub`     | Exported public key for asymmetric encryption    |

---

## 🧠 Expected Traces

```bash
🔐 Generating new symmetric key...
✅ Key created at /home/user/.bashflow.key

🔄 Rotating key and re-encrypting secrets...
🔁 Re-encrypting 'API_TOKEN'...
✅ Rotation complete. Old key saved at /home/user/.bashflow.key.old

📊 Vault Status
-------------------
🔐 Symmetric key: ✅ present
🔐 Public key:    ❌ missing
📁 Vault path:    core/vault
📦 Secrets:       3
🕒 Last modified: 2025-09-19 00:44:12
```

---

## ⚠️ Warnings

- Key rotation overwrites encrypted secrets. Backup is recommended before rotating.
- Asymmetric encryption requires exporting your public key first:
  ```bash
  gpg --export -a 'user@domain' > ~/.bashflow.pub
  ```
- The symmetric key must remain private and secure. Do not share or version it.

---

## 📜 Changelog

See the change history in [`changelog/vault-init.md`](../changelog/vault-init.md)

