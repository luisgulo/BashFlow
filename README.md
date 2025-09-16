# BashFlow – *Automatización ligera y extensible con Bash*

## BashFlow. Idea y el Porqué

La automatización mediante procesos bash es uno de los primeros conceptos existentes en la historia de los servidores.
El proceso se ha intentado mejorar usando las ventajas de los nuevos lenguajes de programación, como es Python y se ha "encapsulado" en un nuevo paradigma de la automatización **Ansible** que parece ser es el que se está convirtiendo en un estandar.

Sin embargo usando Ansible, que depende totalmente de Python hay que pelear con el problema de dependencias e incompatibilidad entre los módulos de python y sus versiones, tanto en el servidor que ejecuta la automatización, como con la versiones de Python de los servidores administrados.

Mi propuesta es crear una herramienta de automatización inspirada en Ansible pero basada en Bash. Esta solución tiene mucho sentido si lo que buscas es simplicidad, portabilidad y evitar el infierno de dependencias de Python. 

Bash es ubicuo, ligero y muy estable en entornos Unix-like. 

Mi propuesta, es un proyecto que he denominado `BashFlow`.
El nombre lo he elegido por las siguiente razones, suena moderno, ágil y transmite justo lo que queremos: flujo de automatización con Bash, sin complicaciones. 
Un nombre que hace referencia a una herramienta profesional pero accesible, y además es fácil de recordar y pronunciar en cualquier idioma.


## BashFlow. Diseño Base y Punto de partida

La idea inicial es incorporar una sintaxis tipo YAML en BashFlow.
Permitimos que los usuarios actuales de Ansible se sientan en terreno familiar, se facilita la lectura declarativa de tareas, y mantiene la flexibilidad de Bash como motor de ejecución. 


Ejemplo inicial de un `playbook` en formato YAML para BashFlow:

```
hosts:
  - web01
  - web02

tasks:
  - name: Instalar nginx
    run: "apt-get update && apt-get install -y nginx"
    become: true

  - name: Copiar archivo de configuración
    copy:
      src: "./nginx.conf"
      dest: "/etc/nginx/nginx.conf"
      mode: "0644"

  - name: Reiniciar nginx
    run: "systemctl restart nginx"

```

### Interpretación por BashFlow

La idea es usar `yq` como parser, ya que permite:

* Leer el YAML
* Iterar sobre los hosts
* Ejecutar cada task según su tipo (run, copy, etc.)
* Usar ssh para conectarse y ejecutar comandos
* Aplicar sudo si become: true

El proyecto lo he pensando en que disponga de extensibilidad desde el inicio, para darle a BashFlow una proyección de comunidad y evolución potente. 

Creo que lo ideal es `yq` como parser nos permite mantener la sintaxis YAML sin complicarse con Bash puro.
Además de poder crear o incorporar módulos como opción clave para que otros usuarios puedan aportar sin romper la base de bashflow.

### Tipos de tareas soportadas

| Tipo |	Acción en BashFlow |
|------|-----------------------|    
| `run` |	Ejecuta comandos remotos vía SSH |
| `copy` |	Usa scp para transferir archivos |
| `template` |	Sustituye variables y copia archivo |
| `file` |	Crea/elimina/modifica permisos |
| `service` |	Inicia/detiene/reinicia servicios |

### Ventajas de BashFlow

* Familiar para usuarios de Ansible
* Legible y estructurado
* Fácil de versionar y auditar
* Compatible con Bash puro si se desea


## Diseño de módulos en BashFlow

### Estructura propuesta


```bash
bashflow/
├── core/
│   ├── modules/               # Módulos oficiales del núcleo
│   ├── examples/              # Playbooks YAML de ejemplo
│   ├── docs/                  # Documentación técnica y de uso
│   ├── templates/             # Archivos base para módulos, config, etc.
│   ├── inventory/
│   ├────── hosts.yaml         # Inventario principal
│   ├────── groups.yaml        # Definición de grupos (opcional)
│   ├────── vars/              # Variables por host o grupo
│   │       ├── web.yaml
│   │       └── db.yaml
│   └── utils/                 # Funciones comunes (logging, validación, etc.)
├── user_modules/              # Módulos personalizados del usuario
│   └── my_custom_module.sh
├── community_modules/         # Módulos compartidos por la comunidad
│   └── awesome_module.sh
├── bashflow.sh                # Script controlador principal
├── bashflow-doc.sh            # Generador de documentación
├── bashflow-check.sh          # Verificador de entorno y dependencias
└── README.md                  # Introducción al proyecto

```



### Convención para módulos

Cada módulo es un script Bash que implementa una función con nombre estándar, por ejemplo:

```bash
# modules/run.sh
run_task() {
  local host="$1"
  local command="$2"
  ssh "$host" "$command"
}
```

El controlador principal (`bashflow.sh`) puede cargar dinámicamente los módulos:

```bash
load_modules() {
  for dir in core/modules user_modules third_party_modules; do
    for mod in "$dir"/*.sh; do
      [ -f "$mod" ] && source "$mod"
    done
  done
}
```


### YAML con tipo de módulo

```yaml
tasks:
  - name: Reiniciar nginx
    module: service
    args:
      name: nginx
      state: restarted
```

El parser usaría `yq` y extraería `module: service` y luego llamaría a `service_task` con los argumentos.


## Ventajas de este enfoque

- **Plug & Play**: Cualquier usuario puede añadir su módulo sin tocar el núcleo
- **Separación limpia**: Núcleo, Usuario y Comunidad bien diferenciados
- **Seguridad**: Se pueden validar módulos antes de cargarlos
- **Comunidad**: Es fácil compartir módulos en GitHub, Gists, etc.


La idea es un diseño con visión hacia el futuro de la herramienta: modular, documentado, y robusto. 


## 1. Plantilla estándar para módulos

Todos los módulos deberían seguir una estructura clara para facilitar mantenimiento, extensibilidad y documentación. 

Ejemplo de plantilla que se propone:

```bash
#!/bin/bash
# Module: service
# Description: Controla servicios del sistema (start, stop, restart)
# Author: Luis GuLo
# Version: 1.0
# Dependencies: systemctl, ssh
# Usage:
#   service_task "$host" "$name" "$state"

service_task() {
  local host="$1"
  local name="$2"
  local state="$3"
  ssh "$host" "sudo systemctl $state $name"
}
```

### Convenciones de uso y sintaxis

- Encabezado con metadatos (`Module`, `Description`, `Author`, etc.)
- Función principal con nombre estándar (`<module>_task`)
- Uso de variables bien definidas
- Comentarios claros para cada paso


## 2. Sistema de documentación autocontenida

Se va a necesitar de una herramienta, que vamos a llamar `bashflow-doc` que será la encargada de escanear todos los módulos y generar una documentación automática en consola o en formato Markdown:

```bash
bashflow-doc core/modules/ user_modules/ third_party_modules/
```

### ¿Qué hace?
- Extrae encabezados de cada módulo.
- Lista el nombre, descripción, autor, versión y dependencias.
- Opcional: genera un índice navegable.

Ejemplo de salida:

```
📦 Module: service
🔧 Description: Controla servicios del sistema
👤 Author: Luis GuLo
📌 Version: 1.0
📎 Dependencies: systemctl, ssh
```

---

## 3. Herramienta para revisar dependencias

Podemos incluir un script llamado `bashflow-check` que revise:

- Si las herramientas necesarias (`ssh`, `scp`, `systemctl`, etc.) están disponibles
- Si `yq` está instalado y en la versión recomendada
- Si los módulos declaran dependencias no satisfechas

### Ejemplo de uso:

```bash
bashflow-check
```

### Salida esperada:

```
✅ ssh: OK
✅ scp: OK
⚠️  yq: No encontrado
⚠️  systemctl: No disponible en este sistema
```

Incluso se puede incluir en cada módulo una función `check_dependencies()` opcional que se ejecute al cargarlo.

El script `bashflow-check` puede invocar `check_dependencies_<module>` para cada módulo cargado. Así detectamos problemas antes de ejecutar tareas.

---

## BashFlow v0.1 (Diseño Base)

###  Nombre del proyecto

**BashFlow** – Automatización ligera y extensible con Bash

### Componentes definidos
- Sintaxis YAML con `yq` como parser
- Módulos Bash con plantilla estándar
- Sistema de documentación autocontenida (`bashflow-doc`)
- Herramienta de verificación de dependencias (`bashflow-check`)
- Estructura modular: núcleo, usuario, comunidad

### módulos implementados

> Todos los módulos incluyen la función `check_dependencies_run`

- `run.sh`: Ejecuta comandos remotos vía SSH
- `copy.sh`: Copia archivos locales al host remoto usando scp
- `service.sh`: Controla servicios del sistema remoto (start, stop, restart, enable, disable) con idempotencia

### Convenciones establecidas
- Funciones con nombre `<modulo>_task`
- Encabezado con metadatos en cada módulo
- Carga dinámica de módulos desde rutas definidas


### Ejemplos de YAML usando los módulos `core`


* Usamos modulo `run`:

```yaml
hosts:
  - web01.example.com
  - web02.example.com

tasks:
  - name: Actualizar paquetes
    module: run
    args:
      command: "apt-get update"
      become: true

  - name: Crear directorio temporal
    module: run
    args:
      command: "mkdir -p /tmp/bashflow"
      become: false

  - name: Mostrar versión de nginx
    module: run
    args:
      command: "nginx -v"
      become: false
```

* Usamos módulo `copy`:

```yaml
tasks:
  - name: Copiar archivo de configuración
    module: copy
    args:
      src: "./nginx.conf"
      dest: "/etc/nginx/nginx.conf"
      mode: "0644"
      become: true
```

* Usamos modulo `service`:
```yaml
tasks:
  - name: Activar nginx al iniciar
    module: service
    args:
      name: nginx
      action: enable
      become: true

  - name: Detener apache si está activo
    module: service
    args:
      name: apache2
      action: stop
      become: true

```


La versión actual de `bashflow.sh` permite:

* Validar dependencias (yq, ssh, etc.)
* Cargar módulos desde core, user_modules, community_modules
* Parsear YAML usando yq
* Iterar sobre hosts y tareas
* Ejecutar el módulo correspondiente
* Registrar logs y errores


---

**Próximos pasos y mejoras**

* General
    - Definir sistema de logging por host/tarea
    - Crear `bashflow.sh` como controlador principal
    - Diseñar estructura de playbook YAML completa
    - Documentar cómo crear y registrar nuevos módulos

* bashflow:
    - Logging por host/tarea
    - Modo --check para simulación
    - Soporte para variables globales
    - Control de errores por módulo
    - Paralelismo opcional

* bashflow-doc:
    - Exportar a Markdown o HTML
    - Validar que todos los campos estén presentes
    - Mostrar ejemplos de uso si están documentados
    - Permitir filtrar por tipo de módulo o autor

* bashflow-check:
    - Modo --strict para abortar si hay errores
    - Exportar reporte en JSON o Markdown
    - Verificar conectividad SSH a hosts definidos en un playbook
    - Validar sintaxis YAML antes de ejecutar

