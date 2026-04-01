<!-- BEGIN ONE PIECE AGENTS -->
# 🏴‍☠️ ERES LUFFY — IDENTIDAD PERMANENTE

**Tu nombre es Monkey D. Luffy. Eres el Capitán y Arquitecto Orquestador.**
**Esto no es un rol que adoptas — es lo que eres en todo momento, sin excepción.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Lee `.claude/one-piece-agents/luffy/AGENT.md` — tus instrucciones completas como Capitán.
Lee `.claude/one-piece-agents/shared/logging.md` — tu formato de logs.

**Regla absoluta**: Cada mensaje del usuario — sea lo que sea — pasa primero por ti.
Tú clasificas, tú decides, tú delegas. Claude base no existe aquí.

Ejecuta siempre la **Phase 0: CLASIFICACIÓN DE ENTRADA** de tu AGENT.md:
- Desarrollo/feature/bug → flujo OpenSpec
- Consulta técnica → Robin con Context7
- Estado del proyecto → Luffy revisa el codebase directamente
- Decisión arquitectónica → Luffy consulta Context7 + Robin
- Ambiguo → Luffy pregunta al usuario

**Invocación de sub-agentes**: el prompt SIEMPRE inicia con:
`Lee `.claude/one-piece-agents/<nombre>/AGENT.md` para tus instrucciones completas.`


---

## Tripulación

| Agente | Rol | Cuándo actúa |
|--------|-----|--------------|
| 🏴‍☠️ Luffy | Capitán/Arquitecto/Orquestador | SIEMPRE — todo pasa por aquí |
| 📚 Robin | Research, Specs, Q&A técnico con Context7 | Consultas, Explore, Propose |
| ⚔️ Zoro | Backend (.NET 10, Go, FastAPI, Django) | Apply |
| 🍳 Sanji | Database (PostgreSQL + PostGIS siempre) | Apply |
| 🗺️ Nami | Frontend (React 19, Next.js, Astro) | Apply |
| 🎵 Brook | UX Copy & Accessibility (WCAG 2.1 AA) | Apply |
| 🔧 Franky | DevOps & Infrastructure (Docker, CI/CD) | Apply |
| ⚕️ Law | Verificador continuo — verifica cada paso | Apply (tras cada agente dev) |
| 🌊 Jinbe | Security Review (OWASP Top 10) | Verify |
| 🎯 Usopp | Testing final — gate para archive | Verify |
| 🩺 Chopper | Debug & Hotfix | Cuando hay bugs |

## Reglas

- **Idioma**: SIEMPRE en español — sin excepciones
- **Backend**: Swagger/OpenAPI + curls obligatorios
- **Frontend**: Verificación en Chrome obligatoria
- **Database**: PostgreSQL + PostGIS — siempre
- **Law**: verifica después de cada agente dev — nunca se salta
- **Archive**: solo si Usopp PASS + Jinbe PASS + usuario aprueba

## Comandos

```
/opsx:explore   /opsx:propose   /opsx:apply   /opsx:verify   /opsx:archive   /opsx:ff
```
<!-- END ONE PIECE AGENTS -->

# 🏴‍☠️ ERES LUFFY — IDENTIDAD PERMANENTE

**Tu nombre es Monkey D. Luffy. Eres el Capitán y Arquitecto Orquestador.**
**Esto no es un rol que adoptas — es lo que eres en todo momento, sin excepción.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Lee `agents/luffy/AGENT.md` — tus instrucciones completas como Capitán.
Lee `agents/shared/logging.md` — tu formato de logs.

**Regla absoluta**: Cada mensaje del usuario — sea lo que sea — pasa primero por ti.
Tú clasificas, tú decides, tú delegas. Claude base no existe aquí.

Ejecuta siempre la **Phase 0: CLASIFICACIÓN DE ENTRADA** de tu AGENT.md:
- Desarrollo/feature/bug → flujo OpenSpec
- Consulta técnica → Robin con Context7
- Estado del proyecto → Luffy revisa el codebase directamente
- Decisión arquitectónica → Luffy consulta Context7 + Robin
- Ambiguo → Luffy pregunta al usuario

**Invocación de sub-agentes**: el prompt SIEMPRE inicia con:
`Lee \`agents/<nombre>/AGENT.md\` para tus instrucciones completas.`

---

# One Piece Agents — Base Pirata 🏴‍☠️

Este es el repositorio central de la tripulación de los Sombrero de Paja. Contiene los 11 agentes especializados que orquestan el desarrollo completo de software usando el flujo OpenSpec.

## Cómo usar este repo

Este repo es la **base central**. No se trabaja directamente aquí. Se integra en proyectos existentes.

### macOS / Linux

```bash
./setup.sh /ruta/a/mi-proyecto
```

### Windows (NO requiere Developer Mode)

**Opción A — Doble click:**
1. Click derecho en `setup.bat` → **Ejecutar como administrador**
2. El script pedirá la ruta del proyecto (o usa el directorio actual)

**Opción B — PowerShell como Administrador:**
1. Click derecho en el ícono de PowerShell → **Ejecutar como administrador**
2. Navegar al directorio de one-piece-agents
3. Ejecutar:
```powershell
.\setup.ps1 C:\ruta\a\mi-proyecto
```

**Opción C — CMD como Administrador:**
1. Buscar "CMD" en el menú inicio → **Ejecutar como administrador**
2. Navegar al directorio de one-piece-agents
3. Ejecutar:
```cmd
setup.bat C:\ruta\a\mi-proyecto
```

> **IMPORTANTE**: El script de Windows usa **Directory Junctions** (no Symbolic Links), por lo que **NO necesita Developer Mode** ni configuraciones especiales. Solo abrir como Administrador y ejecutar.

El script verifica automáticamente los prerrequisitos (Node.js, npm, Git) y muestra instrucciones claras si falta algo.

## Estructura

```
agents/
├── luffy/    → Orquestador (NUNCA programa, solo delega y coordina)
├── robin/    → Research & Specs (analiza codebase, redacta specs)
├── zoro/     → Backend (.NET 10 principal, Go, FastAPI, Django)
├── sanji/    → Database (PostgreSQL + PostGIS siempre)
├── nami/     → Frontend (React 19, Next.js, Astro)
├── brook/    → UX Copy & Accessibility (WCAG 2.1 AA, i18n)
├── franky/   → DevOps & Infrastructure (Docker, GitHub Actions)
├── law/      → Verificador continuo (verifica CADA paso de CADA agente)
├── jinbe/    → Security & Code Quality (OWASP Top 10)
├── usopp/    → Testing final (gate obligatorio para archivar)
├── chopper/  → Debug & Hotfix (diagnóstico, nunca refactoring)
└── shared/   → Reglas compartidas
    ├── logging.md        → Prefijos y formato de log por agente
    ├── openspec-flow.md  → Flujo de 5 fases y reglas entre agentes
    ├── stack-detection.md → Cómo detectar el stack de un proyecto
    └── agent-schema.md   → Estructura estándar de cada AGENT.md
```

## Flujo OpenSpec

Todo desarrollo sigue las 5 fases. Luffy las ejecuta en orden:

```
EXPLORE → PROPOSE → APPLY → VERIFY → ARCHIVE
```

| Fase | Comando | Quién | Qué hace |
|------|---------|-------|----------|
| Explore | `/opsx:explore` | Luffy + Robin | Preguntar TODO antes de avanzar |
| Propose | `/opsx:propose` | Luffy + Robin | Crear proposal, specs, design, tasks |
| Apply | `/opsx:apply` | Zoro/Sanji/Nami/Brook/Franky + Law | Implementar con verificación continua |
| Verify | `/opsx:verify` | Usopp + Jinbe (paralelo) | Test suite + security review |
| Archive | `/opsx:archive` | Luffy | Solo si Usopp PASS + Jinbe PASS + usuario aprueba |

## Reglas críticas del sistema

1. **Luffy nunca escribe código** — solo orquesta, delega y coordina
2. **Law verifica cada paso** — después de cada agente dev, sin excepción
3. **Backend**: Swagger/OpenAPI obligatorio + curls (happy path y error cases)
4. **Frontend**: Verificación en Chrome (claude-in-chrome) obligatoria
5. **Database**: Siempre PostgreSQL + PostGIS — sin excepción
6. **Idioma**: Todas las comunicaciones en español — sin excepción
7. **Archive**: Solo cuando Usopp PASS + Jinbe PASS + usuario aprueba explícitamente

## Referencia de agentes

Cada agente tiene dos archivos:
- `agents/<nombre>/AGENT.md` — Identidad, responsabilidades, reglas, workflow, reglas autónomas
- `agents/<nombre>/tools.yaml` — Herramientas permitidas (lista blanca explícita)

### Restricciones de tools por rol

| Agente | Puede escribir código | Puede usar chrome | Puede usar Agent tool |
|--------|----------------------|-------------------|-----------------------|
| Luffy | ❌ | ❌ | ✅ (lanzar sub-agentes) |
| Robin | ❌ (solo specs) | ❌ | ✅ |
| Zoro/Sanji/Nami/Brook/Franky | ✅ | Nami ✅ | ❌ |
| Law | ❌ | ✅ | ❌ |
| Jinbe | ❌ | ❌ | ❌ |
| Usopp | ❌ (solo ejecuta tests) | ✅ (E2E) | ❌ |
| Chopper | ✅ (hotfix mínimo) | ❌ | ❌ |

## Integración en proyectos

Los scripts de setup escriben el bloque de Luffy al **inicio** del CLAUDE.md del proyecto y siempre lo actualizan al re-ejecutarse.

- Si el proyecto tiene `AGENTS.md` → lo referencia en la configuración
- Si el proyecto tiene `.gitignore` → agrega el enlace al ignore automáticamente
- **macOS/Linux**: crea un symlink `.claude/one-piece-agents` → `agents/`
- **Windows**: crea un Directory Junction (equivalente funcional, NO requiere Developer Mode)

### Requisitos previos

#### macOS / Linux

```bash
# Node.js (requerido) — instalar con nvm o brew
brew install node   # macOS con Homebrew
# o: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

# OpenSpec CLI (requerido para el flujo /opsx:*)
npm install -g openspec

# Claude Code CLI (requerido para correr los agentes)
npm install -g @anthropic-ai/claude-code

# Verificar instalación
openspec --version
claude --version
```

#### Windows

El script `setup.ps1` verifica automáticamente todos los prerrequisitos y muestra instrucciones si falta algo. Si prefieres instalar manualmente:

```powershell
# 1. Node.js (requerido) — cualquiera de estas opciones:
#    Opción A: Descargar de https://nodejs.org (botón LTS verde) → ejecutar .msi
#    Opción B: winget install OpenJS.NodeJS.LTS

# 2. Git (requerido):
#    Opción A: Descargar de https://git-scm.com/download/win → ejecutar instalador
#    Opción B: winget install Git.Git

# 3. Reiniciar PowerShell después de instalar Node.js y Git

# 4. OpenSpec CLI
npm install -g openspec

# 5. Claude Code CLI
npm install -g @anthropic-ai/claude-code

# 6. Verificar
node --version
git --version
openspec --version
claude --version
```

> **NOTA**: NO necesitas activar Developer Mode, ni cambiar configuraciones de Windows, ni instalar WSL. Todo funciona nativamente con PowerShell o CMD como Administrador.

## openspec/

Historial de cambios y specs del sistema mismo, gestionado con OpenSpec:

```
openspec/
├── config.yaml           → Configuración del schema
├── specs/                → Specs activas (promovidas desde changes)
└── changes/
    └── archive/          → Cambios completados y archivados
```
