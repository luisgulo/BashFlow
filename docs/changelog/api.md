# 📜 Changelog — `api.sh`

Este documento registra los cambios realizados en el módulo `api.sh`, diseñado como cliente declarativo para APIs REST y SOAP dentro de BashFlow.

This document records changes made to the `api.sh` module, designed as a declarative client for REST and SOAP APIs within BashFlow.

---

## 🇪🇸 Historial de versiones

### 🧩 v1.0 — [2025-09-18]
- Creación inicial del módulo `api.sh`
- Soporte para métodos HTTP: `GET`, `POST`, `PUT`, `DELETE`
- Soporte preliminar para llamadas SOAP
- Argumentos soportados:
  - `url`: destino de la llamada
  - `method`: método HTTP (en minúsculas)
  - `headers`: lista separada por comas
  - `body`: contenido del mensaje
  - `output`: ruta para guardar la respuesta
  - `parse`: modo de análisis (`json`, `xml`, `raw`)
- Uso de `curl` para la llamada principal
- Parseo opcional con `jq` o `xmllint`
- Mensajes de trazabilidad (`🌐`, `💾`, `⚠️`)
- Función `check_dependencies_api` para validar herramientas locales

---

## 🇬🇧 Version History

### 🧩 v1.0 — [2025-09-18]
- Initial creation of `api.sh` module  
- Support for HTTP methods: `GET`, `POST`, `PUT`, `DELETE`  
- Preliminary support for SOAP calls  
- Supported arguments:
  - `url`: target endpoint
  - `method`: HTTP method (lowercase)
  - `headers`: comma-separated list
  - `body`: message content
  - `output`: path to save response
  - `parse`: parsing mode (`json`, `xml`, `raw`)
- Uses `curl` for main request
- Optional parsing with `jq` or `xmllint`
- Trace messages (`🌐`, `💾`, `⚠️`)
- `check_dependencies_api` function to validate local tools
