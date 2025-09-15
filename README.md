# BashFlow – Lightweight and Extensible Automation with Bash

## BashFlow. The Idea and Why

Automation using Bash processes is one of the earliest concepts in the history of server-side work. 
The process has been improved by leveraging the advantages of new programming languages, such as Python, and has been "encapsulated" in a new automation paradigm, Ansible, which appears to be becoming the standard.

However, using Ansible, which relies entirely on Python, means you have to deal with the problem of dependencies and incompatibility between Python modules and their versions, both on the server running the automation and with the Python versions of the managed servers.

**My proposal is to create an automation tool inspired by Ansible but based on Bash.**

This solution makes a lot of sense if you're looking for simplicity, portability, and avoiding Python's dependency hell.

Bash is ubiquitous, lightweight, and very stable in Unix-like environments.

My proposal is a project I've called `BashFlow`. 

I chose the name for the following reasons: it sounds modern, agile, and conveys exactly what we want: a Bash-based workflow automation, without complications. 

A name that refers to a professional yet accessible tool, and is also easy to remember and pronounce in any language.

---

## BashFlow. Base Design and Starting Point

The initial idea is to incorporate a YAML-like syntax into BashFlow. 

We allow current Ansible users to feel familiar, make it easier to read declarative tasks, and maintain the flexibility of Bash as an execution engine.

Initial example of a YAML-formatted playbook in BashFlow:

```yaml
hosts:
  - web01
  - web02

tasks:
  - name: Instalar nginx / Install nginx
    run: "apt-get update && apt-get install -y nginx"
    become: true

  - name: Copiar archivo de configuración / copy config file
    copy:
      src: "./nginx.conf"
      dest: "/etc/nginx/nginx.conf"
      mode: "0644"

  - name: Reiniciar nginx / Restart nginx
    run: "systemctl restart nginx"
```

## BashFlow Interpretation
The idea is to use `yq` as a parser, as it allows you to:

* Read YAML
* Iterate over hosts
* Execute each task according to its type (run, copy, etc.)
* Use ssh to connect and execute commands
* Apply sudo if become: true
* 
I've designed the project to be extensible from the start, to give BashFlow a sense of community and powerful evolution.

I think `yq` as a parser is ideal, allowing us to maintain the YAML syntax without complicating things with **pure Bash**. 

It also allows us to create or incorporate modules as a key option so other users can contribute without breaking the BashFlow foundation.

---

## Advantages of BashFlow

* Familiar to Ansible users
* Readable and structured
* Easy to version and audit
* Compatible with pure Bash if desired
---

# Proposed structure for the Project

```bash
bashflow/
├── core/
│ ├── modules/ # Official core modules
│ ├── examples/ # Example YAML playbooks
│ ├── docs/ # Technical and usage documentation
│ ├── templates/ # Base files for modules, config, etc.
│ └── utils/ # Common functions (logging, validation, etc.)
├── user_modules/ # Custom user modules
│ └── my_custom_module.sh
├── community_modules/ # Community-shared modules
│ └── awesome_module.sh
├── bashflow.sh # Main controller script
├── bashflow-doc.sh # Documentation generator
├── bashflow-check.sh # Environment and dependency checker
└── README.md # Project introduction
```

---
## Convention for modules

Each module is a Bash script that implements a standard named function, for example:

```bash
# modules/run.sh
run_task() {
  local host="$1"
  local command="$2"
  ssh "$host" "$command"
}
```

The main controller (bashflow.sh) can dynamically load modules:

```bash
...
load_modules() {
  for dir in core/modules user_modules community_modules; do
    for mod in "$dir"/*.sh; do
      [ -f "$mod" ] && source "$mod"
    done
  done
}
...
```

YAML using one of the modules:

```yaml
tasks:
  - name: Reiniciar nginx // Restart nginx service
    module: service
    args:
      name: nginx
      state: restarted
```

The parser would use `yq` and extract `module:service` and then call `service_task` with the arguments.

---

## BashFlow. Advantages of this approach

* **Plug & Play**: Any user can add their module without touching the core
* **Clean separation**: Core, User, and Community are clearly differentiated
* **Security**: Modules can be validated before uploading them
* **Community**: It's easy to share modules on GitHub, Gists, etc.
 
The idea is a forward-looking design for the tool: **modular**, **documented**, and **robust**.

## Standard Module Template

All modules should follow a clear structure to facilitate maintenance, extensibility, and documentation.

Proposed template example:

```bash
#!/bin/bash
# Module: service
# Description: Controls system services (start, stop, restart) / Controla servicios del sistema (start, stop, restart)
# Author: Luis GuLo
# Version: 1.0
# Dependencies: systemctl, ssh
# Usage:
#   service_task "$host" "$name" "$state"

service_task() {
  local host="$1"
  local name="$2"
  local state="$3"
  ssh "$host" "sudo systemctl $state $name"
}
```

**Usage and syntax conventions** 

* Header with metadata (Module, Description, Author, etc.)
* Main function with standard name (<module>_task)
* Use of well-defined variables
* Clear comments for each step

---

## Extra tools in `bashflow`

### 1. Self-Contained Documentation System

You'll need a tool, which we'll call `bashflow-doc`, that will scan all modules and generate automatic documentation in the console or in Markdown format:

```bash
bashflow-doc core/modules/ user_modules/ community_modules/
```

**What does it do?**

* Extracts headers from each module.
* Lists the name, description, author, version, and dependencies.
* Optional: Generates a browsable index.

Output example:

```bash
📦 Module: service
🔧 Description: Controls system services / Controla servicios del sistema
👤 Author: Luis GuLo
📌 Version: 1.0
📎 Dependencies: systemctl, ssh
```

### 2. Dependency Checking Tool

We can include a script called `bashflow-check` that checks:

* Whether the necessary tools (ssh, scp, systemctl, etc.) are available
* Whether yq is installed and is the recommended version
* Whether modules declare unmet dependencies
  
Example usage:

```bash
bashflow-check
```

Output example:

```bash 
✅ ssh: OK
✅ scp: OK
⚠️ yq: Not found
⚠️ systemctl: Not available on this system
```
---

# Implemented modules

All modules include the `check_dependencies_run` function

