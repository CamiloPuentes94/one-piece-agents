#!/bin/bash
# One Piece Agents — Setup Script
# Integra la tripulación en un proyecto existente

set -e

AGENTS_BASE="$(cd "$(dirname "$0")" && pwd)"
TARGET_PROJECT="${1:-.}"

if [ ! -d "$TARGET_PROJECT" ]; then
  echo "❌ El directorio $TARGET_PROJECT no existe"
  exit 1
fi

TARGET_PROJECT="$(cd "$TARGET_PROJECT" && pwd)"

echo "🏴‍☠️ One Piece Agents — Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Base pirata:  $AGENTS_BASE"
echo "Proyecto:     $TARGET_PROJECT"
echo ""

# ── 1. Directorio .claude ──────────────────────────────────────────────────────
mkdir -p "$TARGET_PROJECT/.claude"

# ── 2. Symlink a los agentes ───────────────────────────────────────────────────
SYMLINK="$TARGET_PROJECT/.claude/one-piece-agents"
if [ -L "$SYMLINK" ]; then
  rm "$SYMLINK"
fi
ln -s "$AGENTS_BASE/agents" "$SYMLINK"
echo "✅ Symlink creado: .claude/one-piece-agents → $AGENTS_BASE/agents"

# ── 3. Detectar AGENTS.md existente ───────────────────────────────────────────
AGENTS_MD=""
if [ -f "$TARGET_PROJECT/AGENTS.md" ]; then
  AGENTS_MD="$TARGET_PROJECT/AGENTS.md"
  echo "📄 AGENTS.md detectado en el proyecto — se referenciará en la configuración"
elif [ -f "$TARGET_PROJECT/.claude/AGENTS.md" ]; then
  AGENTS_MD="$TARGET_PROJECT/.claude/AGENTS.md"
  echo "📄 AGENTS.md detectado en .claude/ — se referenciará en la configuración"
fi

# ── 4. Desplegar settings.json (permisos pre-aprobados para los agentes) ──────
TARGET_SETTINGS="$TARGET_PROJECT/.claude/settings.json"
SOURCE_SETTINGS="$AGENTS_BASE/.claude/settings.json"

if [ -f "$TARGET_SETTINGS" ]; then
  echo "⚠️  .claude/settings.json ya existe en el proyecto — saltando"
else
  cp "$SOURCE_SETTINGS" "$TARGET_SETTINGS"
  echo "✅ settings.json copiado — Read/Write/Edit y comandos de agentes pre-aprobados"
fi

# ── 5. Inicializar openspec ───────────────────────────────────────────────────
if ! command -v openspec &> /dev/null; then
  echo "❌ openspec no está instalado. Instalando..."
  npm install -g openspec
fi

echo "⚙️  Inicializando openspec en el proyecto..."
(cd "$TARGET_PROJECT" && openspec init --tools claude)
echo "✅ openspec inicializado (skills y commands en .claude/)"

# ── 6. Desplegar comandos One Piece (override de los genéricos de openspec) ────
COMMANDS_SOURCE="$AGENTS_BASE/agents/commands/opsx"
COMMANDS_TARGET="$TARGET_PROJECT/.claude/commands/opsx"

if [ -d "$COMMANDS_SOURCE" ]; then
  mkdir -p "$COMMANDS_TARGET"
  cp "$COMMANDS_SOURCE"/*.md "$COMMANDS_TARGET/"
  echo "✅ Comandos One Piece desplegados — /opsx:explore, propose, apply, verify, archive"
fi

# ── 7. Actualizar CLAUDE.md ────────────────────────────────────────────────────
CLAUDE_MD="$TARGET_PROJECT/CLAUDE.md"

if [ -f "$CLAUDE_MD" ] && grep -q "One Piece Agents" "$CLAUDE_MD" 2>/dev/null; then
  echo "⚠️  CLAUDE.md ya tiene configuración de One Piece Agents — saltando"
else
  # Construir bloque de AGENTS.md si existe
  if [ -n "$AGENTS_MD" ]; then
    RELATIVE_AGENTS_MD="${AGENTS_MD#$TARGET_PROJECT/}"
    AGENTS_MD_BLOCK="
### Agentes del proyecto

Este proyecto tiene su propio archivo de agentes en \`$RELATIVE_AGENTS_MD\`.
Lee ese archivo para entender los agentes y reglas específicas de este proyecto.
La tripulación One Piece se complementa con esas reglas — no las reemplaza.
"
  else
    AGENTS_MD_BLOCK=""
  fi

  # Escribir el bloque principal con activación de Luffy
  cat >> "$CLAUDE_MD" << CLAUDE_EOF

# One Piece Agents — Tripulación Activa 🏴‍☠️

## INSTRUCCIÓN CRÍTICA — ACTIVACIÓN DE LA TRIPULACIÓN

**Esta instrucción aplica SOLO cuando el usuario humano inicia una conversación.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Cuando el usuario describa una misión, un feature, un bug o cualquier trabajo de desarrollo:

1. **Lee** \`.claude/one-piece-agents/luffy/AGENT.md\` — eres Luffy, el orquestador
2. **Lee** \`.claude/one-piece-agents/shared/openspec-flow.md\` — las 5 fases del flujo
3. **Lee** \`.claude/one-piece-agents/shared/logging.md\` — formato de logs obligatorio
4. **Adopta el rol de Luffy** y ejecuta el flujo OpenSpec

**Nota de rutas**: Todos los archivos de los agentes están en \`.claude/one-piece-agents/\`.

**Invocación de sub-agentes (Agent tool)**: El prompt de cada sub-agente SIEMPRE debe iniciar con:
\`\`\`
Lee \`.claude/one-piece-agents/<nombre>/AGENT.md\` para tus instrucciones completas.
\`\`\`
${AGENTS_MD_BLOCK}
---

## Orquestador: Luffy

Describe tu misión y Luffy coordina todo el flujo:

1. **Explore** — pregunta todo lo necesario antes de avanzar
2. **Propose** — crea proposal, specs, design y tasks
3. **Apply** — delega a los agentes correctos, Law verifica cada paso
4. **Verify** — Usopp (tests) + Jinbe (seguridad) en paralelo
5. **Archive** — solo cuando todo pasa y el usuario aprueba

## Tripulación

| Agente | Rol | Fase |
|--------|-----|------|
| 🏴‍☠️ Luffy | Orquestador — nunca programa | Todas |
| 📚 Robin | Research & Specs | Explore, Propose |
| ⚔️ Zoro | Backend (.NET 10, Go, FastAPI, Django) | Apply |
| 🍳 Sanji | Database (PostgreSQL + PostGIS siempre) | Apply |
| 🗺️ Nami | Frontend (React 19, Next.js, Astro) | Apply |
| 🎵 Brook | UX Copy & Accessibility (WCAG 2.1 AA) | Apply |
| 🔧 Franky | DevOps & Infrastructure (Docker, CI/CD) | Apply |
| ⚕️ Law | Verificador continuo — verifica cada paso | Apply (continuo) |
| 🌊 Jinbe | Security Review (OWASP Top 10) | Verify |
| 🎯 Usopp | Testing final — gate para archive | Verify |
| 🩺 Chopper | Debug & Hotfix | Cuando hay bugs |

## Reglas del sistema

- **Idioma**: SIEMPRE en español — sin excepciones
- **Backend**: Swagger/OpenAPI + curls obligatorios en cada endpoint
- **Frontend**: Verificación en Chrome obligatoria en cada componente
- **Database**: PostgreSQL + PostGIS — siempre
- **Law**: verifica después de cada agente dev — nunca se salta
- **Archive**: solo si Usopp PASS + Jinbe PASS + usuario aprueba

## Comandos disponibles

\`\`\`
/opsx:explore   → Luffy en modo INTERROGADOR — explorar la misión
/opsx:propose   → Luffy crea el plan completo (proposal, specs, design, tasks)
/opsx:apply     → Luffy delega a la tripulación — agentes implementan, Law verifica
/opsx:verify    → Usopp + Jinbe en paralelo — verificación final
/opsx:archive   → Archive con git commit — solo si todo aprobado
/opsx:ff        → Fast-forward: todos los artefactos de una vez
\`\`\`

## Referencia completa

- \`.claude/one-piece-agents/<agente>/AGENT.md\` — System prompt del agente
- \`.claude/one-piece-agents/<agente>/tools.yaml\` — Tools permitidas
- \`.claude/one-piece-agents/shared/\` — Reglas compartidas (logging, flujo, stacks)
CLAUDE_EOF

  echo "✅ CLAUDE.md actualizado con instrucción de activación y configuración de la tripulación"
fi

# ── 8. Actualizar .gitignore ───────────────────────────────────────────────────
GITIGNORE="$TARGET_PROJECT/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -q ".claude/one-piece-agents" "$GITIGNORE" 2>/dev/null; then
    printf "\n# One Piece Agents (symlink al repo central — no versionar)\n.claude/one-piece-agents\n" >> "$GITIGNORE"
    echo "✅ .gitignore actualizado"
  fi
fi

# ── 9. Resumen ─────────────────────────────────────────────────────────────────
echo ""
echo "🏴‍☠️ ¡La tripulación está lista para zarpar!"
echo ""
echo "  Lo que se instaló:"
echo "  ✅ .claude/one-piece-agents/  → symlink a los 11 agentes"
echo "  ✅ .claude/settings.json      → permisos pre-aprobados (Read/Write/Edit + Bash)"
echo "  ✅ .claude/commands/opsx/     → comandos One Piece (explore/propose/apply/verify/archive)"
echo "  ✅ CLAUDE.md                  → instrucción de activación de Luffy"
echo ""
echo "  Siguiente paso:"
echo "  1. Reinicia Claude Code (para cargar los nuevos skills y commands)"
echo "  2. Abre el proyecto y describe tu misión"
echo "  3. Luffy se encarga del resto — /opsx:explore para empezar"
echo ""
if [ -n "$AGENTS_MD" ]; then
  RELATIVE="${AGENTS_MD#$TARGET_PROJECT/}"
  echo "  📄 AGENTS.md del proyecto: $RELATIVE (referenciado en CLAUDE.md)"
  echo ""
fi
