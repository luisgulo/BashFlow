
# 🤝 Vault colaborativo en BashFlow

**Autor:** Luis GuLo  
**Versión:** 1.0  
**Última actualización:** 2025-09-15

---

## 🔐 ¿Qué es el modo colaborativo?

BashFlow Vault permite cifrar secretos de forma segura. 

En modo colaborativo, se utiliza **cifrado asimétrico** con claves públicas GPG, lo que permite compartir secretos sin exponer la clave de cifrado.

---

## 🧩 Requisitos

- GPG instalado (`gpg`)
- Clave pública exportada de cada colaborador
- Variable `VAULT_RECIPIENT` definida con el ID de la clave pública

---

## 📤 Exportar tu clave pública

```bash
gpg --export -a 'usuario@dominio' > ~/.bashflow.pub
```

> Puedes compartir este archivo con otros colaboradores para que cifren secretos destinados a ti.

---

## 🔑 Configurar entorno colaborativo

Define las siguientes variables en tu entorno o en `vault.sh`:

```bash
export VAULT_PUBKEY="$HOME/.bashflow.pub"
export VAULT_RECIPIENT="usuario@dominio"
```

---

## 🛠️ Cifrar secretos para otro usuario

```bash
vault.sh add nombre_secreto
```

> Si `~/.bashflow.pub` existe y `VAULT_RECIPIENT` está definido, se usará cifrado asimétrico automáticamente.

---

## 📥 Recuperar secretos cifrados

```bash
vault.sh get nombre_secreto
```

> GPG usará tu clave privada para descifrar el secreto.

---

## 🔄 Sincronización entre hosts

Usa el módulo `vault-remote` para enviar o recibir secretos:

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

## 🧪 Verificar estado del vault

```bash
vault-init.sh --status
```

> Muestra si hay claves configuradas, cuántos secretos existen y cuándo se generó la clave.

---

## 🧠 Recomendaciones

- Usa claves públicas para cifrar secretos destinados a otros usuarios
- No compartas tu clave privada
- Puedes tener múltiples claves públicas en `vault/keys/` si lo deseas
- Documenta quién tiene acceso a qué secretos

---

## 📦 Ejemplo de colaboración

Luis exporta su clave pública y la comparte con otro usuario. Este usuario configura `VAULT_RECIPIENT="luis@bashflow.dev"` y cifra un secreto con:

```bash
vault.sh add db_password
```

Luis podrá descifrarlo con su clave privada sin haber compartido ninguna clave simétrica.

