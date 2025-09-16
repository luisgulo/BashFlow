# 📦 Changelog

🇪🇸

Todas las versiones importantes de BashFlow se documentarán aquí. 

Este proyecto sigue el formato [Keep a Changelog](https://keepachangelog.com/es/1.0.0/) y usa [versionado semántico](https://semver.org/lang/es/).

🇬🇧

All significant versions of BashFlow will be documented here.

This project follows the [Keep a Changelog](https://keepachangelog.com/es/1.0.0/) format and uses [semantic versioning](https://semver.org/lang/es/).

---


## [1.2.0] - 2025-09-16

### 🇪🇸 Mejoras en instalación y portabilidad

- Añadido `install.sh` con soporte para instalación global (`/opt/bashflow/`) y local (`~/bashflow/`)
- Detección automática de entorno (`root` vs usuario), exportación de `BASHFLOW_HOME` y creación de symlinks
- Exclusión de `bashflow-logo.svg` e `install.sh` del proceso de copiado

### 🇪🇸 Portabilidad total

- Todos los scripts (`bashflow.sh`, `vault.sh`, `bashflow-doc.sh`, `bashflow-check.sh`) detectan dinámicamente la raíz del proyecto
- Soporte completo para ejecución desde cualquier directorio o vía symlink

### 🇪🇸 Documentación técnica

- `bashflow-doc.sh` actualizado para recorrer módulos desde rutas absolutas
- Extracción de metadatos desde `core/modules`, `user_modules` y `community_modules`

### 🇪🇸 Diagnóstico del entorno

- `bashflow-check.sh` actualizado para validar estructura completa del proyecto desde cualquier ubicación
- Verificación de herramientas globales (`bash`, `ssh`, `git`, `gpg`, etc.) y carga de módulos con chequeo de dependencias

### 🇪🇸 Gestión segura de secretos

- `vault.sh` actualizado para localizar `core/vault` correctamente desde cualquier ruta
- Soporte para cifrado simétrico y asimétrico con claves definidas por entorno

### 🇪🇸 Limpieza y consistencia

- Eliminadas rutas relativas en módulos (`run.sh`, etc.) que impedían ejecución fuera del directorio raíz
- Preparado entorno para consolidar `module-env.sh` como fuente común de rutas

---

### 🇬🇧 Improvements in installation and portability

- Added `install.sh` with support for global (`/opt/bashflow/`) and local (`~/bashflow/`) installation
- Automatic detection of environment (`root` vs user), export of `BASHFLOW_HOME`, and symlink creation
- Excluded `bashflow-logo.svg` and `install.sh` from copy process

### 🇬🇧 Full portability

- All scripts (`bashflow.sh`, `vault.sh`, `bashflow-doc.sh`, `bashflow-check.sh`) now dynamically detect project root
- Fully compatible with execution from any directory or via symlink

### 🇬🇧 Technical documentation

- `bashflow-doc.sh` updated to scan modules using absolute paths
- Metadata extracted from `core/modules`, `user_modules`, and `community_modules`

### 🇬🇧 Environment diagnostics

- `bashflow-check.sh` updated to validate full project structure from any location
- Global tools check (`bash`, `ssh`, `git`, `gpg`, etc.) and module loading with dependency checks

### 🇬🇧 Secure secret management

- `vault.sh` updated to locate `core/vault` correctly from any path
- Support for symmetric and asymmetric encryption with environment-specific keys

### 🇬🇧 Cleanup and consistency

- Removed relative paths in modules (`run.sh`, etc.) that failed outside project root
- Environment prepared to consolidate `module-env.sh` as a shared route resolver


## [v0.9.0-beta] - 2025-09-16

### 🚀 Añadido / Added
🇪🇸
- Estructura modular inicial (`core/`, `community_modules/`)
- Documentación base (`README.md` bilingüe, `CONTRIBUTING.md`)
- Logo oficial inspirado en nautilus (shell + flujo)
- Licencia GPLv3 aplicada para garantizar libertad y control comunitario
- Carpeta `examples/` para playbooks de onboarding
- Preparación de estructura `docs/` para futura documentación bilingüe

🇬🇧
- Initial modular structure (`core/`, `community_modules/`)
- Base documentation (bilingual `README.md`, `CONTRIBUTING.md`)
- Official logo inspired by Nautilus (shell + flow)
- GPLv3 license applied to guarantee freedom and community control
- `examples/` folder for onboarding playbooks
- Preparation of `docs/` structure for future bilingual documentation

### 🧠 Planificado / Planned
🇪🇸
- Activación del sistema de inventario (`inventory/`)
- Primeros módulos funcionales con documentación asociada
- Guía de branding y variantes del logo
- Versión `v1.0.0` estable tras validación comunitaria

🇬🇧
- Inventory system activated (`inventory/`)
- First functional modules with associated documentation
- Branding guide and logo variants
- Stable version `v1.0.0` after community validation

---

## [Unreleased]

🇪🇸 Cambios en desarrollo para la próxima versión.  

🇬🇧 Changes in progress for the next release.
