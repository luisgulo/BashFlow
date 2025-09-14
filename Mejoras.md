BashFlow tiene que ser una herramienta **shell-native pero moderna**, capaz de cubrir desde administración básica hasta despliegues más complejos. 

Hay que consolidar el núcleo con más módulos y definir cómo se estructuran para facilitar su evolución.

---

## 🧱 Módulos Core Confirmados para BashFlow v1.0

| Módulo     | Función principal                                      | Estado inicial | Expansión futura |
|------------|--------------------------------------------------------|----------------|------------------|
| `run`      | Ejecutar comandos remotos vía SSH                      | ✅ Hecho        | —                |
| `copy`     | Transferir archivos con `scp`                          | ✅ Hecho        | —                |
| `service`  | Controlar servicios con `systemctl`                    | ✅ Hecho        | —                |
| `package`  | Instalar/actualizar paquetes `.deb` con `apt`         | 🔧 En diseño    | `rpm`, `dnf`, `yum` |
| `docker`   | Ejecutar y gestionar contenedores                      | 🔧 Por hacer    | Compose, imágenes |
| `git`      | Clonar, actualizar y gestionar repositorios Git       | 🔧 Por hacer    | SSH keys, tags   |
| `mount`    | Montar volúmenes y sistemas de archivos                | 🔧 Por hacer    | Fstab, persistencia |
| `file`     | Crear/eliminar archivos y directorios, permisos       | 🔧 Por hacer    | Propietario, contenido |
| `user`     | Crear/eliminar usuarios y grupos                       | 🔧 Por hacer    | Passwords, sudo  |
| `cron`     | Gestionar tareas programadas                          | 🔧 Por hacer    | Crontabs por usuario |
| `template` | Copiar archivos con sustitución de variables          | 🔧 Por hacer    | Variables globales |
| `hostname` | Configurar nombre del host                             | 🔧 Por hacer    | Validación       |
| `sysctl`   | Ajustar parámetros del kernel                          | 🔧 Por hacer    | Persistencia     |

---

## 🧠 Sobre el módulo `package`

Para mantenerlo agnóstico, lo diseñaremos con una **interfaz común** y una **implementación específica por sistema**. Por ejemplo:

```yaml
tasks:
  - name: Instalar nginx
    module: package
    args:
      name: nginx
      state: present
      become: true
```

Y en el módulo:

```bash
detect_package_manager() {
  if command -v apt &> /dev/null; then
    echo "apt"
  elif command -v dnf &> /dev/null; then
    echo "dnf"
  elif command -v yum &> /dev/null; then
    echo "yum"
  elif command -v rpm &> /dev/null; then
    echo "rpm"
  else
    echo "unknown"
  fi
}
```

Esto nos permite empezar con `apt` y extender sin romper compatibilidad.

---

## Inicio de `package`

Vamos a partir con un diseño de módulo `package.sh` con soporte inicial para `.deb` y detección de gestor. 
Luego vamos a definir cómo se maneja la idempotencia (por ejemplo, verificar si el paquete ya está instalado antes de ejecutar).


---

Ampliamos estructura directorios de `core`

```bash
...
├── core/
│   ├── modules/               # Módulos oficiales del núcleo
│   ├── examples/              # Playbooks YAML de ejemplo
│   ├── docs/                  # Documentación técnica y de uso
│   ├── templates/             # Archivos base para módulos, config, etc.
│   └── utils/                 # Funciones comunes (logging, validación, etc.)
...
```

Contenido de estos nuevos directorios:
* examples/: ayuda a nuevos usuarios a entender cómo escribir playbooks. Ideal para incluir casos reales y edge cases.
* docs/: guía de instalación, uso, desarrollo de módulos, estructura YAML, convenciones, etc.
* templates/: base para crear nuevos módulos (module_template.sh), encabezados estándar, ejemplos de documentación.
* utils/: funciones compartidas como detect_package_manager, log_info, log_error, validación de argumentos, etc.

directorios extras....

* tests/: para pruebas unitarias o de integración de módulos
* assets/: si en algún momento incluimos imágenes, diagramas o logos
* config/: para definir variables globales, rutas, o comportamiento por defecto


