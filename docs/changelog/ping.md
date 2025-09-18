# 📜 Changelog — `ping.sh`

Este documento registra los cambios realizados en el módulo `ping.sh`, utilizado para verificar conectividad desde hosts remotos hacia destinos específicos.

This document records changes made to the `ping.sh` module, used to verify connectivity from remote hosts to specific destinations.

---

## 🇪🇸 Historial de versiones

### 🧩 v1.1 — [2025-09-18]
- Mejora de trazas con emojis (`📡`, `✅`, `❌`)
- Soporte para `become=true` para ejecutar con `sudo`
- Parámetros configurables:
  - `target`: IP o dominio de destino
  - `count`: número de paquetes
  - `timeout`: tiempo de espera por paquete
- Validación de conectividad vía `ping` remoto por SSH
- Mensajes claros de éxito o fallo

---

### 🧩 v1.0 — [2025-08-30]
- Creación inicial del módulo `ping.sh`
- Ejecución básica de `ping` remoto
- Parámetros: `target`, `count`, `timeout`
- Dependencias: `ping`, `ssh`

---
---

## 🇬🇧 Version History

### 🧩 v1.1 — [2025-09-18]
- Improved trace messages with emojis (`📡`, `✅`, `❌`)  
- Support for `become=true` to run with `sudo`  
- Configurable parameters:
  - `target`: destination IP or domain
  - `count`: number of packets
  - `timeout`: timeout per packet  
- Remote connectivity check via SSH `ping`  
- Clear success/failure messages  

---

### 🧩 v1.0 — [2025-08-30]
- Initial creation of `ping.sh` module  
- Basic remote `ping` execution  
- Parameters: `target`, `count`, `timeout`  
- Dependencies: `ping`, `ssh`  
