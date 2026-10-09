# Skills-Achury

[English](./README.md) | **Español**

Un pack unificado y portable de **244 skills de agente**, **67 agentes especializados**, **126 comandos slash**, reglas y hooks para agentes de IA de código — curado desde lo mejor del ecosistema open-source y listo para instalar en **Claude Code** y **OpenCode**.

```
clona → ejecuta el instalador → reinicia tu agente → empieza a trabajar
```

## Qué incluye

| Componente | Cantidad | Descripción |
|---|---|---|
| **Skills** | 244 | Workflows reutilizables: TDD, auditorías de seguridad, review de código, patrones frontend/backend y más |
| **Agentes** | 67 | Subagentes especializados: revisores por lenguaje (TS, Python, Go, Rust, Java...), resolutores de errores de build, planificadores, auditores de seguridad |
| **Comandos** | 63 | Comandos slash: `/plan`, `/code-review`, `/security-scan`, y muchos más |
| **Reglas** | 22 dirs | Guías de codificación siempre activas (común + por lenguaje: TypeScript, Python, React, Go, Rust, Java, PHP...) |
| **Hooks** | — | — |
| **Referencia** | Prompts + docs | Colección de system prompts (GPLv3), reglas de agente de Floci, docs del CLI shadcn |

## Inicio rápido

### Opción A — Clonar e instalar (recomendado)

```bash
git clone <url-de-tu-repo> skills-achury
cd skills-achury
```

**Linux / macOS:**
```bash
./install.sh                        # perfil standard, detecta el harness automáticamente
./install.sh --profile full         # todo incluyendo prompts de referencia
./install.sh --profile minimal      # solo ~30 skills esenciales
./install.sh --dry-run              # previsualizar sin escribir nada
```

**Windows (PowerShell):**
```powershell
.\install.ps1                       # perfil standard
.\install.ps1 -Profile full         # todo
.\install.ps1 -DryRun               # previsualizar
.\install.ps1 -List                 # listar todas las skills/agentes/comandos
.\install.ps1 -Uninstall            # desinstalar archivos instalados
```

### Opción B — Plugin de Claude Code

Añade este repo como marketplace e instálalo como plugin:

```
/plugin marketplace add <tu-usuario-github>/skills-achury
/plugin install skills-achury@skills-achury
```

### Opción C — OpenCode (manual)

Clona el repo y apunta OpenCode a él:

```bash
git clone <url-de-tu-repo> ~/.opencode/skills-achury
```

Luego en tu `opencode.json`:

```json
{
  "skills": {
    "paths": ["~/.opencode/skills-achury/skills"]
  }
}
```

## Perfiles de instalación

| Perfil | Qué obtienes | Ideal para |
|---|---|---|
| `minimal` | ~30 skills esenciales (security-audit, shadcn, tdd, review, patrones...) | Probarlo, setups ligeros |
| `standard` *(por defecto)* | Todas las skills + agentes + comandos + reglas | Desarrollo diario |
| `full` | Todo + prompts de referencia | Usuarios avanzados, automatización total |

## Opciones del instalador

```
--profile minimal|standard|full   Perfil de instalación (default: standard)
--target claude|opencode|both     Dónde instalar (default: auto-detección)
--dry-run                         Previsualizar sin escribir
--uninstall                       Eliminar archivos instalados
--list                            Listar todos los componentes disponibles
```

El instalador detecta los directorios `~/.claude` y `~/.opencode` existentes e instala en el lugar correcto. Guarda un manifiesto en `~/.skills-achury/` para que `--uninstall` sea seguro y completo.

## Skills populares

| Skill | Qué hace |
|---|---|
| `security-audit` | Workflow completo de auditoría de seguridad adversarial (Cloudflare) con validadores |
| `shadcn` | Reglas estrictas para construir UIs con componentes shadcn/ui |
| `tdd-workflow` | Ciclo estricto RED → GREEN → REFACTOR con evidencia |
| `code-review` | Review multidimensional de código con clasificación de severidad |
| `frontend-patterns` / `backend-patterns` | Patrones de diseño agnósticos de framework |
| `react-patterns`, `python-patterns`, `golang-patterns`, `rust-patterns` | Mejores prácticas por lenguaje |
| `performance-optimizer` | Detección de cuellos de botella, tamaño de bundle, fugas de memoria |
| `prompt-optimizer` | Mejora tus prompts de agente |

Ejecuta `.\install.ps1 -List` (o `./install.sh --list`) para ver las 244.

## Estructura del proyecto

```
skills-achury/
├── skills/           # 243 skills (cada una: nombre/SKILL.md + assets opcionales)
├── agents/           # 67 definiciones de agentes (.md)
├── commands/         # 62 comandos slash (.md)
├── rules/            # reglas de codificación (common/ + por lenguaje/)
├── reference/        # prompts (GPLv3), docs, proyectos relacionados
├── .claude-plugin/   # manifiestos del plugin Claude Code
├── opencode.json     # adaptador OpenCode
├── install.sh        # instalador Unix/macOS
├── install.ps1       # instalador Windows
├── manifest.json     # catálogo + perfiles
└── tests/            # smoke tests del instalador
```

## Añade tus propias skills

Crea una carpeta dentro de `skills/` con un `SKILL.md`:

```markdown
---
name: mi-skill
description: Cuándo usar esta skill. Incluye palabras clave de activación.
---

# Mi Skill

Instrucciones para el agente...
```

El instalador la detectará automáticamente en la próxima ejecución.

## Créditos y licencias

Este pack cura material de varios proyectos open-source. Consulta [NOTICE.md](./NOTICE.md) para las atribuciones completas y [reference/PROJECTS.md](./reference/PROJECTS.md) para enlaces a los proyectos originales.

**Resumen:** la integración del pack, el instalador y el contenido MIT (ECC, Ruflo, security-audit de Cloudflare, shadcn/ui, Floci) son MIT. La colección `reference/prompts/` es GPLv3 y se mantiene separada — elimina esa carpeta si no la necesitas.

## Desinstalación

```bash
./install.sh --uninstall          # Unix
.\install.ps1 -Uninstall          # Windows
```

---

Hecho con ❤️ para la comunidad de agentes. Licencia MIT.
