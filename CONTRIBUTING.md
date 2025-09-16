
# 🤝 Contribuir a BashFlow / Contributing to BashFlow

[ES]

Gracias por tu interés en colaborar con BashFlow. Este proyecto busca fomentar una comunidad abierta, modular y extensible para automatización en Bash.

[EN]

Thank you for your interest in contributing to BashFlow. This project aims to foster an open, modular and extensible community for Bash automation.

---

## 🧩 Tipos de contribución / Types of contributions

[ES]
- Nuevos módulos (`core/` o `community_modules/`)  
- Mejora de documentación (`docs/`)  
- Ejemplos de uso (`examples/`)  
- Corrección de errores o refactorización  
- Propuestas de diseño o estructura  

[EN]
- New modules (`core/` or `community_modules/`)  
- Documentation improvements (`docs/`)  
- Usage examples (`examples/`)  
- Bug fixes or refactoring  
- Design or structure proposals    

---

## 📦 Convenciones de módulos / Module conventions

[ES]
- Cada módulo debe incluir:
  - Función principal `*_task()`
  - Función `check_dependencies_*()` si aplica
  - Encabezado con `# Tier: core | community`, `# Author:`, `# License: GPLv3`
  - Compatibilidad con argumentos YAML (`args:`)
  - Mensajes claros y silenciosos (`echo` controlado)

- Documentación asociada en `docs/es/modules/` y `docs/en/modules/` si aplica

[EN]
- Each module must include:
    - Main `*_task()` function
    - `check_dependencies_*()` function, if applicable
    - Header with `# Tier: core | community`, `# Author:`, `# License: GPLv3`
    - Support for YAML arguments (`args:`)
    - Clear and silent messages (controlled `echo`)

- Associated documentation in `docs/es/modules/` and `docs/en/modules/`, if applicable

---

## 📁 Estructura recomendada / Recommended structure

```
core/modules/
community_modules/cloud/
docs/es/modules/
docs/en/modules/
examples/
```

---

## 🧪 Testing y validación / Testing and validation

- Verifica que el módulo sea idempotente y no genere efectos secundarios inesperados
- Usa `check_dependencies_*()` para validar herramientas externas
- Incluye ejemplos YAML funcionales en la documentación

---

## 📄 Licencia / License

[ES]

Al contribuir, aceptas que tu aporte se publique bajo la licencia **GPLv3**, en línea con el resto del proyecto.

[EN]

By contributing, you agree that your submission will be published under the **GPLv3** license, consistent with the rest of the project.

---

## 📬 Cómo empezar / Getting started

[ES]
1. Haz un fork del repositorio
2. Crea una rama descriptiva
3. Realiza tus cambios
4. Abre un Pull Request con descripción clara

[EN]
1. Fork the repository  
2. Create a descriptive branch  
3. Make your changes  
4. Open a Pull Request with a clear description



---
[ES]

Gracias por ayudar a construir `BashFlow`.  

[EN]

Thank you for helping build `BashFlow`.
