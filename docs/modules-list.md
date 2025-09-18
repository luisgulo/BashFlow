# 🧩 Módulos en BashFlow

**Generado automáticamente el 2025-09-19 00:18:26**

| Módulo | Descripción | Autor | Versión | Dependencias |
|--------|-------------|-------|---------|---------------|
| api | Cliente declarativo para APIs REST y SOAP (GET, POST, PUT, DELETE, SOAP) | Luis GuLo | 1.0 | curl, jq, xmllint |
| archive | Comprime, descomprime y extrae archivos en remoto (tar, zip, gzip, bzip2) | Luis GuLo | 1.0 | ssh, tar, gzip, bzip2, zip, unzip |
| blockinfile | Inserta o actualiza bloques de texto delimitados en archivos | Luis GuLo | 0.1 | grep, sed, tee, awk |
| copy | Copia archivos locales al host remoto usando scp | Luis GuLo | 1.1 | scp, ssh |
| docker | Gestiona contenedores Docker (run, stop, remove, build, exec) | Luis GuLo | 1.2 | ssh, docker |
| facts | Extrae información del sistema con opciones de formato, filtrado y salida | Luis GuLo | 1.3.2 |  |
| file | Gestiona archivos y directorios remotos (crear, eliminar, permisos) | Luis GuLo | 1.1 | ssh |
| fs | Operaciones remotas sobre ficheros (mover, renombrar, copiar, borrar, truncar) | Luis GuLo | 1.2 | ssh |
| git | Gestiona repositorios Git en hosts remotos (clone, pull, checkout, fetch-file) | Luis GuLo | 1.1 | ssh, git, curl, tar |
| lineinfile | Asegura la presencia o reemplazo de una línea en un archivo | Luis GuLo | 0.1 | grep, sed, tee, awk |
| loop | Ejecuta un módulo sobre una lista o matriz de valores | Luis GuLo | 0.2 | bashflow, echo, tee |
| package | Instala, actualiza o elimina paquetes .deb/.rpm y permite actualizar el sistema | Luis GuLo | 2.1 | ssh |
| ping | Verifica conectividad desde el host remoto hacia un destino específico | Luis GuLo | 1.1 | ping, ssh |
| replace | Reemplaza texto en archivos usando expresiones regulares | Luis GuLo | 0.1 | sed, cp, tee |
| run | Ejecuta comandos remotos vía SSH, con soporte para vault y sudo | Luis GuLo | 1.1 | ssh, core/utils/vault_utils.sh |
| service | Controla servicios del sistema remoto (start, stop, restart, enable, disable) con idempotencia | Luis GuLo | 1.1 | ssh, systemctl |
| template | Genera archivos a partir de plantillas con variables {{var}}, bucles, includes y delimitadores configurables | Luis GuLo | 0.3 | bash, sed, tee, grep, cat |
| useradd | Crea usuarios en el sistema con opciones personalizadas | Luis GuLo | 0.1 | id, useradd, sudo |
| vault-remote | Sincroniza secretos cifrados entre vault local y remoto | Luis GuLo | 1.0 | ssh, scp, gpg |
| * |  |  |  |  |
| * |  |  |  |  |

_Para actualizar esta tabla, ejecuta: `core/utils/module-docgen.sh`_
