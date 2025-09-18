# 🔐 Script: vault.sh

## 🇪🇸 Descripción

El script `vault.sh` gestiona secretos cifrados dentro de BashFlow. Permite almacenar, consultar, editar y eliminar valores sensibles como contraseñas, tokens o claves API, usando cifrado simétrico o asimétrico con `gpg`.

Puede usarse como módulo (`vault_task`) dentro de un playbook, o como CLI directa mediante el alias `bashflow-vault`.

Los secretos se guardan en `core/vault/` y pueden exportarse como variables de entorno.

---

## 🧩 Argumentos disponibles (modo módulo)

| Clave     | Descripción                                                                 |
|-----------|------------------------------------------------------------------------------|
| `action`  | Acción a realizar: `add`, `get`, `show`, `edit`, `remove`, `list`, `exists`, `export` |
| `key`     | Nombre del secreto                                                          |
| `value`   | Valor del secreto (solo para `add`)                                         |
| `become`  | Si se requiere `sudo`, usar `become=true`                                   |

---

## ▶️ Ejemplo de uso en playbook

```yaml
tasks:
  - name: Guardar token de acceso
    module: vault
    args:
      action: add
      key: ACCESS_TOKEN
      value: "abc123"
```

---

## ▶️ Ejemplo de uso como CLI

```bash
bashflow-vault add ACCESS_TOKEN
bashflow-vault get ACCESS_TOKEN
bashflow-vault list
bashflow-vault export
```

---

## 🧠 Trazas esperadas

```bash
🔐 Usando cifrado simétrico para 'ACCESS_TOKEN'
✅ Secreto 'ACCESS_TOKEN' guardado en core/vault
🗑️ Secreto 'ACCESS_TOKEN' eliminado.
❌ No se encontró clave para cifrar. Ejecuta vault-init.sh primero.
```

---

## 📦 Claves utilizadas

- `VAULT_KEY`: clave simétrica (`~/.bashflow.key`)
- `VAULT_PUBKEY`: clave pública (`~/.bashflow.pub`)
- `VAULT_RECIPIENT`: ID de clave pública (opcional)
- `VAULT_DIR`: ruta de almacenamiento (`core/vault/`)

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/vault.md`](../changelog/vault.md)

---

---

# 🔐 Script: vault.sh

## 🇬🇧 Description

The `vault.sh` script manages encrypted secrets within BashFlow. It allows storing, retrieving, editing and deleting sensitive values such as passwords, tokens or API keys, using symmetric or asymmetric encryption via `gpg`.

It can be used as a module (`vault_task`) inside a playbook, or as a direct CLI via the alias `bashflow-vault`.

Secrets are stored in `core/vault/` and can be exported as environment variables.

---

## 🧩 Available Arguments (module mode)

| Key       | Description                                                                  |
|-----------|------------------------------------------------------------------------------|
| `action`  | Operation to perform: `add`, `get`, `show`, `edit`, `remove`, `list`, `exists`, `export` |
| `key`     | Secret name                                                                  |
| `value`   | Secret value (only for `add`)                                                |
| `become`  | Use `become=true` if `sudo` is required                                      |

---

## ▶️ Usage Example in Playbook

```yaml
tasks:
  - name: Store access token
    module: vault
    args:
      action: add
      key: ACCESS_TOKEN
      value: "abc123"
```

---

## ▶️ Usage Example as CLI

```bash
bashflow-vault add ACCESS_TOKEN
bashflow-vault get ACCESS_TOKEN
bashflow-vault list
bashflow-vault export
```

---

## 🧠 Expected Traces

```bash
🔐 Using symmetric encryption for 'ACCESS_TOKEN'
✅ Secret 'ACCESS_TOKEN' saved in core/vault
🗑️ Secret 'ACCESS_TOKEN' removed.
❌ No encryption key found. Run vault-init.sh first.
```

---

## 📦 Key Files Used

- `VAULT_KEY`: symmetric key (`~/.bashflow.key`)
- `VAULT_PUBKEY`: public key (`~/.bashflow.pub`)
- `VAULT_RECIPIENT`: public key ID (optional)
- `VAULT_DIR`: storage path (`core/vault/`)

---

## 📜 Changelog

See the change history in [`changelog/vault.md`](../changelog/vault.md)
