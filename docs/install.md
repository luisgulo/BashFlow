# 🛠️ Instalación de BashFlow / BashFlow Installation Guide

---

## 🇪🇸 Instalación

### 🔧 Requisitos previos

- Bash ≥ 4.0
- Herramientas: `git`, `curl`, `jq`, `yq`, `gpg`
- Sistema compatible: Linux, macOS, WSL

### 📦 Opciones de instalación

#### 1. Instalación global (requiere root)

```bash
sudo bash install.sh
```

Instala BashFlow en `/opt/bashflow/` y crea accesos directos en `/usr/local/bin/`.

#### 2. Instalación local (usuario)

```bash
bash install.sh
```

Instala BashFlow en `~/bashflow/` y crea accesos directos en `~/.local/bin/`.

### 🧠 Activar entorno

Agrega estas líneas a tu `.bashrc` o `.zshrc` si no se añadieron automáticamente:

```bash
export BASHFLOW_HOME="$HOME/bashflow"
export PATH="$PATH:$HOME/.local/bin"
```

Luego ejecuta:

```bash
source ~/.bashrc   # o source ~/.zshrc
```

---

## 🇬🇧 Installation

### 🔧 Prerequisites

- Bash ≥ 4.0
- Tools: `git`, `curl`, `jq`, `yq`, `gpg`
- Compatible systems: Linux, macOS, WSL

### 📦 Installation options

#### 1. Global installation (requires root)

```bash
sudo bash install.sh
```

Installs BashFlow in `/opt/bashflow/` and creates symlinks in `/usr/local/bin/`.

#### 2. Local installation (user)

```bash
bash install.sh
```

Installs BashFlow in `~/bashflow/` and creates symlinks in `~/.local/bin/`.

### 🧠 Activate environment

Add the following lines to your `.bashrc` or `.zshrc` if not added automatically:

```bash
export BASHFLOW_HOME="$HOME/bashflow"
export PATH="$PATH:$HOME/.local/bin"
```

Then run:

```bash
source ~/.bashrc   # or source ~/.zshrc
```

---

## 📎 Verificación / Verification

```bash
bashflow version
bashflow-check
```

---

## 📚 Más información / More info

- `bashflow.sh`: CLI principal
- `vault.sh`: gestión segura de secretos
- `bashflow-doc.sh`: documentación técnica de módulos
- `bashflow-check.sh`: verificación de entorno

