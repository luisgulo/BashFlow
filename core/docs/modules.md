
# 🧩 Módulos en BashFlow

**Autor:** Luis GuLo  
**Versión:** 1.0  
**Última actualización:** 2025-09-16

---

## 🔍 ¿Qué es un módulo?

Un módulo en BashFlow es un script Bash que implementa una función `<nombre>_task()` que puede ser invocada desde un playbook YAML. Los módulos encapsulan lógica reutilizable, idempotente y extensible para tareas como despliegue, sincronización, cifrado, documentación, etc.

---

## 📁 Estructura de módulos

- `core/modules/`: módulos oficiales mantenidos por BashFlow
- `community_modules/`: módulos aportados por la comunidad
- `user_modules/`: módulos personalizados del usuario

Cada módulo debe incluir:

```bash
# Module: <nombre>
# Description: <descripción breve>
# Author: Luis GuLo
# Version: x.y
# Dependencies: <herramientas externas si aplica>
```

---

## 🧪 Convención de funciones

- `nombre_task(host, args...)`: función principal invocada por BashFlow
- `check_dependencies_nombre()`: función opcional para validar herramientas necesarias

---

## 🧾 Ejemplo de módulo simple: `ping.sh`

```bash
#!/bin/bash
# Module: ping
# Description: Verifica conectividad con el host
# Author: Luis GuLo
# Version: 1.0

ping_task() {
  local host="$1"; shift
  echo "📡 Probando conectividad con $host..."
  ping -c 2 "$host" &>/dev/null && echo "✅ $host está accesible" || echo "❌ $host no responde"
}
```

---

## 📦 Módulos oficiales

| Módulo         | Descripción                                      | Archivo                    |
|----------------|--------------------------------------------------|----------------------------|
| `vault`        | Gestión de secretos cifrados                     | `core/modules/vault.sh`    |
| `vault-remote` | Sincronización de secretos entre hosts           | `core/modules/vault-remote.sh` |
| `docgen`       | Generación automática de documentación           | `core/modules/docgen.sh`   |
| `ping`         | Verificación de conectividad                     | `core/modules/ping.sh`     |

---

## 🧩 Argumentos en YAML

Los argumentos se pasan como `clave: valor` y se transforman en `clave=valor` para el módulo:

```yaml
tasks:
  - name: Verificar conectividad
    module: ping
    args:
      timeout: 5
```

---

## 🧠 Buenas prácticas

- Usa nombres descriptivos y consistentes
- Documenta dependencias y ejemplos de uso
- Mantén la idempotencia: no repitas acciones si ya están hechas
- Usa `check_dependencies_<modulo>` para validar herramientas externas
- Incluye `Author: Luis GuLo` en todos los módulos oficiales

---

## 📚 Documentación relacionada

- [`vault.md`](vault.md): gestión de secretos cifrados
- [`vault-collab.md`](vault-collab.md): colaboración con claves públicas
- [`install.md`](install.md): instalación del framework
- [`bashflow-check.sh`](../bashflow-check.sh): verificación de entorno y módulos

