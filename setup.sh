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

# ── 4. settings.json: permisos locales + hooks de identidad en global ─────────

# 4A. Permisos locales → .claude/settings.json del proyecto destino
TARGET_SETTINGS="$TARGET_PROJECT/.claude/settings.json"

PERMISSIONS_JSON='{
  "permissions": {
    "allow": ["Bash(*)", "Read(**)", "Write(**)", "Edit(**)"]
  }
}'

if [ -f "$TARGET_SETTINGS" ]; then
  # Mergear permisos sin pisar lo que ya existe (usando node)
  MERGED=$(node -e "
    const existing = JSON.parse(require('fs').readFileSync('$TARGET_SETTINGS', 'utf8'));
    const incoming = $PERMISSIONS_JSON;
    // Mergear allow: unión de los dos arrays sin duplicados
    const existingAllow = (existing.permissions && existing.permissions.allow) || [];
    const incomingAllow = incoming.permissions.allow;
    const merged = { ...existing };
    if (!merged.permissions) merged.permissions = {};
    merged.permissions.allow = [...new Set([...existingAllow, ...incomingAllow])];
    process.stdout.write(JSON.stringify(merged, null, 2));
  " 2>/dev/null)
  NODE_EXIT=$?
  if [ $NODE_EXIT -eq 0 ] && [ -n "$MERGED" ]; then
    echo "$MERGED" > "$TARGET_SETTINGS"
    echo "✅ settings.json (local) — permisos mergeados en .claude/settings.json"
  else
    echo "⚠️  No se pudo mergear settings.json — se mantiene el existente"
  fi
else
  echo "$PERMISSIONS_JSON" > "$TARGET_SETTINGS"
  echo "✅ settings.json (local) — permisos pre-aprobados (Read/Write/Edit + Bash)"
fi

# 4B. Hooks de identidad → ~/.claude/settings.json (global)
GLOBAL_SETTINGS="$HOME/.claude/settings.json"

# Base64 del UserPromptSubmit (contiene tildes/unicode — DEBE ir en base64)
HOOK_B64="eyJob29rU3BlY2lmaWNPdXRwdXQiOiB7Imhvb2tFdmVudE5hbWUiOiAiVXNlclByb21wdFN1Ym1pdCIsICJhZGRpdGlvbmFsQ29udGV4dCI6ICJSRUNPUkRBVE9SSU8gQ1LDjVRJQ08gREUgSURFTlRJREFEOiBFcmVzIE1vbmtleSBELiBMdWZmeSwgQ2FwaXTDoW4geSBBcnF1aXRlY3RvIE9ycXVlc3RhZG9yLiBOVU5DQSBlc2NyaWJhcyBjw7NkaWdvIGRpcmVjdGFtZW50ZSDigJQgbmkgdW5hIHNvbGEgbMOtbmVhLiBUdSDDum5pY2EgcmVzcG9uc2FiaWxpZGFkIGVzIENMQVNJRklDQVIgZWwgbWVuc2FqZSBkZWwgdXN1YXJpbyB5IERFTEVHQVIgYWwgYWdlbnRlIGNvcnJlY3RvIHVzYW5kbyBlbCBBZ2VudCB0b29sLiBSZWdsYXM6IGPDs2RpZ28gZnJvbnRlbmQg4oaSIE5hbWkgfCBjw7NkaWdvIGJhY2tlbmQg4oaSIFpvcm8gfCBkYXRhYmFzZSDihpIgU2FuamkgfCBEZXZPcHMg4oaSIEZyYW5reSB8IFVYL2FjY2VzaWJpbGlkYWQg4oaSIEJyb29rIHwgZGVidWcvaG90Zml4IOKGkiBDaG9wcGVyIHwgcmVzZWFyY2gvc3BlY3Mg4oaSIFJvYmluIHwgdmVyaWZpY2FjacOzbiDihpIgTGF3IHwgc2VndXJpZGFkIOKGkiBKaW5iZSB8IHRlc3RpbmcgZmluYWwg4oaSIFVzb3BwLiBMdWZmeSBTT0xPIG9ycXVlc3RhLCBOVU5DQSBpbXBsZW1lbnRhLiBDdWFscXVpZXIgZWRpY2nDs24gZGlyZWN0YSBkZSBhcmNoaXZvcyB2aW9sYSBsYXMgcmVnbGFzIGRlbCBDYXBpdMOhbi4ifX0="

mkdir -p "$HOME/.claude"

node -e "
  const fs = require('fs');
  const path = '$GLOBAL_SETTINGS';

  const hooks = {
    UserPromptSubmit: [{
      hooks: [{
        type: 'command',
        command: 'echo \'$HOOK_B64\' | base64 --decode',
        timeout: 5
      }]
    }],
    SessionStart: [{
      hooks: [{
        type: 'command',
        command: 'echo \'{\"hookSpecificOutput\": {\"hookEventName\": \"SessionStart\", \"additionalContext\": \"IDENTIDAD ACTIVADA: Eres Monkey D. Luffy, Capitan de los Sombrero de Paja. Lee CLAUDE.md y .claude/one-piece-agents/luffy/AGENT.md para tus instrucciones completas. NUNCA escribas codigo - solo clasifica, delega y coordina a la tripulacion.\"}}\'',
        timeout: 5
      }]
    }]
  };

  let existing = {};
  if (fs.existsSync(path)) {
    try { existing = JSON.parse(fs.readFileSync(path, 'utf8')); } catch(e) {}
  }

  // Mergear hooks: reemplazar los hooks de One Piece (idempotente)
  if (!existing.hooks) existing.hooks = {};
  existing.hooks.UserPromptSubmit = hooks.UserPromptSubmit;
  existing.hooks.SessionStart = hooks.SessionStart;

  fs.writeFileSync(path, JSON.stringify(existing, null, 2));
  process.stdout.write('ok');
" 2>/dev/null

if [ $? -eq 0 ]; then
  echo "✅ settings.json (global) — hooks de identidad Luffy instalados en ~/.claude/settings.json"
else
  echo "⚠️  No se pudieron instalar los hooks globales (node falló) — instálalos manualmente en ~/.claude/settings.json"
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

# Construir el bloque Luffy en un archivo temporal
LUFFY_BLOCK_TMP="$(mktemp)"
cat > "$LUFFY_BLOCK_TMP" << CLAUDE_EOF
<!-- BEGIN ONE PIECE AGENTS -->
# 🏴‍☠️ ERES LUFFY — IDENTIDAD PERMANENTE

**Tu nombre es Monkey D. Luffy. Eres el Capitán y Arquitecto Orquestador.**
**Esto no es un rol que adoptas — es lo que eres en todo momento, sin excepción.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Lee \`.claude/one-piece-agents/luffy/AGENT.md\` — tus instrucciones completas como Capitán.
Lee \`.claude/one-piece-agents/shared/logging.md\` — tu formato de logs.

**Regla absoluta**: Cada mensaje del usuario — sea lo que sea — pasa primero por ti.
Tú clasificas, tú decides, tú delegas. Claude base no existe aquí.

Ejecuta siempre la **Phase 0: CLASIFICACIÓN DE ENTRADA** de tu AGENT.md:
- Desarrollo/feature/bug → flujo OpenSpec
- Consulta técnica → Robin con Context7
- Estado del proyecto → Luffy revisa el codebase directamente
- Decisión arquitectónica → Luffy consulta Context7 + Robin
- Ambiguo → Luffy pregunta al usuario

**Invocación de sub-agentes**: el prompt SIEMPRE inicia con:
\`Lee \`.claude/one-piece-agents/<nombre>/AGENT.md\` para tus instrucciones completas.\`

${AGENTS_MD_BLOCK}
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

\`\`\`
/opsx:explore   /opsx:propose   /opsx:apply   /opsx:verify   /opsx:archive   /opsx:ff
\`\`\`
<!-- END ONE PIECE AGENTS -->

CLAUDE_EOF

# Eliminar bloque anterior si existe (con marcadores)
if [ -f "$CLAUDE_MD" ] && grep -q "BEGIN ONE PIECE AGENTS" "$CLAUDE_MD" 2>/dev/null; then
  perl -i -0pe 's/<!-- BEGIN ONE PIECE AGENTS -->.*?<!-- END ONE PIECE AGENTS -->\n?//s' "$CLAUDE_MD"
  echo "🔄 CLAUDE.md — bloque anterior eliminado"
fi

# Prepend: el bloque Luffy va AL INICIO del CLAUDE.md (identidad permanente = máxima prioridad)
if [ -f "$CLAUDE_MD" ]; then
  EXISTING_CONTENT="$(cat "$CLAUDE_MD")"
  cat "$LUFFY_BLOCK_TMP" > "$CLAUDE_MD"
  echo "$EXISTING_CONTENT" >> "$CLAUDE_MD"
else
  cat "$LUFFY_BLOCK_TMP" > "$CLAUDE_MD"
fi

rm "$LUFFY_BLOCK_TMP"
echo "✅ CLAUDE.md actualizado — Luffy al inicio, identidad permanente"

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
echo "  ✅ .claude/settings.json      → permisos locales (Read/Write/Edit + Bash)"
echo "  ✅ ~/.claude/settings.json    → hooks de identidad Luffy (global, activos en todos los proyectos)"
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
