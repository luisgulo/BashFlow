# 📦 Changelog

🇪🇸  Todas las versiones importantes de BashFlow se documentarán aquí. 

Este proyecto sigue el formato [Keep a Changelog](https://keepachangelog.com/es/1.0.0/) y usa [versionado semántico](https://semver.org/lang/es/).

🇬🇧 All significant versions of BashFlow will be documented here.

This project follows the [Keep a Changelog](https://keepachangelog.com/es/1.0.0/) format and uses [semantic versioning](https://semver.org/lang/es/).

---

## 🌐 api.sh — Versión 1.0

### 🇪🇸 Módulo nuevo
- 🚀 Se incorpora `api.sh` como cliente declarativo para servicios REST y SOAP.
- ✅ Soporte para métodos HTTP: `get`, `post`, `put`, `delete`, y `soap`.
- 🧠 Parseo automático de respuestas en formato `json` (via `jq`) y `xml` (via `xmllint`).
- 📦 Permite definir encabezados personalizados, cuerpo de petición y guardar la respuesta en fichero.
- 🔐 Compatible con autenticación por token y servicios que no permiten acceso por SSH (routers, APIs externas, etc.).

### 🇬🇧 New module
- 🚀 Added `api.sh` as a declarative client for REST and SOAP services.
- ✅ Supports HTTP methods: `get`, `post`, `put`, `delete`, and `soap`.
- 🧠 Automatic response parsing in `json` (via `jq`) and `xml` (via `xmllint`).
- 📦 Allows custom headers, request body, and saving response to file.
- 🔐 Compatible with token-based authentication and non-SSH services (routers, external APIs, etc.).


---

## 🗂️ fs.sh — Versión 1.2

### 🇪🇸 Mejoras añadidas
- 📁 Soporte para múltiples ficheros, comodines (*, ?, [...]) y procesamiento remoto seguro. 

### 🇬🇧 Improvements added
- 📁 Support for multiple files, wildcards (*, ?, [...]) and secure remote processing.

---

## 🗂️ fs.sh — Versión 1.1

### 🇪🇸 Mejoras añadidas
- 📁 Soporte para múltiples ficheros mediante el argumento `files`, separado por comas.
- 🔁 Acciones `move`, `rename`, `copy`, `delete` y `truncate` ahora aceptan listas de ficheros.
- 🧠 Procesamiento seguro y ordenado de cada fichero, con mensajes individuales por operación.
- 🧹 Se mantiene compatibilidad con operaciones unitarias (`src`, `dest`, `path`) para casos simples.

### 🇬🇧 Improvements added
- 📁 Added support for multiple files via the `files` argument (comma-separated).
- 🔁 Actions `move`, `rename`, `copy`, `delete`, and `truncate` now accept file lists.
- 🧠 Safe and structured processing of each file with individual operation feedback.
- 🧹 Maintains compatibility with single-file operations (`src`, `dest`, `path`) for simple use cases.

---

## 🔐 vault.sh — Versión 1.4

### 🇪🇸 Mejoras añadidas
- ✏️ Acción `edit`: permite modificar secretos existentes
- 🗑️ Acción `remove`: elimina secretos del vault
- 👁️ Acción `show`: muestra el contenido descifrado
- ✅ Acción `exists`: verifica si un secreto existe
- 📤 Acción `export`: genera variables de entorno con todos los secretos

### 🇬🇧 New features
- ✏️ `edit` action: modify existing secrets
- 🗑️ `remove` action: delete secrets from vault
- 👁️ `show` action: display decrypted content
- ✅ `exists` action: check if a secret exists
- 📤 `export` action: output all secrets as environment variables


---

## 🔧 install.sh — Versión 1.1

### 🇪🇸 Mejoras añadidas
- 🛡️ Se preserva automáticamente el contenido de `core/vault/` si ya existe, evitando pérdida de secretos o configuraciones personalizadas durante reinstalaciones.
- 📁 Se reorganiza la lógica de borrado para evitar eliminar el vault antes de copiar los nuevos archivos.
- 📦 Se restaura el vault desde `/tmp/bashflow_vault_backup` tras la instalación.
- 🧠 Se mantiene la instalación limpia y segura sin afectar datos sensibles.

### 🇬🇧 Improvements added
- 🛡️ Automatically preserves `core/vault/` content if it exists, preventing loss of secrets or custom configurations during reinstall.
- 📁 Reorganized deletion logic to avoid removing the vault before copying new files.
- 📦 Vault is restored from `/tmp/bashflow_vault_backup` after installation.
- 🧠 Ensures clean and safe installation without affecting sensitive data.


---

## 🔁 loop.sh — Versión 0.2

### 🇪🇸 Mejoras implementadas

- ✅ Soporte para bucles sobre pares `clave:valor`, con acceso a `{{item_key}}` y `{{item_value}}`
- ✅ Implementación de bucle doble cartesiano (`items × secondary`) con `{{secondary_item}}`
- ✅ Reemplazo dinámico de variables en argumentos: `{{item}}`, `{{item_key}}`, `{{item_value}}`, `{{secondary_item}}`
- ⚠️ Nueva opción `fail_fast` para controlar si se detiene ante errores (`true`) o continúa (`false`)
- 📌 Validación básica de argumentos obligatorios (`items`, `module`)
- 🔁 Separación de lógica en función `run_module()` para facilitar extensibilidad
- 📚 Documentación bilingüe actualizada con ejemplos YAML y casos avanzados

### 🇬🇧 Improvements implemented

- ✅ Support for key:value pair loops, with access to `{{item_key}}` and `{{item_value}}`
- ✅ Cartesian double loop (`items × secondary`) with `{{secondary_item}}`
- ✅ Dynamic variable replacement in arguments: `{{item}}`, `{{item_key}}`, `{{item_value}}`, `{{secondary_item}}`
- ⚠️ New `fail_fast` option to control whether execution stops on error (`true`) or continues (`false`)
- 📌 Basic validation of required arguments (`items`, `module`)
- 🔁 Logic refactored into `run_module()` for easier extensibility
- 📚 Bilingual documentation updated with YAML examples and advanced use cases

---

## 📚 Gestión de texto / Text Management — Versión 0.1

### 🇪🇸 Nuevos módulos añadidos

- 🧩 `replace.sh` — Reemplazo de texto mediante expresiones regulares (`regexp`) en archivos. Soporta copia de seguridad (`backup`) y ejecución con privilegios (`become`).
- 🧩 `lineinfile.sh` — Inserta o reemplaza líneas específicas en archivos. Permite asegurar líneas únicas, insertar después de patrones y crear el archivo si no existe.
- 🧩 `blockinfile.sh` — Inserta bloques de texto delimitados (`# BEGIN`, `# END`) en archivos. Reemplaza automáticamente si el bloque ya existe. Soporta marcador personalizado (`marker`) y copia de seguridad.
- 🧩 `template.sh` — Genera archivos a partir de plantillas `.tmpl` ubicadas en `core/templates`, reemplazando variables `{{var}}`. Compatible con `become` y rutas absolutas.
- 🧩 `loop.sh` (v0.2) — Ejecuta módulos en bucle sobre listas simples, pares `clave:valor` y combinaciones dobles (`items × secondary`). Incluye reemplazo dinámico (`{{item}}`, `{{item_key}}`, `{{item_value}}`, `{{secondary_item}}`) y opción `fail_fast`.

### 🇬🇧 New modules added

- 🧩 `replace.sh` — Text replacement using regular expressions (`regexp`) in files. Supports backup and privilege escalation (`become`).
- 🧩 `lineinfile.sh` — Ensures or replaces specific lines in files. Allows inserting after patterns and creating the file if missing.
- 🧩 `blockinfile.sh` — Inserts delimited text blocks (`# BEGIN`, `# END`) in files. Automatically replaces existing blocks. Supports custom markers and backup.
- 🧩 `template.sh` — Generates files from `.tmpl` templates located in `core/templates`, replacing `{{var}}` placeholders. Supports `become` and absolute paths.
- 🧩 `loop.sh` (v0.2) — Executes modules in loop over simple lists, `key:value` pairs, and double combinations (`items × secondary`). Includes dynamic replacement and `fail_fast` control.


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

---

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
