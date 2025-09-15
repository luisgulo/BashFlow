
## 📘 BashFlow – Quickstart Guide

**Author: Luis GuLo**  
**Version: 1.0**  
**Última actualización: 2025-09-15**

---

### 🚀 ¿Qué es BashFlow?

BashFlow es un framework modular en Bash para automatizar tareas en sistemas Linux de forma idempotente, extensible y legible. Está diseñado para sysadmins, desarrolladores y entusiastas del shell que valoran la simplicidad, la claridad y el control.

---

### 📦 Requisitos

- Bash 4+
- `ssh`, `scp`, `git`, `docker`, `gpg`, `curl`, `tar`
- Acceso a hosts remotos vía SSH
- Clave simétrica para el vault (`~/.bashflow.key`)

---

### 📁 Instalación

```bash
git clone https://github.com/luisgulo/bashflow.git
cd bashflow
chmod +x bashflow.sh vault.sh
```

Opcional: crea tu clave para el vault

```bash
echo "clave-secreta" > ~/.bashflow.key
chmod 600 ~/.bashflow.key
```

---

### 🧪 Primer playbook

Crea un archivo `play.yaml` con el siguiente contenido:

```yaml
tasks:
  - name: Crear directorio temporal
    module: file
    args:
      path: "/tmp/bashflow"
      state: present
      type: directory
      mode: "0755"
      become: true

  - name: Mostrar fecha en remoto
    module: run
    args:
      command: "date"
      become: false
```

Ejecuta el playbook:

```bash
./bashflow.sh -f play.yaml -h usuario@host
```

---

### 🔐 Vault opcional

Añade un secreto:

```bash
./vault.sh add api_token
```

Usa el secreto en un playbook:

```yaml
  - name: Acceder a API
    module: run
    args:
      command: "curl -H \"Authorization: Bearer \$TOKEN\" https://api.example.com"
      vault_key: "api_token"
```

---

### 📚 ¿Y ahora qué?

- Explora los módulos en `core/modules/`
- Revisa los ejemplos en `core/examples/`
- Consulta la documentación en `core/docs/`
- Crea tus propios módulos en `user_modules/`

---

¿Quieres que sigamos con `modules.md` y preparemos una tabla de referencia por módulo con argumentos, estado y ejemplos YAML? Esto ya está listo para onboarding real.