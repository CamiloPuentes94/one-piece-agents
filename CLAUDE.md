# One Piece Agents — Base Pirata 🏴‍☠️

Este es el repositorio central de la tripulación de los Sombrero de Paja. Contiene los 11 agentes especializados que orquestan el desarrollo completo de software usando el flujo OpenSpec.

## Cómo usar este repo

Este repo es la **base central**. No se trabaja directamente aquí. Se integra en proyectos existentes:

```bash
./setup.sh /ruta/a/mi-proyecto
```

El script crea un symlink en el proyecto destino y configura su `CLAUDE.md` para activar la tripulación.

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

El `setup.sh` detecta y respeta el contenido existente del proyecto:

- Si el proyecto tiene `CLAUDE.md` → agrega la sección de la tripulación al final
- Si el proyecto tiene `AGENTS.md` → lo referencia en la configuración
- Si el proyecto tiene `.gitignore` → agrega el symlink al ignore automáticamente
- El symlink `.claude/one-piece-agents` apunta a `agents/` de este repo

### Requisitos previos

```bash
# OpenSpec CLI (requerido para el flujo /opsx:*)
npm install -g openspec

# Claude Code CLI (requerido para correr los agentes)
npm install -g @anthropic-ai/claude-code

# Verificar instalación
openspec --version
claude --version
```

## openspec/

Historial de cambios y specs del sistema mismo, gestionado con OpenSpec:

```
openspec/
├── config.yaml           → Configuración del schema
├── specs/                → Specs activas (promovidas desde changes)
└── changes/
    └── archive/          → Cambios completados y archivados
```
