# BashFlow

## BashFlow (Diseño Base)


**BashFlow** – *Automatización ligera y extensible con Bash*
* Componentes definidos

    -    Sintaxis YAML con yq como parser
    -    Módulos Bash con plantilla estándar
    -    Sistema de documentación autocontenida (bashflow-doc)
    -    Herramienta de verificación de dependencias (bashflow-check)
    -    Estructura modular: núcleo, usuario, comunidad

* Primer módulo implementado

    -    run.sh: ejecución remota vía SSH
    -    Incluye función check_dependencies_run

* Convenciones establecidas

    -    Funciones con nombre <modulo>_task
    -    Encabezado con metadatos en cada módulo
    -    Carga dinámica de módulos desde rutas definidas