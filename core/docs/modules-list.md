# 🧩 Módulos en BashFlow

**Generado automáticamente el 2025-09-16 10:05:02**

| Módulo | Descripción | Autor | Versión | Dependencias |
|--------|-------------|-------|---------|---------------|
| copy | Copia archivos locales al host remoto usando scp | Luis GuLo | 1.1 | scp, ssh |
| docker | Gestiona contenedores Docker (run, stop, remove, build, exec) | Luis GuLo | 1.1 | ssh, docker |
| file | Gestiona archivos y directorios remotos (crear, eliminar, permisos) | Luis GuLo | 1.1 | ssh |
| git | Gestiona repositorios Git en hosts remotos (clone, pull, checkout, fetch-file) | Luis GuLo | 1.1 | ssh, git, curl, tar |
| package | Instala, actualiza o elimina paquetes .deb/.rpm según el gestor disponible | Luis GuLo | 2.0 | ssh |
| run | Ejecuta comandos remotos vía SSH, con soporte para vault y sudo | Luis GuLo | 1.1 | ssh, core/utils/vault_utils.sh |
| service | Controla servicios del sistema remoto (start, stop, restart, enable, disable) con idempotencia | Luis GuLo | 1.1 | ssh, systemctl |
| vault-remote | Sincroniza secretos cifrados entre vault local y remoto | Luis GuLo | 1.0 | ssh, scp, gpg |
| my_custom_module |  |  |  |  |
| awesome_module |  |  |  |  |

_Para actualizar esta tabla, ejecuta: `core/utils/module-docgen.sh`_
