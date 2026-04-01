# One Piece Agents — Setup Script (Windows PowerShell)
# Integra la tripulación en un proyecto existente

$ErrorActionPreference = "Stop"

$agentsBase = $PSScriptRoot
$targetProject = if ($args[0]) { $args[0] } else { (Get-Location).Path }

# ── Verificar openspec instalado ───────────────────────────────────────────────
if (-not (Get-Command openspec -ErrorAction SilentlyContinue)) {
    Write-Host "❌ openspec no está instalado. Ejecuta: npm install -g openspec"
    exit 1
}

# ── Verificar que el directorio destino exista ─────────────────────────────────
if (-not (Test-Path $targetProject -PathType Container)) {
    Write-Host "❌ El directorio $targetProject no existe"
    exit 1
}

$targetProject = (Resolve-Path $targetProject).Path

Write-Host "🏴‍☠️ One Piece Agents — Setup"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "Base pirata:  $agentsBase"
Write-Host "Proyecto:     $targetProject"
Write-Host ""

# ── 1. Directorio .claude ──────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path (Join-Path $targetProject ".claude") | Out-Null

# ── 2. Symlink a los agentes ───────────────────────────────────────────────────
$symlink = Join-Path $targetProject ".claude\one-piece-agents"

if (Test-Path $symlink) {
    Remove-Item $symlink -Force -Recurse
}

try {
    New-Item -ItemType SymbolicLink -Path $symlink -Target (Join-Path $agentsBase "agents") | Out-Null
    Write-Host "✅ Symlink creado: .claude/one-piece-agents → $agentsBase\agents"
} catch {
    Write-Host "❌ No se pudo crear el symlink. Activa Developer Mode: Configuración → Sistema → Para desarrolladores → Modo desarrollador"
    exit 1
}

# ── 3. Detectar AGENTS.md existente ───────────────────────────────────────────
$agentsMd = ""
if (Test-Path (Join-Path $targetProject "AGENTS.md")) {
    $agentsMd = Join-Path $targetProject "AGENTS.md"
    Write-Host "📄 AGENTS.md detectado en el proyecto — se referenciará en la configuración"
} elseif (Test-Path (Join-Path $targetProject ".claude\AGENTS.md")) {
    $agentsMd = Join-Path $targetProject ".claude\AGENTS.md"
    Write-Host "📄 AGENTS.md detectado en .claude/ — se referenciará en la configuración"
}

# ── 4. Desplegar settings.json (permisos pre-aprobados para los agentes) ──────
$targetSettings = Join-Path $targetProject ".claude\settings.json"
$sourceSettings = Join-Path $agentsBase ".claude\settings.json"

if (Test-Path $targetSettings) {
    Write-Host "⚠️  .claude/settings.json ya existe en el proyecto — saltando"
} else {
    Copy-Item $sourceSettings $targetSettings
    Write-Host "✅ settings.json copiado — Read/Write/Edit y comandos de agentes pre-aprobados"
}

# ── 5. Inicializar openspec ───────────────────────────────────────────────────
Write-Host "⚙️  Inicializando openspec en el proyecto..."
Push-Location $targetProject
openspec init --tools claude
Pop-Location
Write-Host "✅ openspec inicializado (skills y commands en .claude/)"

# ── 6. Desplegar comandos One Piece (override de los genéricos de openspec) ────
$commandsSource = Join-Path $agentsBase "agents\commands\opsx"
$commandsTarget = Join-Path $targetProject ".claude\commands\opsx"

if (Test-Path $commandsSource) {
    New-Item -ItemType Directory -Force -Path $commandsTarget | Out-Null
    Copy-Item (Join-Path $commandsSource "*.md") $commandsTarget
    Write-Host "✅ Comandos One Piece desplegados — /opsx:explore, propose, apply, verify, archive"
}

# ── 7. Actualizar CLAUDE.md ────────────────────────────────────────────────────
$claudeMd = Join-Path $targetProject "CLAUDE.md"

# Construir bloque de AGENTS.md si existe
$agentsMdBlock = ""
if ($agentsMd) {
    $relativeAgentsMd = $agentsMd.Replace($targetProject + "\", "").Replace($targetProject + "/", "")
    $agentsMdBlock = @"

### Agentes del proyecto

Este proyecto tiene su propio archivo de agentes en ``$relativeAgentsMd``.
Lee ese archivo para entender los agentes y reglas específicas de este proyecto.
La tripulación One Piece se complementa con esas reglas — no las reemplaza.
"@
}

# Construir el bloque Luffy
$luffyBlock = @"
<!-- BEGIN ONE PIECE AGENTS -->
# 🏴‍☠️ ERES LUFFY — IDENTIDAD PERMANENTE

**Tu nombre es Monkey D. Luffy. Eres el Capitán y Arquitecto Orquestador.**
**Esto no es un rol que adoptas — es lo que eres en todo momento, sin excepción.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Lee ``.claude/one-piece-agents/luffy/AGENT.md`` — tus instrucciones completas como Capitán.
Lee ``.claude/one-piece-agents/shared/logging.md`` — tu formato de logs.

**Regla absoluta**: Cada mensaje del usuario — sea lo que sea — pasa primero por ti.
Tú clasificas, tú decides, tú delegas. Claude base no existe aquí.

Ejecuta siempre la **Phase 0: CLASIFICACIÓN DE ENTRADA** de tu AGENT.md:
- Desarrollo/feature/bug → flujo OpenSpec
- Consulta técnica → Robin con Context7
- Estado del proyecto → Luffy revisa el codebase directamente
- Decisión arquitectónica → Luffy consulta Context7 + Robin
- Ambiguo → Luffy pregunta al usuario

**Invocación de sub-agentes**: el prompt SIEMPRE inicia con:
``Lee ``.claude/one-piece-agents/<nombre>/AGENT.md`` para tus instrucciones completas.``
$agentsMdBlock
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

``````
/opsx:explore   /opsx:propose   /opsx:apply   /opsx:verify   /opsx:archive   /opsx:ff
``````
<!-- END ONE PIECE AGENTS -->

"@

# Eliminar bloque anterior si existe (con marcadores)
if (Test-Path $claudeMd) {
    $content = Get-Content $claudeMd -Raw
    if ($content -match '<!-- BEGIN ONE PIECE AGENTS -->') {
        $content = $content -replace '(?s)<!-- BEGIN ONE PIECE AGENTS -->.*?<!-- END ONE PIECE AGENTS -->\r?\n?', ''
        Set-Content $claudeMd $content -NoNewline
        Write-Host "🔄 CLAUDE.md — bloque anterior eliminado"
    }
}

# Prepend: el bloque Luffy va AL INICIO del CLAUDE.md (identidad permanente = máxima prioridad)
if (Test-Path $claudeMd) {
    $existingContent = Get-Content $claudeMd -Raw
    Set-Content $claudeMd ($luffyBlock + $existingContent) -NoNewline
} else {
    Set-Content $claudeMd $luffyBlock -NoNewline
}

Write-Host "✅ CLAUDE.md actualizado — Luffy al inicio, identidad permanente"

# ── 8. Actualizar .gitignore ───────────────────────────────────────────────────
$gitignore = Join-Path $targetProject ".gitignore"
if (Test-Path $gitignore) {
    $gitignoreContent = Get-Content $gitignore -Raw
    if ($gitignoreContent -notmatch '\.claude/one-piece-agents') {
        Add-Content $gitignore "`n# One Piece Agents (symlink al repo central — no versionar)`n.claude/one-piece-agents"
        Write-Host "✅ .gitignore actualizado"
    }
}

# ── 9. Resumen ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "🏴‍☠️ ¡La tripulación está lista para zarpar!"
Write-Host ""
Write-Host "  Lo que se instaló:"
Write-Host "  ✅ .claude/one-piece-agents/  → symlink a los 11 agentes"
Write-Host "  ✅ .claude/settings.json      → permisos pre-aprobados (Read/Write/Edit + Bash)"
Write-Host "  ✅ .claude/commands/opsx/     → comandos One Piece (explore/propose/apply/verify/archive)"
Write-Host "  ✅ CLAUDE.md                  → instrucción de activación de Luffy"
Write-Host ""
Write-Host "  Siguiente paso:"
Write-Host "  1. Reinicia Claude Code (para cargar los nuevos skills y commands)"
Write-Host "  2. Abre el proyecto y describe tu misión"
Write-Host "  3. Luffy se encarga del resto — /opsx:explore para empezar"
Write-Host ""
if ($agentsMd) {
    $relative = $agentsMd.Replace($targetProject + "\", "").Replace($targetProject + "/", "")
    Write-Host "  📄 AGENTS.md del proyecto: $relative (referenciado en CLAUDE.md)"
    Write-Host ""
}
