# 🏴‍☠️ One Piece Agents

Sistema multi-agente temático de One Piece para desarrollo de software completo. 11 agentes especializados coordinados por Luffy que cubren desde el diseño hasta la verificación de seguridad, integrado con el flujo OpenSpec.

## ¿Qué es esto?

En lugar de hablar directamente con un LLM para programar, describes tu misión a **Luffy** (el orquestador) y él coordina a la tripulación completa:

- Robin analiza el codebase y redacta las specs
- Zoro implementa el backend con Swagger y curls verificados
- Sanji diseña el schema y las migraciones
- Nami implementa el frontend y lo verifica en Chrome
- Law verifica cada paso antes de continuar al siguiente
- Usopp y Jinbe hacen la verificación final antes de archivar

Todo bajo el flujo **OpenSpec**: `explore → propose → apply → verify → archive`.

Cada agente anuncia en tiempo real lo que está haciendo: qué archivos lee, qué crea, qué comandos ejecuta.

## Tripulación

| Agente | Rol | Especialidad |
|--------|-----|--------------|
| 🏴‍☠️ **Luffy** | Orquestador | Nunca programa — solo delega y coordina |
| 📚 **Robin** | Research & Specs | Análisis de codebase, contratos de API |
| ⚔️ **Zoro** | Backend | .NET 10 (principal), Go, FastAPI, Django |
| 🍳 **Sanji** | Database | PostgreSQL + PostGIS siempre |
| 🗺️ **Nami** | Frontend | React 19, Next.js, Nuxt 4, Angular 21, Astro |
| 🎵 **Brook** | UX & Accesibilidad | WCAG 2.1 AA, i18n, copy |
| 🔧 **Franky** | DevOps | Docker multi-stage, GitHub Actions |
| ⚕️ **Law** | Verificador continuo | Verifica cada paso de cada agente |
| 🌊 **Jinbe** | Seguridad | OWASP Top 10, revisión completa |
| 🎯 **Usopp** | Testing final | Gate obligatorio para archivar |
| 🩺 **Chopper** | Debug & Hotfix | Diagnóstico y corrección de bugs |

## Instalación

```bash
# 1. Clonar este repo una sola vez en tu máquina
git clone https://github.com/CamiloPuentes94/one-piece-agents.git

# 2. Integrar en cualquier proyecto existente
./one-piece-agents/setup.sh /ruta/a/tu-proyecto
```

El script hace todo automáticamente:

| Paso | Qué hace |
|------|----------|
| Symlink | `.claude/one-piece-agents` → `agents/` de este repo |
| Permisos | Despliega `settings.json` — Read/Write/Edit y Bash pre-aprobados |
| OpenSpec | Corre `openspec init --tools claude` — instala skills y commands base |
| Comandos | Despliega los comandos One Piece — `/opsx:explore/propose/apply/verify/archive` |
| `CLAUDE.md` | Agrega instrucción de activación de Luffy sin borrar lo existente |
| `AGENTS.md` | Si el proyecto tiene uno, lo detecta y lo referencia |
| `.gitignore` | Agrega el symlink automáticamente |

> Si `openspec` no está instalado, el script lo instala con `npm install -g openspec`.

### Instalación en Windows

#### Requisitos previos (obligatorios antes de correr el setup)

1. **Node.js** instalado — [nodejs.org](https://nodejs.org)
2. **openspec** instalado manualmente (en Windows no se instala automático):
   ```cmd
   npm install -g openspec
   ```
3. **Permisos para crear symlinks** — elige una opción:
   - **Developer Mode** (recomendado): `Configuración → Sistema → Para desarrolladores → Modo desarrollador`
   - O ejecutar la terminal **como Administrador**

#### Pasos de instalación

Desde **CMD**:
```cmd
setup.bat C:\ruta\a\tu-proyecto
```

Desde **PowerShell**:
```powershell
.\setup.ps1 C:\ruta\a\tu-proyecto
```

> **¿Tienes Git Bash?** El `setup.sh` original funciona igual que en Unix — no necesitas `setup.bat` ni `setup.ps1`.

### Requisito único

```bash
npm install -g @anthropic-ai/claude-code  # Claude Code CLI
```

## Uso

Abre tu proyecto con Claude Code y describe tu misión:

```
Tú:   "Necesito un sistema de autenticación con JWT para mi API en .NET 10"

Luffy: [🏴‍☠️ LUFFY] 🚀 MISIÓN | Auth con JWT — .NET 10
       ¡Shishishi! Antes de armar el plan, nakama...
       1. ¿Registro propio o IdP externo (Google, Azure AD)?
       2. ¿Necesitas refresh tokens?
       3. ¿Hay roles o permisos?
```

Los agentes reportan en tiempo real mientras trabajan:

```
[🏴‍☠️ LUFFY] → [🍳 SANJI] | Schema: tabla users + tabla sessions
[🍳 SANJI] 🚀 INICIO | Schema users + sessions — PostgreSQL + PostGIS
[🍳 SANJI] 📖 LEYENDO | openspec/changes/auth/specs/users/spec.md
[🍳 SANJI] ✏️ CREANDO | migrations/20260330_create_users.sql
[🍳 SANJI] ▶️ EJECUTANDO | psql — aplicando migración UP
[🍳 SANJI] ✅ COMPLETO | Migración lista — UP/DOWN verificados
[🏴‍☠️ LUFFY] → [⚕️ LAW] | Verificar migración de Sanji
[⚕️ LAW] ✅ PASS | Schema correcto, migración ejecuta sin errores
[🏴‍☠️ LUFFY] → [⚔️ ZORO] | Implementar POST /api/auth/login
[⚔️ ZORO] 🚀 INICIO | POST /api/auth/login — .NET 10 ASP.NET Core
[⚔️ ZORO] 📖 LEYENDO | src/controllers/, src/services/
[⚔️ ZORO] ✏️ CREANDO | src/controllers/AuthController.cs
[⚔️ ZORO] ✏️ CREANDO | src/services/AuthService.cs
[⚔️ ZORO] ▶️ EJECUTANDO | curl POST /api/auth/login (happy path)
[⚔️ ZORO] ▶️ EJECUTANDO | curl POST /api/auth/login (credenciales inválidas)
[⚔️ ZORO] ✅ COMPLETO | Controller ✅ | Swagger ✅ | 3/3 curls ✅
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
    (seguridad)                         (tests)
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
├── commands/
│   └── opsx/               → Comandos /opsx:* One Piece (se despliegan via setup.sh)
└── shared/
    ├── logging.md          → Protocolo de comunicación en tiempo real
    ├── openspec-flow.md    → Referencia del flujo de 5 fases
    ├── stack-detection.md  → Detección automática de tech stack
    └── agent-schema.md     → Estructura estándar de AGENT.md

.claude/
└── settings.json           → Permisos pre-aprobados (se despliega via setup.sh)

openspec/
├── specs/          → Specs activas del sistema
└── changes/archive → Cambios completados
```

## Landing page

[agents-one-piece.camandrefactory.com](https://agents-one-piece.camandrefactory.com)

## Licencia

MIT
