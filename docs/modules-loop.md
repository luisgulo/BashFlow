# 📘 Documentación del módulo `loop` / `loop` module documentation


🔁 **`loop` — Ejecución de módulos en bucle / Loop execution of modules**

---

## 🇪🇸 Descripción

El módulo `loop` permite ejecutar otro módulo de BashFlow múltiples veces sobre una lista de valores. Soporta bucles simples, pares clave-valor (`clave:valor`) y bucles dobles entre dos listas. Es útil para automatizar tareas repetitivas como creación de usuarios, asignación de permisos o despliegue por entorno.

---

## 🇬🇧 Description

The `loop` module allows executing another BashFlow module multiple times over a list of values. It supports simple loops, key-value pairs (`key:value`), and double loops between two lists. Ideal for automating repetitive tasks like user creation, permission assignment, or environment-based deployment.

---

## 🔧 Argumentos / Arguments

| Clave / Key       | Tipo / Type | Descripción / Description                                      |
|------------------|-------------|----------------------------------------------------------------|
| `items`          | lista       | Lista principal de valores o pares `a:b,c:d`                  |
| `secondary`      | lista       | Lista secundaria para bucle doble (opcional)                  |
| `module`         | texto       | Nombre del módulo a ejecutar en cada iteración                |
| `fail_fast`      | `true/false`| Si se detiene ante el primer error (`true`) o continúa (`false`) |
| `args`           | mapa        | Argumentos del módulo destino, con soporte para `{{item}}`, `{{item_key}}`, `{{item_value}}`, `{{secondary_item}}` |

---

## 🧪 Ejemplos / Examples

### 🇪🇸 1. Bucle simple

```yaml
- name: Crear usuarios
  module: loop
  args:
    items: alice,bob,carol
    module: useradd
    fail_fast: false
    args:
      name: {{item}}
      shell: /bin/bash
      become: true
```

### 🇬🇧 1. Simple loop

Creates users `alice`, `bob`, and `carol` using the `useradd` module.

---

### 🇪🇸 2. Pares clave-valor

```yaml
- name: Asignar usuarios a grupos
  module: loop
  args:
    items: alice:sudo,bob:docker,carol:admin
    module: useradd
    args:
      name: {{item_key}}
      groups: {{item_value}}
      shell: /bin/bash
      become: true
```

### 🇬🇧 2. Key-value pairs

Assigns each user to a group using `item_key` and `item_value`.

---

### 🇪🇸 3. Bucle doble cartesiano

```yaml
- name: Asignar permisos cruzados
  module: loop
  args:
    items: alice,bob
    secondary: read,write
    module: permission
    args:
      user: {{item}}
      mode: {{secondary_item}}
```

### 🇬🇧 3. Double loop (Cartesian)

Assigns each user both `read` and `write` permissions.

---

## ✅ Características / Features

- Iteración sobre listas simples y pares clave-valor
- Bucle doble entre `items` y `secondary`
- Reemplazo dinámico de variables en argumentos
- Control de errores con `fail_fast`
- Compatible con cualquier módulo de BashFlow

---

## 📎 Notas / Notes

- Las listas deben estar separadas por comas: `a,b,c`
- Los pares clave-valor usan `:` como separador: `key:value`
- Las variables disponibles para reemplazo son:
  - `{{item}}`
  - `{{item_key}}`
  - `{{item_value}}`
  - `{{secondary_item}}`
- Si `fail_fast: false`, el bucle continúa aunque una iteración falle

