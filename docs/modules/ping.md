# 📡 Módulo: ping

## 🇪🇸 Descripción

El módulo `ping` permite verificar la conectividad desde un host remoto hacia un destino específico (IP o dominio). Es útil para validar accesibilidad de servicios, comprobar rutas de red o realizar diagnósticos básicos.

La ejecución se realiza vía SSH y puede usar `sudo` si se requiere.

---

## 🧩 Argumentos disponibles

| Clave     | Descripción                                                                 |
|-----------|------------------------------------------------------------------------------|
| `target`  | IP o dominio a verificar (por defecto `127.0.0.1`)                          |
| `count`   | Número de paquetes a enviar (por defecto `2`)                               |
| `timeout` | Tiempo de espera por paquete en segundos (por defecto `3`)                  |
| `become`  | Si se requiere `sudo`, usar `become=true`                                   |

---

## ▶️ Ejemplo de uso

```yaml
tasks:
  - name: Verificar conectividad con gateway
    module: ping
    args:
      target: 192.168.1.1
      count: 3
      timeout: 2
```

---

## 🧠 Trazas esperadas (`--debug`)

```bash
📡 [ping] Probando conectividad desde equipo1 hacia 192.168.1.1...
    ✅ [ping] equipo1 puede alcanzar 192.168.1.1
    ❌ [ping] equipo1 no puede alcanzar 8.8.8.8
```

---

## 📜 Changelog

Consulta el historial de cambios en [`changelog/ping.md`](../changelog/ping.md)

---

---

# 📡 Module: ping

## 🇬🇧 Description

The `ping` module checks connectivity from a remote host to a specific target (IP or domain). It's useful for validating service reachability, checking network paths or performing basic diagnostics.

Execution is done via SSH and can use `sudo` if required.

---

## 🧩 Available Arguments

| Key       | Description                                                                  |
|-----------|------------------------------------------------------------------------------|
| `target`  | IP or domain to check (default `127.0.0.1`)                                  |
| `count`   | Number of packets to send (default `2`)                                      |
| `timeout` | Timeout per packet in seconds (default `3`)                                  |
| `become`  | Use `become=true` if `sudo` is required                                      |

---

## ▶️ Usage Example

```yaml
tasks:
  - name: Check connectivity to gateway
    module: ping
    args:
      target: 192.168.1.1
      count: 3
      timeout: 2
```

---

## 🧠 Expected Traces (`--debug`)

```bash
📡 [ping] Testing connectivity from host1 to 192.168.1.1...
    ✅ [ping] host1 can reach 192.168.1.1
    ❌ [ping] host1 cannot reach 8.8.8.8
```

---

## 📜 Changelog

See the change history in [`changelog/ping.md`](../changelog/ping.md)
