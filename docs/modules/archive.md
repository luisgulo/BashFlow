# 📦 Módulo: archive

## 🇪🇸 Descripción

El módulo `archive` permite comprimir, descomprimir y extraer archivos en remoto mediante comandos estándar como `tar`, `zip`, `gzip` y `bzip2`. Es útil para tareas de backup, despliegue, limpieza o auditoría de archivos en sistemas Linux.

---

## 🧩 Argumentos disponibles

| Clave      | Descripción                                                                 |
|------------|------------------------------------------------------------------------------|
| `action`   | Acción a realizar: `compress`, `decompress`, `extract`                      |
| `format`   | Formato de archivo: `tar`, `zip`, `gzip`, `bzip2`                           |
| `files`    | Lista de archivos a comprimir (separados por coma)                          |
| `archive`  | Ruta del archivo comprimido o a extraer                                     |
| `output`   | Ruta de destino para el archivo generado                                    |
| `dest`     | Carpeta de destino para extracción                                          |
| `become`   | Si se requiere `sudo`, usar `become=true`                                   |

---

## ▶️ Ejemplo de uso

```yaml
tasks:
  - name: Comprimir logs del sistema
    module: archive
    args:
      action: compress
      format: tar
      files: /var/log/syslog,/var/log/dmesg
      output: /tmp/logs.tar.gz
      become: true
```

---

## 🧠 Trazas esperadas (`--debug`)

```bash
📦 [archive] Comprimido en TAR: /tmp/logs.tar.gz
📂 [archive] Extraído ZIP en: /home/user/backup
❌ [archive] Formato 'rar' no soportado para compresión.
```

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/archive.md`](../changelog/archive.md)

---

---

# 📦 Module: archive

## 🇬🇧 Description

The `archive` module allows remote compression, decompression and extraction of files using standard tools like `tar`, `zip`, `gzip` and `bzip2`. It's useful for backup, deployment, cleanup or file audits on Linux systems.

---

## 🧩 Available Arguments

| Key        | Description                                                                  |
|------------|------------------------------------------------------------------------------|
| `action`   | Operation to perform: `compress`, `decompress`, `extract`                   |
| `format`   | Archive format: `tar`, `zip`, `gzip`, `bzip2`                               |
| `files`    | List of files to compress (comma-separated)                                 |
| `archive`  | Path to the archive file or file to extract                                 |
| `output`   | Destination path for the generated archive                                  |
| `dest`     | Destination folder for extraction                                            |
| `become`   | Use `become=true` if `sudo` is required                                     |

---

## ▶️ Usage Example

```yaml
tasks:
  - name: Compress system logs
    module: archive
    args:
      action: compress
      format: tar
      files: /var/log/syslog,/var/log/dmesg
      output: /tmp/logs.tar.gz
      become: true
```

---

## 🧠 Expected Traces (`--debug`)

```bash
📦 [archive] Compressed as TAR: /tmp/logs.tar.gz
📂 [archive] Extracted ZIP to: /home/user/backup
❌ [archive] Format 'rar' not supported for compression.
```

---

## 📜 Changelog

See the change history in [`changelog/archive.md`](../changelog/archive.md)
