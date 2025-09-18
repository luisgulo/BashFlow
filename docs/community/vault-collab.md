
## 📦 Propuesta técnica del módulo `vault-collab`

Resumen de todo lo necesario para implementar el módulo comunitario `vault-collab`, incluyendo estructura de directorios, funciones clave, flujo defensivo, dependencias, y sugerencias de documentación. 

Guía técnica para revisión, iteración y futura colaboración.

---


# 🔐 Módulo comunitario: vault-collab

## 🧩 Propósito

Permitir colaboración segura entre grupos o departamentos mediante cifrado asimétrico con claves públicas, sin compartir secretos ni claves privadas. Cada grupo puede cifrar secretos destinados a otro sin tener acceso a su contenido.

---

## 📁 Estructura de directorios

```
core/vault/
├── keys/           # Claves públicas importadas por grupo
│   ├── deploy-team.pub
│   ├── dev-team.pub
│   └── qa-team.pub
├── shared/         # Secretos cifrados para otros grupos
│   ├── deploy-team/
│   │   └── DB_TOKEN.gpg
│   ├── dev-team/
│   │   └── API_KEY.gpg
│   └── qa-team/
│       └── SMTP_PASS.gpg
```

---

## 🔧 Variables de entorno sugeridas

- `VAULT_GROUP_ID`: identificador del grupo local (ej. `dev-team`)
- `VAULT_TRUSTED_GROUPS`: lista de grupos autorizados para compartir (opcional)

---

## 🧪 Funciones clave

### `import_key(group, pubfile)`
Importa una clave pública externa al vault local.

```bash
mkdir -p "$COLLAB_KEYS"
cp "$pubfile" "$COLLAB_KEYS/$group.pub"
```

---

### `share_secret(key, value, recipient)`
Cifra un secreto usando la clave pública del grupo destino.

```bash
mkdir -p "$COLLAB_SHARED/$recipient"
echo "$value" | gpg --encrypt --armor --batch --yes --recipient-file "$COLLAB_KEYS/$recipient.pub" \
  -o "$COLLAB_SHARED/$recipient/$key.gpg"
```

---

### `receive_secret(key)`
Descifra un secreto recibido si se tiene la clave privada correspondiente.

```bash
group="${VAULT_GROUP_ID:-$(whoami)}"
gpg --quiet --batch --yes -d "$COLLAB_SHARED/$group/$key.gpg"
```

---

## 🧩 Acciones soportadas en `vault_collab_task`

| Acción        | Descripción                                                                 |
|---------------|------------------------------------------------------------------------------|
| `import-key`  | Importa una clave pública (`pubfile`, `recipient`)                          |
| `share`       | Cifra un secreto para otro grupo (`key`, `value`, `recipient`)              |
| `receive`     | Descifra un secreto compartido (`key`)                                      |
| `list-keys`   | Lista claves públicas disponibles                                           |
| `remove-key`  | Elimina una clave pública del vault local                                   |

---

## 📜 Esqueleto de `vault_collab_task`

```bash
vault_collab_task() {
  local host="$1"; shift
  declare -A args; for arg in "$@"; do key="${arg%%=*}"; value="${arg#*=}"; args["$key"]="$value"; done

  local action="${args[action]}"
  local key="${args[key]}"
  local value="${args[value]}"
  local recipient="${args[recipient]}"
  local pubfile="${args[pubfile]}"

  case "$action" in
    import-key) import_key "$recipient" "$pubfile" ;;
    share) share_secret "$key" "$value" "$recipient" ;;
    receive) receive_secret "$key" ;;
    list-keys) ls "$COLLAB_KEYS"/*.pub 2>/dev/null | sed 's|.*/||' ;;
    remove-key) rm -f "$COLLAB_KEYS/$recipient.pub" ;;
    *) echo "❌ Acción '$action' no soportada." ;;
  esac
}
```

---

## 📋 Dependencias

- `gpg`
- `ssh` (opcional para sincronización futura)
- `scp` (opcional para vault distribuido)

---

## 📚 Documentación sugerida

- `docs/community/vault-collab.md` → esta guía técnica
- `docs/changelog/vault-collab.md` → historial por versión
- `docs/security.md` → sección “Colaboración federada entre grupos”
- `README` → invitación a colaborar, ejemplos, advertencias de seguridad

---

## 🧠 Ideas futuras

- Validación de fingerprint y confianza (`trust-group`)
- Sincronización remota (`vault-collab-remote`)
- CLI directa (`bashflow-collab`)
- Exportación temporal como entorno (`collab-export`)

---

## 🛠️ Estado actual

✅ Esqueleto técnico listo  
✅ Funciones base definidas  
🟡 Falta validación de claves y control de confianza  
🟡 Falta documentación extendida y ejemplos YAML  
🟡 Falta integración con `.bashflowrc` para `VAULT_GROUP_ID`

---

## 🧑‍🤝‍🧑 Invitación a colaborar

Este módulo está en fase de diseño comunitario. Si deseas contribuir, revisa esta guía, propone mejoras o abre una discusión en el repositorio. La colaboración segura entre equipos es clave para escalar BashFlow en entornos reales.
