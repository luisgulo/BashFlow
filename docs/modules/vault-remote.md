# 🔄 Módulo: vault-remote

## 🇪🇸 Descripción

El módulo `vault-remote` permite sincronizar secretos cifrados entre el vault local (`core/vault`) y un host remoto. Es útil para compartir credenciales, tokens o configuraciones sensibles entre nodos de forma segura, usando `scp` y `ssh`.

Soporta tres acciones principales:

- `push`: envía un secreto local al host remoto
- `pull`: recupera un secreto remoto al vault local
- `sync`: sincroniza todos los secretos locales hacia el host remoto

---

## 🧩 Argumentos disponibles

| Clave         | Descripción                                                                 |
|---------------|------------------------------------------------------------------------------|
| `action`      | Acción a realizar: `push`, `pull`, `sync`                                   |
| `key`         | Nombre del secreto (requerido para `push` y `pull`)                         |
| `remote_path` | Ruta remota donde se almacenarán los secretos (por defecto `/tmp/bashflow_vault`) |
| `become`      | Si se requiere `sudo`, usar `become=true`                                   |

---

## ▶️ Ejemplo de uso

```yaml
tasks:
  - name: Enviar secreto al nodo remoto
    module: vault-remote
    args:
      action: push
      key: DB_PASSWORD
      remote_path: /etc/bashflow/vault
```

---

## 🧠 Trazas esperadas (`--debug`)

```bash
📤 Secreto 'DB_PASSWORD' enviado a nodo1:/etc/bashflow/vault
📥 Secreto 'API_KEY' recuperado desde nodo1
🔄 Vault sincronizado con nodo1:/tmp/bashflow_vault
❌ [vault-remote] Secreto 'TOKEN' no existe localmente.
❌ [vault-remote] Acción 'delete' no soportada.
```

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/vault-remote.md`](../changelog/vault-remote.md)

---

---

# 🔄 Module: vault-remote

## 🇬🇧 Description

The `vault-remote` module synchronizes encrypted secrets between the local vault (`core/vault`) and a remote host. It’s useful for securely sharing credentials, tokens or sensitive configurations across nodes using `scp` and `ssh`.

Supports three main actions:

- `push`: sends a local secret to the remote host  
- `pull`: retrieves a remote secret into the local vault  
- `sync`: synchronizes all local secrets to the remote host  

---

## 🧩 Available Arguments

| Key           | Description                                                                  |
|---------------|------------------------------------------------------------------------------|
| `action`      | Operation to perform: `push`, `pull`, `sync`                                 |
| `key`         | Secret name (required for `push` and `pull`)                                 |
| `remote_path` | Remote path to store secrets (default `/tmp/bashflow_vault`)                 |
| `become`      | Use `become=true` if `sudo` is required                                      |

---

## ▶️ Usage Example

```yaml
tasks:
  - name: Push secret to remote node
    module: vault-remote
    args:
      action: push
      key: DB_PASSWORD
      remote_path: /etc/bashflow/vault
```

---

## 🧠 Expected Traces (`--debug`)

```bash
📤 Secret 'DB_PASSWORD' sent to node1:/etc/bashflow/vault
📥 Secret 'API_KEY' retrieved from node1
🔄 Vault synchronized with node1:/tmp/bashflow_vault
❌ [vault-remote] Secret 'TOKEN' does not exist locally.
❌ [vault-remote] Action 'delete' not supported.
```

---

## 📜 Changelog

See the change history in [`changelog/vault-remote.md`](../changelog/vault-remote.md)
