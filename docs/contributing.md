# 🤝 Contribuir a BashFlow

Gracias por tu interés en colaborar con **BashFlow**. Este proyecto está abierto a contribuciones técnicas, documentales y comunitarias. Aquí encontrarás las pautas para participar de forma efectiva.

---

## 🧭 Flujo de trabajo con Git

1. Haz un fork del repositorio
2. Crea una rama descriptiva: `feature/modulo-nuevo` o `fix/limpieza-labels`
3. Realiza tus cambios con commits claros y concisos
4. Actualiza la documentación si aplica
5. Abre un Pull Request explicando el propósito y alcance

---

## ✍️ Estilo de código y documentación

- Usa Bash estricto (`set -euo pipefail`)
- Prefiere funciones con nombres claros: `ntp_task`, `vaultTask`
- Documenta cada módulo en `docs/modules/`
- Incluye ejemplos de uso y argumentos esperados
- Mantén consistencia en los changelogs (`docs/changelog/`)

---

## ⚙️ Crear nuevos módulos

BashFlow permite la creación de módulos personalizados para ampliar su funcionalidad. Sin embargo, existe una distinción clara entre los módulos **core** y los módulos **community**:

### 🔧 Módulos core (`core/modules/`)

- Son módulos oficiales del proyecto
- Deben seguir estándares estrictos de calidad, trazabilidad y documentación
- Su inclusión está sujeta a revisión y aprobación por la autoridad responsable del proyecto (**Luis GuLo**)
- Se documentan en `docs/modules/` y se registran en `docs/changelog/`

### 🌐 Módulos comunitarios (`community_modules/`)

- Son contribuciones abiertas de la comunidad
- Pueden agruparse por bloques temáticos (ej. `windows/`, `networking/`, `security/`)
- No afectan al núcleo del sistema, pero pueden ser invocados desde playbooks
- Se documentan en `docs/community/` y pueden tener su propio changelog

### 🧩 Pasos para crear un módulo

1. Crea el archivo en la ruta correspondiente (`core/modules/` o `community_modules/`)
2. Define una función principal: `<nombre>_task()`
3. Usa argumentos en formato `clave=valor`
4. Añade trazas si se usa `--debug`
5. Documenta en `docs/modules/<nombre>.md` o `docs/community/<bloque>/<nombre>.md` con:

   - Descripción
   - Argumentos
   - Ejemplo de uso
   - Changelog

---

## 🔍 Revisión y mejora

- Todo PR será revisado por el mantenedor principal
- Se valoran propuestas con documentación clara y trazabilidad
- Se aceptan mejoras en estructura, rendimiento, seguridad y estilo

---

## 🌐 Comunidad

- Puedes proponer ideas en issues
- Se agradecen traducciones, ejemplos y validaciones cruzadas
- El proyecto busca crecer con aportes abiertos y trazables

---

# 🤝 Contributing to BashFlow

Thanks for your interest in contributing to **BashFlow**. This project welcomes technical, documentation and community contributions. Here's how to participate effectively.

---

## 🧭 Git Workflow

1. Fork the repository  
2. Create a descriptive branch: `feature/new-module` or `fix/label-cleanup`  
3. Make your changes with clear, concise commits  
4. Update documentation if applicable  
5. Open a Pull Request explaining purpose and scope  

---

## ✍️ Code and Documentation Style

- Use strict Bash (`set -euo pipefail`)  
- Prefer clear function names: `ntp_task`, `vaultTask`  
- Document each module in `docs/modules/`  
- Include usage examples and expected arguments  
- Keep changelogs consistent (`docs/changelog/`)  

---

## ⚙️ Creating New Modules

BashFlow allows the creation of custom modules to extend its functionality. However, there's a clear distinction between **core** modules and **community** modules:

### 🔧 Core Modules (`core/modules/`)

- Official modules of the project  
- Must follow strict standards of quality, traceability and documentation  
- Inclusion is subject to review and approval by the project authority (**Luis GuLo**)  
- Documented in `docs/modules/` and registered in `docs/changelog/`  

### 🌐 Community Modules (`community_modules/`)

- Open contributions from the community  
- Can be grouped by thematic blocks (e.g. `windows/`, `networking/`, `security/`)  
- Do not affect the system core but can be invoked from playbooks  
- Documented in `docs/community/` and may have their own changelog  

### 🧩 Steps to create a module

1. Create the file in the appropriate path (`core/modules/` or `community_modules/`)  
2. Define a main function: `<name>_task()`  
3. Use arguments in `key=value` format  
4. Add debug traces if `--debug` is used  
5. Document in `docs/modules/<name>.md` or `docs/community/<block>/<name>.md` with:

   - Description  
   - Arguments  
   - Usage example  
   - Changelog   

---

## 🔍 Review and Improvement

- All PRs will be reviewed by the lead maintainer  
- Clear documentation and traceability are valued  
- Improvements in structure, performance, security and style are welcome  

---

## 🌐 Community

- You can propose ideas via issues  
- Translations, examples and cross-validations are appreciated  
- The project aims to grow through open and traceable contributions  
