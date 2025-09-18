# 🌐 Módulo: api

## 🇪🇸 Descripción

El módulo `api` permite realizar llamadas HTTP y SOAP de forma declarativa desde BashFlow. Es útil para integraciones con servicios externos, validaciones remotas, notificaciones o consultas a endpoints RESTful.

Soporta los métodos `GET`, `POST`, `PUT`, `DELETE` y llamadas SOAP básicas. Permite definir cabeceras, cuerpo, formato de salida y parseo automático.

---

## 🧩 Argumentos disponibles

| Clave     | Descripción                                                                 |
|-----------|------------------------------------------------------------------------------|
| `url`     | URL del endpoint remoto                                                      |
| `method`  | Método HTTP (`get`, `post`, `put`, `delete`, `soap`)                         |
| `headers` | Lista de cabeceras separadas por comas (`Authorization: Bearer xxx,Content-Type:...`) |
| `body`    | Contenido del mensaje (JSON, XML, texto plano)                              |
| `output`  | Ruta donde guardar la respuesta completa                                     |
| `parse`   | Modo de análisis: `json`, `xml`, `raw`                                       |

---

## ▶️ Ejemplo de uso

```yaml
tasks:
  - name: Consulta de clima
    module: api
    args:
      url: "https://api.weatherapi.com/v1/current.json?key=abc123&q=Madrid"
      method: get
      headers: "Accept: application/json"
      parse: json
```

---

## 🧠 Trazas esperadas (`--debug`)

```bash
🌐 [api] Ejecutando get → https://api.weatherapi.com/v1/current.json?key=abc123&q=Madrid
💾 [api] Respuesta guardada en: /tmp/clima.json
⚠️ [api] No se pudo parsear como JSON
```

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/api.md`](../changelog/api.md)

---

---

# 🌐 Module: api

## 🇬🇧 Description

The `api` module allows declarative HTTP and SOAP calls from BashFlow. It's useful for integrations with external services, remote validations, notifications or queries to RESTful endpoints.

Supports `GET`, `POST`, `PUT`, `DELETE` methods and basic SOAP calls. You can define headers, body, output format and automatic parsing.

---

## 🧩 Available Arguments

| Key       | Description                                                                  |
|-----------|------------------------------------------------------------------------------|
| `url`     | Remote endpoint URL                                                          |
| `method`  | HTTP method (`get`, `post`, `put`, `delete`, `soap`)                         |
| `headers` | Comma-separated list of headers (`Authorization: Bearer xxx,Content-Type:...`) |
| `body`    | Message content (JSON, XML, plain text)                                      |
| `output`  | Path to save full response                                                   |
| `parse`   | Parsing mode: `json`, `xml`, `raw`                                           |

---

## ▶️ Usage Example

```yaml
tasks:
  - name: Weather query
    module: api
    args:
      url: "https://api.weatherapi.com/v1/current.json?key=abc123&q=Madrid"
      method: get
      headers: "Accept: application/json"
      parse: json
```

---

## 🧠 Expected Traces (`--debug`)

```bash
🌐 [api] Executing get → https://api.weatherapi.com/v1/current.json?key=abc123&q=Madrid
💾 [api] Response saved to: /tmp/weather.json
⚠️ [api] Failed to parse as JSON
```

---

## 📜 Changelog

See the change history in [`changelog/api.md`](../changelog/api.md)
