# 📚 Documentación de BashFlow

Bienvenido a la documentación oficial de **BashFlow**, el sistema de automatización declarativa en Bash. Aquí encontrarás toda la información técnica, organizativa y comunitaria para trabajar, extender y contribuir al proyecto.

---

## 🧭 Introducción

- [Qué es BashFlow](what-is-bashflow.md)
- [Filosofía y objetivos](./phylosophy_and_goals.md)
- [Primeros pasos](getting_started.md)
- [Instalación automatizada](getting_started.md#instalación-automatizada-con-installsh)


## ⚙️ Inventario

- [`hosts.yaml`](inventory/hosts.md) — definición de hosts y grupos
- [`groups.yaml`](inventory/groups.md) — metadatos y etiquetas
- [`vars/`](inventory/vars.md) — variables globales, por grupo y por host

## 📦 Módulos disponibles

- [`facts`](modules/facts.md) — inventario del sistema
- [`setup`](modules/setup.md) — configuración base
- [`ntp`](modules/ntp.md) — sincronización horaria
- [`vault`](modules/vault.md) — gestión de secretos
- [`users`](modules/users.md) — gestión de usuarios
- [`packages`](modules/packages.md) — instalación de paquetes
- *(más módulos en desarrollo)*

## 📜 Ejecución

- [`bashflow.sh`](execution/bashflow.md) — motor principal
- Argumentos y flags (`-h`, `-g`, `--debug`)
- Playbooks YAML
- Salida y trazabilidad

## 🧪 Depuración y validación

- Modo debug
- Validación de inventario
- Limpieza de claves y valores

## 🧠 Changelogs

- [`bashflow.sh`](changelog/bashflow.md)
- [`facts.sh`](changelog/facts.md)
- *(otros módulos en evolución)*

## 📁 Ejemplos y casos de uso

- Auditoría de hardware
- Configuración de red
- Inventario distribuido

## 🤝 Contribuir al proyecto

Consulta la sección [`CONTRIBUTING`](contributing.md) para aprender cómo colaborar:

- Flujo de trabajo con Git
- Estilo de código y documentación
- Creación de nuevos módulos
- Propuestas de mejora y revisión

---

---

# 📚 BashFlow Documentation

Welcome to the official documentation for **BashFlow**, the declarative automation system in Bash. Here you'll find all technical, organizational and community information to work with, extend and contribute to the project.

---

## 🧭 Introduction

- [What is BashFlow](what-is-bashflow.md)
- [Philosophy and goals](./phylosophy_and_goals.md)
- [Getting Started](getting_started.md)
- [Automated Setup](getting_started.md#instalación-automatizada-con-installsh)


## ⚙️ Inventory

- [`hosts.yaml`](inventory/hosts.md) — host and group definitions
- [`groups.yaml`](inventory/groups.md) — metadata and tags
- [`vars/`](inventory/vars.md) — global, group and host variables

## 📦 Available Modules

- [`facts`](modules/facts.md) — system inventory
- [`setup`](modules/setup.md) — base configuration
- [`ntp`](modules/ntp.md) — time sync
- [`vault`](modules/vault.md) — secrets management
- [`users`](modules/users.md) — user management
- [`packages`](modules/packages.md) — package installation
- *(more modules in progress)*

## 📜 Execution

- [`bashflow.sh`](execution/bashflow.md) — main engine
- Arguments and flags (`-h`, `-g`, `--debug`)
- YAML playbooks
- Output and traceability

## 🧪 Debugging and Validation

- Debug mode
- Inventory validation
- Key and value sanitization

## 🧠 Changelogs

- [`bashflow.sh`](changelog/bashflow.md)
- [`facts.sh`](changelog/facts.md)
- *(other evolving modules)*

## 📁 Examples and Use Cases

- Hardware audit
- Network configuration
- Distributed inventory

## 🤝 Contributing to the Project

Check the [`CONTRIBUTING`](contributing.md) section to learn how to collaborate:

- Git workflow
- Code and documentation style
- Creating new modules
- Improvement proposals and review

