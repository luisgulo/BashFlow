# 🔐 BashFlow Vault: Gestión de secretos cifrados

**Autor:** Luis GuLo  
**Versión:** 1.2  
**Última actualización:** 2025-09-15

---

## 🧩 ¿Qué es BashFlow Vault?

Vault es el sistema de gestión de secretos cifrados de BashFlow. 

Permite almacenar, recuperar y sincronizar valores sensibles como tokens, contraseñas o claves API, de forma segura y automatizable.

---

## 🔐 Modos de cifrado

| Tipo        | Activación                   | Comando GPG usado                         |
|-------------|------------------------------|-------------------------------------------|
| Simétrico   | Si existe `~/.bashflow.key`  | `gpg --symmetric --passphrase-file ...`   |
| Asimétrico  | Si existe `~/.bashflow.pub`  | `gpg --encrypt --recipient ...`           |

> Si ambas claves existen, se prioriza el cifrado asimétrico para colaboración.

---

## 📁 Estructura

- `core/vault/`: almacena los secretos cifrados (`*.gpg`)
- `~/.bashflow.key`: clave simétrica local
- `~/.bashflow.pub`: clave pública para cifrado colaborativo

---

## 🛠️ Inicialización

```bash
vault-init.sh
```

- Crea la clave simétrica si no existe
- Usa `--rotate` para regenerar la clave y re-cifrar los secretos
- Usa `--status` para ver el estado del vault
- Usa `--asymmetric` para configurar cifrado con clave pública

---

## 🧪 Uso desde CLI

```bash
vault.sh add nombre_secreto       # Cifra y guarda
vault.sh get nombre_secreto       # Descifra y muestra
vault.sh list                     # Lista claves disponibles
```

> En modo `add`, se solicita el valor de forma segura (`read -s`)

---

## 🧾 Uso como módulo BashFlow

```yaml
tasks:
  - name: Guardar secreto
    module: vault
    args:
      action: add
      key: db_password
      value: "supersecreto123"

  - name: Obtener secreto
    module: vault
    args:
      action: get
      key: db_password
```

---

## 🔄 Sincronización remota

Usa el módulo `vault-remote` para enviar o recuperar secretos desde otros hosts:

```yaml
tasks:
  - name: Enviar secreto al host remoto
    module: vault-remote
    args:
      action: push
      key: api_token
      remote_path: "/etc/bashflow/vault"
      become: true
```

---

## 🧠 Buenas prácticas

- No compartas tu clave simétrica (`~/.bashflow.key`)
- Usa claves públicas para cifrar secretos destinados a otros usuarios
- Usa `vault-init.sh --rotate` periódicamente para renovar la clave
- Documenta quién tiene acceso a qué secretos

---

## 📚 Documentación relacionada

- [`vault-collab.md`](vault-collab.md): colaboración con claves públicas
- [`vault-remote.sh`](../modules/vault-remote.sh): sincronización entre hosts
- [`vault-init.sh`](../utils/vault-init.sh): inicialización y rotación de claves

