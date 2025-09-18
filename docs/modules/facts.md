# 🧠 Módulo: facts

## 🇪🇸 Descripción

El módulo `facts` permite extraer información del sistema remoto de forma estructurada y trazable. Recoge datos como hostname, CPU, RAM, sistema operativo, interfaces de red y particiones, con múltiples formatos de salida.

Es ideal para auditorías, generación de informes, validación de entornos y recopilación de inventario técnico.

---

## 🧩 Argumentos disponibles

| Clave        | Descripción                                                                 |
|--------------|------------------------------------------------------------------------------|
| `field`      | Filtra la salida por una clave específica (`cpu_count`, `os_name`, etc.)    |
| `format`     | Formato de salida: `plain`, `md`, `kv`, `json`                              |
| `output`     | Ruta donde guardar el informe generado                                      |
| `append`     | Si se desea añadir al archivo existente (`true` o `false`)                  |
| `host_label` | Etiqueta personalizada para el host en el informe                           |

---

## ▶️ Ejemplo de uso

```yaml
tasks:
  - name: Auditoría básica del sistema
    module: facts
    args:
      format: md
      output: "/tmp/informe_{{ name }}.md"
      host_label: "{{ label }}"
```

---

## 🧠 Trazas esperadas (`--debug`)

```bash
🔍 [facts] host_label='equipo1' format='md' output='/tmp/informe_equipo1.md'
🔍 Línea SSH: ssh equipo1 bash --noprofile --norc
🔍 Ejecutando bloque remoto en equipo1...
💾 [facts] Informe guardado en: /tmp/informe_equipo1.md
```

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/facts.md`](../changelog/facts.md)

---

---

# 🧠 Module: facts

## 🇬🇧 Description

The `facts` module extracts structured and traceable system information from remote hosts. It collects data such as hostname, CPU, RAM, OS, network interfaces and partitions, with multiple output formats.

Ideal for audits, report generation, environment validation and technical inventory gathering.

---

## 🧩 Available Arguments

| Key          | Description                                                                  |
|--------------|------------------------------------------------------------------------------|
| `field`      | Filters output by a specific key (`cpu_count`, `os_name`, etc.)              |
| `format`     | Output format: `plain`, `md`, `kv`, `json`                                   |
| `output`     | Path to save the generated report                                             |
| `append`     | Whether to append to existing file (`true` or `false`)                       |
| `host_label` | Custom label for the host in the report                                      |

---

## ▶️ Usage Example

```yaml
tasks:
  - name: Basic system audit
    module: facts
    args:
      format: md
      output: "/tmp/report_{{ name }}.md"
      host_label: "{{ label }}"
```

---

## 🧠 Expected Traces (`--debug`)

```bash
🔍 [facts] host_label='host1' format='md' output='/tmp/report_host1.md'
🔍 SSH line: ssh host1 bash --noprofile --norc
🔍 Executing remote block on host1...
💾 [facts] Report saved to: /tmp/report_host1.md
```

---

## 📜 Changelog

See the change history in [`changelog/facts.md`](../changelog/facts.md)
