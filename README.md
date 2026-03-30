# 🏴‍☠️ One Piece Agents

Sistema multi-agente temático de One Piece para desarrollo de software completo. 11 agentes especializados coordinados por Luffy que cubren desde el diseño hasta la verificación de seguridad, integrado con el flujo OpenSpec.

## ¿Qué es esto?

En lugar de hablar directamente con un LLM para programar, describes tu misión a **Luffy** (el orquestador) y él coordina a la tripulación completa:

- Robin analiza el codebase y redacta las specs
- Zoro implementa el backend con Swagger y curls
- Sanji diseña y migra la base de datos
- Nami implementa el frontend y lo verifica en Chrome
- Law verifica cada paso antes de continuar
- Usopp y Jinbe hacen la verificación final antes de archivar

Todo bajo el flujo **OpenSpec**: `explore → propose → apply → verify → archive`.

## Tripulación

| Agente | Rol | Especialidad |
|--------|-----|--------------|
| 🏴‍☠️ **Luffy** | Orquestador | Nunca programa — solo delega y coordina |
| 📚 **Robin** | Research & Specs | Análisis de codebase, contratos de API |
| ⚔️ **Zoro** | Backend | .NET 10 (principal), Go, FastAPI, Django |
| 🍳 **Sanji** | Database | PostgreSQL + PostGIS siempre |
| 🗺️ **Nami** | Frontend | React 19, Next.js, Astro |
| 🎵 **Brook** | UX & Accesibilidad | WCAG 2.1 AA, i18n, copy en español |
| 🔧 **Franky** | DevOps | Docker multi-stage, GitHub Actions |
| ⚕️ **Law** | Verificador continuo | Verifica cada paso de cada agente |
| 🌊 **Jinbe** | Seguridad | OWASP Top 10, revisión completa |
| 🎯 **Usopp** | Testing final | Gate obligatorio para archivar |
| 🩺 **Chopper** | Debug & Hotfix | Diagnóstico y corrección de bugs |

## Instalación

```bash
# Clonar este repo una sola vez en tu máquina
git clone https://github.com/CamiloPuentes94/one-piece-agents.git

# Integrar en cualquier proyecto existente
./one-piece-agents/setup.sh /ruta/a/tu-proyecto
```

El script:
- Crea el symlink `.claude/one-piece-agents` → `agents/` de este repo
- Detecta si el proyecto ya tiene `AGENTS.md` y lo referencia sin reemplazarlo
- Agrega la sección de la tripulación al `CLAUDE.md` del proyecto sin borrar el contenido existente
- Agrega el symlink al `.gitignore` automáticamente

### Requisitos

```bash
npm install -g openspec          # CLI para el flujo /opsx:*
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
```

## Uso

Abre tu proyecto con Claude Code y describe tu misión. Luffy inicia el flujo completo:

```
Tú:   "Necesito un sistema de autenticación con JWT para mi API en .NET 10"

Luffy: ¡Shishishi! ¡Nueva misión, nakama! Antes de armar el plan, necesito
       entender algunas cosas...
       1. ¿Los usuarios se registran en el sistema o vienen de un IdP externo?
       2. ¿Necesitas refresh tokens o solo access tokens?
       3. ¿Hay roles o permisos? ¿Cuáles?
```

### Comandos disponibles

| Comando | Descripción |
|---------|-------------|
| `/opsx:explore` | Luffy entra en modo interrogador — pregunta todo antes de avanzar |
| `/opsx:propose` | Crea proposal, specs, design y tasks |
| `/opsx:apply` | Implementa con los agentes especializados |
| `/opsx:verify` | Verificación final con Usopp y Jinbe en paralelo |
| `/opsx:archive` | Archiva el cambio (requiere Usopp PASS + Jinbe PASS) |
| `/opsx:ff` | Fast-forward — crea todos los artefactos de una vez |

## Flujo completo

```
┌─────────────────────────────────────────────────────────┐
│                    MISIÓN DEL USUARIO                   │
└──────────────────────────┬──────────────────────────────┘
                           │
                    🏴‍☠️ LUFFY
                 (orquestador)
                           │
          ┌────────────────┼────────────────┐
          │                │                │
      📚 Robin         ⚔️ Zoro          🍳 Sanji
     (specs)          (backend)        (database)
          │                │                │
          └────────────────┼────────────────┘
                           │
                    ⚕️ LAW verifica cada paso
                           │
          ┌────────────────┼────────────────┐
          │                                 │
      🌊 Jinbe                          🎯 Usopp
    (seguridad)                        (tests)
          │                                 │
          └────────────────┬────────────────┘
                           │
                    🏴‍☠️ LUFFY archiva
```

## Reglas del sistema

1. **Luffy nunca escribe código** — solo orquesta
2. **Law verifica cada paso** — sin excepción
3. **Backend**: Swagger/OpenAPI + curls en cada endpoint
4. **Frontend**: Verificación en Chrome obligatoria
5. **Database**: PostgreSQL + PostGIS siempre
6. **Idioma**: Todas las comunicaciones en español
7. **Archive**: Solo con Usopp PASS + Jinbe PASS + aprobación del usuario

## Estructura del repo

```
agents/
├── luffy/          → AGENT.md + tools.yaml
├── robin/
├── zoro/
├── sanji/
├── nami/
├── brook/
├── franky/
├── law/
├── jinbe/
├── usopp/
├── chopper/
└── shared/
    ├── logging.md          → Prefijos de log por agente
    ├── openspec-flow.md    → Referencia del flujo de 5 fases
    ├── stack-detection.md  → Detección automática de tech stack
    └── agent-schema.md     → Estructura estándar de AGENT.md

openspec/
├── specs/          → Specs activas del sistema
└── changes/archive → Cambios completados
```

## Landing page

[agents-one-piece.camandrefactory.com](https://agents-one-piece.camandrefactory.com) — documentación visual del sistema.

## Licencia

MIT
