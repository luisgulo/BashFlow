# 🚀 Primeros pasos con BashFlow

Esta guía te ayudará a instalar BashFlow, configurar un inventario mínimo y ejecutar tu primer playbook para obtener información de un equipo remoto usando el módulo `facts`.

---

## 🧭 Requisitos

- Linux con Bash ≥ 4.4
- `yq` y `jq` instalados
- Acceso SSH a los hosts definidos
- Git (para clonar el proyecto)

---

## 📦 Instalación

```bash
git clone https://github.com/luisgulo/bashflow.git
cd bashflow
chmod +x bashflow.sh
```

---

## 🗂️ Inventario mínimo

Crea el archivo `core/inventory/hosts.yaml`:

```yaml
all:
  hosts:
    mi_equipo:
      ansible_host: 192.168.1.100
      label: Equipo de pruebas
```

---

## 📄 Playbook básico

Crea el archivo `facts_test.yaml`:

```yaml
tasks:
  - name: Inventario del sistema
    module: facts
    args:
      format: md
      output: "/tmp/informe_{{ name }}.md"
      host_label: "{{ label }}"
```

---

## ▶️ Ejecución

```bash
./bashflow.sh -f facts_test.yaml -h mi_equipo --debug
```

Esto generará un informe en `/tmp/informe_mi_equipo.md` con datos del sistema remoto.

---

## ✅ Resultado esperado

- Conexión SSH establecida
- Trazas limpias en consola
- Informe Markdown con CPU, RAM, OS, particiones, red…

---

## 📚 ¿Y ahora qué?

- Explora otros módulos en `docs/modules/`
- Crea grupos en el inventario
- Usa `vars/` para definir configuración global

---

## ⚙️ Instalación automatizada con `install.sh`

BashFlow incluye un script de instalación que prepara la estructura base del proyecto, crea los directorios necesarios y configura el entorno para que puedas usar los comandos desde **cualquier terminal**, sin importar la ruta.

### 🧩 ¿Qué hace `install.sh`?

- Detecta si la instalación es **global** (`/opt/bashflow`) o **local** (`$HOME/bashflow`)
- Crea las rutas estándar: `core/modules/`, `core/inventory/`, `docs/`, etc.
- Copia los archivos base del proyecto
- **Preserva** rutas sensibles como `vault`, `inventory` y `user_modules` si ya existen
- Crea **symlinks** en el `PATH` (`bashflow`, `bashflow-doc`, `bashflow-check`, etc.)
- Añade `BASHFLOW_HOME` y el `PATH` al `.bashrc` o `.zshrc` del usuario

### ▶️ Ejecución

```bash
./install.sh
```

Una vez completado, puedes ejecutar BashFlow desde cualquier terminal:

```bash
bashflow -f facts_test.yaml -h mi_equipo
```

No necesitas estar en el directorio del proyecto.

---


# 🚀 Getting Started with BashFlow

This guide will help you install BashFlow, set up a minimal inventory, and run your first playbook to gather system information using the `facts` module.

---

## 🧭 Requirements

- Linux with Bash ≥ 4.4  
- `yq` and `jq` installed  
- SSH access to defined hosts  
- Git (to clone the project)  

---

## 📦 Installation

```bash
git clone https://github.com/<user>/bashflow.git
cd bashflow
chmod +x bashflow.sh
```

---

## 🗂️ Minimal Inventory

Create the file `core/inventory/hosts.yaml`:

```yaml
all:
  hosts:
    my_machine:
      ansible_host: 192.168.1.100
      label: Test machine
```

---

## 📄 Basic Playbook

Create the file `facts_test.yaml`:

```yaml
tasks:
  - name: System Inventory
    module: facts
    args:
      format: md
      output: "/tmp/report_{{ name }}.md"
      host_label: "{{ label }}"
```

---

## ▶️ Execution

```bash
./bashflow.sh -f facts_test.yaml -h my_machine --debug
```

This will generate a Markdown report in `/tmp/report_my_machine.md` with remote system data.

---

## ✅ Expected Result

- SSH connection established  
- Clean console traces  
- Markdown report with CPU, RAM, OS, partitions, network…  

---

## 📚 What’s next?

- Explore other modules in `docs/modules/`  
- Create groups in your inventory  
- Use `vars/` to define global configuration  


---

# ⚙️ Automated Installation with `install.sh`

BashFlow includes an installation script that sets up the base project structure, creates required directories, and configures the environment so you can use commands from **any terminal**, regardless of your current path.

### 🧩 What does `install.sh` do?

- Detects whether the installation is **global** (`/opt/bashflow`) or **local** (`$HOME/bashflow`)  
- Creates standard paths: `core/modules/`, `core/inventory/`, `docs/`, etc.  
- Copies base project files  
- **Preserves** sensitive paths like `vault`, `inventory`, and `user_modules` if they already exist  
- Creates **symlinks** in your `PATH` (`bashflow`, `bashflow-doc`, `bashflow-check`, etc.)  
- Adds `BASHFLOW_HOME` and `PATH` to your `.bashrc` or `.zshrc`  

### ▶️ Execution

```bash
./install.sh
```

Once completed, you can run BashFlow from any terminal:

```bash
bashflow -f facts_test.yaml -h my_machine
```

You don’t need to be inside the project directory.
