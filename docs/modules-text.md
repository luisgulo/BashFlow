# 📘 Documentación de módulos de texto / Text Modules Documentation

🧩 **Módulos de gestión de texto / Text Management Modules**


---

## 🇪🇸 1. `replace` — Reemplazo de texto en archivos

Reemplaza todas las coincidencias de una expresión regular por una nueva línea.

### 🔧 Argumentos

- `path`: Ruta del archivo a modificar
- `regexp`: Expresión regular a buscar
- `replace`: Texto que reemplazará la coincidencia
- `backup`: `true` para crear copia `.bak`
- `become`: `true` para usar `sudo`

### 📄 Ejemplo YAML

```yaml
- name: Reemplazar puerto en configuración
  module: replace
  args:
    path: /etc/nginx/sites-available/default
    regexp: 'listen\s+80'
    replace: 'listen 8080'
    backup: true
    become: true
```

---

## 🇬🇧 1. `replace` — Text replacement in files

Replaces all matches of a regular expression with a new line.

### 🔧 Arguments

- `path`: Path to the file
- `regexp`: Regular expression to match
- `replace`: Replacement text
- `backup`: `true` to create `.bak` copy
- `become`: `true` to use `sudo`

---

## 🇪🇸 2. `lineinfile` — Asegura o reemplaza una línea

Añade una línea si no existe, o reemplaza si coincide con `regexp`.

### 🔧 Argumentos

- `path`: Archivo objetivo
- `line`: Línea a insertar o asegurar
- `regexp`: Patrón a reemplazar (opcional)
- `insert_after`: Línea después de la cual insertar (opcional)
- `create`: `true` para crear el archivo si no existe
- `backup`: `true` para copia de seguridad
- `become`: `true` para usar `sudo`

### 📄 Ejemplo YAML

```yaml
- name: Asegurar configuración de NGINX
  module: lineinfile
  args:
    path: /etc/nginx/nginx.conf
    line: 'client_max_body_size 20M;'
    regexp: '^client_max_body_size'
    backup: true
    become: true
```

---

## 🇬🇧 2. `lineinfile` — Ensure or replace a line

Adds a line if missing, or replaces it if matching `regexp`.

---

## 🇪🇸 3. `blockinfile` — Inserta bloques delimitados

Inserta o reemplaza bloques de texto entre marcadores `# BEGIN` y `# END`.

### 🔧 Argumentos

- `path`: Archivo destino
- `block`: Contenido del bloque
- `marker`: Identificador del bloque (por defecto: `BASHFLOW`)
- `create`: `true` para crear el archivo si no existe
- `backup`: `true` para copia `.bak`
- `become`: `true` para usar `sudo`

### 📄 Ejemplo YAML

```yaml
- name: Añadir bloque de configuración
  module: blockinfile
  args:
    path: /etc/nginx/nginx.conf
    block: |
      server_tokens off;
      keepalive_timeout 65;
    marker: NGINX_CONF
    backup: true
    become: true
```

---

## 🇬🇧 3. `blockinfile` — Insert delimited blocks

Inserts or replaces text blocks between `# BEGIN` and `# END` markers.

---

## 🇪🇸 4. `template` — Genera archivos desde plantillas

Sustituye variables `{{var}}` en archivos `.tmpl` ubicados en `core/templates`.

### 🔧 Argumentos

- `src`: Nombre del archivo plantilla (dentro de `core/templates`)
- `dest`: Ruta de destino del archivo generado
- `{{var}}`: Variables a reemplazar
- `become`: `true` para usar `sudo`

### 📄 Ejemplo YAML

```yaml
- name: Generar configuración de NGINX
  module: template
  args:
    src: nginx.conf.tmpl
    dest: /etc/nginx/nginx.conf
    port: 8080
    user: www-data
    become: true
```

### 📁 Ejemplo de plantilla (`core/templates/nginx.conf.tmpl`)

```nginx
server {
    listen {{port}};
    user {{user}};
    server_name localhost;
}
```

---

## 🇬🇧 4. `template` — Generate files from templates

Replaces `{{var}}` placeholders in `.tmpl` files located in `core/templates`.

---

## 📎 Notas adicionales / Additional Notes

- Todos los módulos admiten `become: true` para ejecución con privilegios
- `backup: true` crea una copia `.bak` antes de modificar el archivo
- Las rutas deben ser absolutas o relativas al sistema, no al proyecto
- Las plantillas deben estar en `core/templates` por ahora

