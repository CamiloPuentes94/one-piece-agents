#!/bin/bash
# One Piece Agents — Setup Script
# Configura un proyecto existente para usar la tripulación

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
echo "Base pirata: $AGENTS_BASE"
echo "Proyecto:    $TARGET_PROJECT"
echo ""

# Create .claude directory if it doesn't exist
mkdir -p "$TARGET_PROJECT/.claude"

# Create symlink to agents
if [ -L "$TARGET_PROJECT/.claude/one-piece-agents" ]; then
  rm "$TARGET_PROJECT/.claude/one-piece-agents"
fi
ln -s "$AGENTS_BASE/agents" "$TARGET_PROJECT/.claude/one-piece-agents"
echo "✅ Symlink creado: .claude/one-piece-agents → $AGENTS_BASE/agents"

# Create or append to CLAUDE.md
CLAUDE_MD="$TARGET_PROJECT/CLAUDE.md"

# Check if already configured
if [ -f "$CLAUDE_MD" ] && grep -q "One Piece Agents" "$CLAUDE_MD" 2>/dev/null; then
  echo "⚠️  CLAUDE.md ya tiene configuración de One Piece Agents, saltando..."
else
  # Append to existing or create new
  cat >> "$CLAUDE_MD" << 'CLAUDE_EOF'

# One Piece Agents — Tripulación Activa 🏴‍☠️

## Sistema de Agentes

Este proyecto usa el sistema One Piece Agents para desarrollo. Los agentes están en `.claude/one-piece-agents/`.

### Cómo funciona

El usuario interactúa con **Luffy** (orquestador) quien delega a agentes especializados:

| Agente | Rol | Cuándo |
|--------|-----|--------|
| 🏴‍☠️ Luffy | Orquestador — no programa, delega | Siempre |
| 📚 Robin | Research & Specs | Explore, Propose |
| ⚔️ Zoro | Backend | Apply |
| 🍳 Sanji | Database (PostgreSQL+PostGIS) | Apply |
| 🗺️ Nami | Frontend | Apply |
| 🎵 Brook | UX Copy & A11y | Apply |
| 🔧 Franky | DevOps & Infra | Apply |
| ⚕️ Law | Verificador continuo | Después de cada paso |
| 🌊 Jinbe | Security | Verify |
| 🎯 Usopp | Testing final | Verify |
| 🩺 Chopper | Debug & Hotfix | Cuando hay bugs |

### Flujo OpenSpec

```
EXPLORE → PROPOSE → APPLY → VERIFY → ARCHIVE
(Luffy)   (Luffy)   (Crew)   (Usopp    (Luffy)
                     +Law     +Jinbe)
```

### Reglas Estrictas

1. **Backend**: Swagger/OpenAPI + curls obligatorios en cada endpoint
2. **Frontend**: Verificación en Chrome (claude-in-chrome) obligatoria en cada componente
3. **Law verifica CADA paso** — no se salta nunca
4. **3 capas de verificación**: Law (paso a paso) → Jinbe (seguridad) → Usopp (tests finales)
5. **Luffy pregunta TODO** en explore antes de avanzar

### Para invocar la tripulación

Describe tu misión y el orquestador (Luffy) se encargará de:
1. Preguntar todo lo necesario (explore)
2. Crear el plan (propose)
3. Delegar a los agentes correctos (apply)
4. Verificar cada paso (Law) y al final (Usopp + Jinbe)
5. Archivar cuando todo está verificado

### Referencia de agentes

Para ver la configuración detallada de cada agente, lee:
- `.claude/one-piece-agents/<nombre>/AGENT.md` — System prompt completo
- `.claude/one-piece-agents/<nombre>/tools.yaml` — Herramientas permitidas
- `.claude/one-piece-agents/shared/` — Reglas compartidas
CLAUDE_EOF

  echo "✅ CLAUDE.md actualizado con configuración One Piece Agents"
fi

# Create .gitignore entry for symlink (optional)
GITIGNORE="$TARGET_PROJECT/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -q ".claude/one-piece-agents" "$GITIGNORE" 2>/dev/null; then
    echo "" >> "$GITIGNORE"
    echo "# One Piece Agents (symlink to central repo)" >> "$GITIGNORE"
    echo ".claude/one-piece-agents" >> "$GITIGNORE"
    echo "✅ .gitignore actualizado"
  fi
fi

echo ""
echo "🏴‍☠️ ¡La tripulación está lista para zarpar!"
echo ""
echo "Siguiente paso: abre el proyecto con Claude Code y describe tu misión."
echo "Luffy se encargará del resto."
