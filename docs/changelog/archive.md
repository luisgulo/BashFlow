# 📜 Changelog — `archive.sh`

Este documento registra los cambios realizados en el módulo `archive.sh`, diseñado para comprimir, descomprimir y extraer archivos en remoto mediante BashFlow.

This document records changes made to the `archive.sh` module, which is designed to compress, decompress, and extract files remotely using BashFlow.

---

## 🇪🇸 Historial de versiones

### 🧩 v1.0 — [2025-09-18]
- Creación inicial del módulo `archive.sh`
- Soporte para acciones: `compress`, `decompress`, `extract`
- Formatos soportados:
  - `tar`, `zip`, `gzip`, `bzip2`
- Argumentos disponibles:
  - `action`: tipo de operación (`compress`, `decompress`, `extract`)
  - `format`: formato de archivo (`tar`, `zip`, etc.)
  - `files`: lista de archivos a comprimir (separados por coma)
  - `archive`: ruta del archivo comprimido
  - `output`: destino del archivo generado
  - `dest`: carpeta de extracción
  - `become`: uso opcional de `sudo`
- Ejecución remota vía `ssh`
- Mensajes de trazabilidad (`📦`, `📂`, `❌`)
- Validación de dependencias locales con `check_dependencies_archive`

---

## 🇬🇧 Version History

### 🧩 v1.0 — [2025-09-18]
- Initial creation of `archive.sh` module  
- Supported actions: `compress`, `decompress`, `extract`  
- Supported formats:
  - `tar`, `zip`, `gzip`, `bzip2`
- Available arguments:
  - `action`: operation type (`compress`, `decompress`, `extract`)
  - `format`: archive format (`tar`, `zip`, etc.)
  - `files`: comma-separated list of files to compress
  - `archive`: path to the archive file
  - `output`: destination for generated archive
  - `dest`: extraction folder
  - `become`: optional use of `sudo`
- Remote execution via `ssh`
- Trace messages (`📦`, `📂`, `❌`)
- Local dependency check via `check_dependencies_archive`
