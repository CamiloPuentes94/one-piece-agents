# One Piece Agents — Setup Script (Windows PowerShell)
# Integra la tripulación en un proyecto existente
#
# USO:
#   1. Abrir PowerShell como Administrador (click derecho → Ejecutar como administrador)
#   2. Ejecutar: .\setup.ps1 C:\ruta\a\mi-proyecto
#   3. Si no se pasa ruta, se usa el directorio actual
#
# NOTA: NO requiere Developer Mode. Usa Directory Junctions en vez de Symlinks.

$ErrorActionPreference = "Stop"

$agentsBase = $PSScriptRoot
$targetProject = if ($args[0]) { $args[0] } else { (Get-Location).Path }

Write-Host ""
Write-Host "🏴‍☠️ One Piece Agents — Setup (Windows)" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# ══════════════════════════════════════════════════════════════════════════════
# PASO 0: Verificar prerrequisitos
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "🔍 Verificando prerrequisitos..." -ForegroundColor Yellow
Write-Host ""

$prereqsFailed = $false

# ── Node.js ───────────────────────────────────────────────────────────────────
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = (node --version) 2>$null
    Write-Host "  ✅ Node.js $nodeVersion detectado" -ForegroundColor Green
} else {
    Write-Host "  ❌ Node.js no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "     Para instalar Node.js:" -ForegroundColor White
    Write-Host "     Opción 1 — Instalador oficial:" -ForegroundColor White
    Write-Host "       1. Ve a https://nodejs.org" -ForegroundColor Gray
    Write-Host "       2. Descarga la versión LTS (botón verde)" -ForegroundColor Gray
    Write-Host "       3. Ejecuta el instalador (.msi) con todas las opciones por defecto" -ForegroundColor Gray
    Write-Host "       4. Reinicia PowerShell y vuelve a ejecutar este script" -ForegroundColor Gray
    Write-Host ""
    Write-Host "     Opción 2 — Con winget (si lo tienes):" -ForegroundColor White
    Write-Host "       winget install OpenJS.NodeJS.LTS" -ForegroundColor Cyan
    Write-Host "       (Reinicia PowerShell después de instalar)" -ForegroundColor Gray
    Write-Host ""
    $prereqsFailed = $true
}

# ── npm ───────────────────────────────────────────────────────────────────────
if (Get-Command npm -ErrorAction SilentlyContinue) {
    $npmVersion = (npm --version) 2>$null
    Write-Host "  ✅ npm $npmVersion detectado" -ForegroundColor Green
} else {
    if (-not $prereqsFailed) {
        Write-Host "  ❌ npm no está disponible (se instala con Node.js)" -ForegroundColor Red
        Write-Host "     Instala Node.js primero (ver instrucciones arriba)" -ForegroundColor Gray
        $prereqsFailed = $true
    }
}

# ── Git ───────────────────────────────────────────────────────────────────────
if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVersion = (git --version) 2>$null
    Write-Host "  ✅ $gitVersion detectado" -ForegroundColor Green
} else {
    Write-Host "  ❌ Git no está instalado" -ForegroundColor Red
    Write-Host ""
    Write-Host "     Para instalar Git:" -ForegroundColor White
    Write-Host "     Opción 1 — Instalador oficial:" -ForegroundColor White
    Write-Host "       1. Ve a https://git-scm.com/download/win" -ForegroundColor Gray
    Write-Host "       2. Descarga y ejecuta el instalador" -ForegroundColor Gray
    Write-Host "       3. Acepta todas las opciones por defecto" -ForegroundColor Gray
    Write-Host "       4. Reinicia PowerShell y vuelve a ejecutar este script" -ForegroundColor Gray
    Write-Host ""
    Write-Host "     Opción 2 — Con winget:" -ForegroundColor White
    Write-Host "       winget install Git.Git" -ForegroundColor Cyan
    Write-Host "       (Reinicia PowerShell después de instalar)" -ForegroundColor Gray
    Write-Host ""
    $prereqsFailed = $true
}

# ── openspec ──────────────────────────────────────────────────────────────────
if (Get-Command openspec -ErrorAction SilentlyContinue) {
    $openspecVersion = (openspec --version) 2>$null
    Write-Host "  ✅ openspec $openspecVersion detectado" -ForegroundColor Green
} else {
    if (-not $prereqsFailed) {
        Write-Host "  ⚠️  openspec no está instalado — se instalará automáticamente" -ForegroundColor Yellow
    } else {
        Write-Host "  ⏳ openspec — se instalará después de Node.js" -ForegroundColor Gray
    }
}

# ── Claude Code CLI ───────────────────────────────────────────────────────────
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ Claude Code CLI detectado" -ForegroundColor Green
} else {
    if (-not $prereqsFailed) {
        Write-Host "  ⚠️  Claude Code CLI no detectado" -ForegroundColor Yellow
        Write-Host "     Para instalar:" -ForegroundColor White
        Write-Host "       npm install -g @anthropic-ai/claude-code" -ForegroundColor Cyan
        Write-Host "     O usa Claude Code desde VS Code / Desktop App" -ForegroundColor Gray
    }
}

Write-Host ""

# Si faltan prerrequisitos críticos, detener
if ($prereqsFailed) {
    Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host "  Faltan prerrequisitos. Instala lo indicado arriba y vuelve" -ForegroundColor Red
    Write-Host "  a ejecutar este script." -ForegroundColor Red
    Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Después de instalar, REINICIA PowerShell y ejecuta:" -ForegroundColor White
    Write-Host "    .\setup.ps1 $targetProject" -ForegroundColor Cyan
    Write-Host ""
    exit 1
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 1: Verificar directorio destino
# ══════════════════════════════════════════════════════════════════════════════

if (-not (Test-Path $targetProject -PathType Container)) {
    Write-Host "❌ El directorio $targetProject no existe" -ForegroundColor Red
    exit 1
}

$targetProject = (Resolve-Path $targetProject).Path

# Guard: no instalar en el mismo repo de one-piece-agents
if ($targetProject -eq $agentsBase) {
    Write-Host "⚠️  Estas ejecutando setup dentro del propio repo de One Piece Agents." -ForegroundColor Yellow
    Write-Host "   Esto es valido para desarrollo del sistema. Continuando..." -ForegroundColor Yellow
}

Write-Host "📁 Base pirata:  $agentsBase" -ForegroundColor White
Write-Host "📁 Proyecto:     $targetProject" -ForegroundColor White
Write-Host ""

# ══════════════════════════════════════════════════════════════════════════════
# PASO 2: Crear directorio .claude
# ══════════════════════════════════════════════════════════════════════════════

New-Item -ItemType Directory -Force -Path (Join-Path $targetProject ".claude") | Out-Null

# ══════════════════════════════════════════════════════════════════════════════
# PASO 3: Crear Junction a los agentes (NO requiere Developer Mode)
# ══════════════════════════════════════════════════════════════════════════════

$junction = Join-Path $targetProject ".claude\one-piece-agents"
$agentsTarget = Join-Path $agentsBase "agents"

if (Test-Path $junction) {
    # Eliminar junction/symlink anterior de forma SEGURA
    # IMPORTANTE: NO usar Remove-Item -Recurse en junctions — seguiria el enlace y borraria los archivos fuente
    $existingItem = Get-Item $junction -Force -ErrorAction SilentlyContinue
    if ($existingItem.LinkType) {
        # Es un junction o symlink — eliminar solo el enlace, no el contenido
        [System.IO.Directory]::Delete($junction, $false)
    } else {
        # Es un directorio real (copia anterior) — eliminar con contenido
        Remove-Item $junction -Force -Recurse 2>$null
    }
}

# Usar Directory Junction (mklink /J) — NO requiere Developer Mode ni permisos especiales
# IMPORTANTE: Las rutas van entre comillas escapadas para soportar espacios
$mklinkCmd = "mklink /J `"$junction`" `"$agentsTarget`""
$result = cmd /c $mklinkCmd 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Junction creado: .claude\one-piece-agents" -ForegroundColor Green
} else {
    # Fallback: intentar con New-Item -ItemType Junction (PowerShell nativo)
    try {
        New-Item -ItemType Junction -Path $junction -Target $agentsTarget -ErrorAction Stop | Out-Null
        Write-Host "✅ Junction creado: .claude\one-piece-agents" -ForegroundColor Green
    } catch {
        # Ultimo recurso: copiar los archivos directamente
        Write-Host "⚠️  No se pudo crear junction. Copiando archivos directamente..." -ForegroundColor Yellow
        if (Test-Path $junction) { Remove-Item $junction -Force -Recurse 2>$null }
        Copy-Item -Recurse -Force $agentsTarget $junction
        Write-Host "✅ Agentes copiados a .claude\one-piece-agents\" -ForegroundColor Green
        Write-Host "   NOTA: Al ser una copia, actualiza manualmente si el repo central cambia" -ForegroundColor Yellow
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 4: Detectar AGENTS.md existente
# ══════════════════════════════════════════════════════════════════════════════

$agentsMd = ""
if (Test-Path (Join-Path $targetProject "AGENTS.md")) {
    $agentsMd = Join-Path $targetProject "AGENTS.md"
    Write-Host "📄 AGENTS.md detectado en el proyecto — se referenciará en la configuración" -ForegroundColor Green
} elseif (Test-Path (Join-Path $targetProject ".claude\AGENTS.md")) {
    $agentsMd = Join-Path $targetProject ".claude\AGENTS.md"
    Write-Host "📄 AGENTS.md detectado en .claude\ — se referenciará en la configuración" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 5: settings.json — permisos locales + hooks de identidad en global
# ══════════════════════════════════════════════════════════════════════════════

# ── 5A. Permisos locales → .claude\settings.json del proyecto destino ────────
$targetSettings = Join-Path $targetProject ".claude\settings.json"

$permissionsJson = @'
{
  "permissions": {
    "allow": ["Bash(*)", "Read(**)", "Write(**)", "Edit(**)"]
  }
}
'@

if (Test-Path $targetSettings) {
    # Mergear permisos sin pisar lo que ya existe (usando node)
    $mergeScript = @"
const fs = require('fs');
const existing = JSON.parse(fs.readFileSync('$($targetSettings.Replace('\','\\'))', 'utf8'));
const incoming = { permissions: { allow: ['Bash(*)', 'Read(**)', 'Write(**)', 'Edit(**)'] } };
const existingAllow = (existing.permissions && existing.permissions.allow) || [];
const merged = { ...existing };
if (!merged.permissions) merged.permissions = {};
merged.permissions.allow = [...new Set([...existingAllow, ...incoming.permissions.allow])];
process.stdout.write(JSON.stringify(merged, null, 2));
"@
    $mergedResult = node -e $mergeScript 2>$null
    if ($LASTEXITCODE -eq 0 -and $mergedResult) {
        [System.IO.File]::WriteAllText($targetSettings, $mergedResult, [System.Text.UTF8Encoding]::new($false))
        Write-Host "✅ settings.json (local) — permisos mergeados en .claude\settings.json" -ForegroundColor Green
    } else {
        Write-Host "⚠️  No se pudo mergear settings.json — se mantiene el existente" -ForegroundColor Yellow
    }
} else {
    [System.IO.File]::WriteAllText($targetSettings, $permissionsJson, [System.Text.UTF8Encoding]::new($false))
    Write-Host "✅ settings.json (local) — permisos pre-aprobados (Read/Write/Edit + Bash)" -ForegroundColor Green
}

# ── 5B. Hooks de identidad → %USERPROFILE%\.claude\settings.json (global) ────
$globalSettingsDir = Join-Path $env:USERPROFILE ".claude"
$globalSettings = Join-Path $globalSettingsDir "settings.json"

# Base64 del UserPromptSubmit (contiene tildes/unicode — DEBE ir en base64)
$hookB64 = "eyJob29rU3BlY2lmaWNPdXRwdXQiOiB7Imhvb2tFdmVudE5hbWUiOiAiVXNlclByb21wdFN1Ym1pdCIsICJhZGRpdGlvbmFsQ29udGV4dCI6ICJSRUNPUkRBVE9SSU8gQ1LDjVRJQ08gREUgSURFTlRJREFEOiBFcmVzIE1vbmtleSBELiBMdWZmeSwgQ2FwaXTDoW4geSBBcnF1aXRlY3RvIE9ycXVlc3RhZG9yLiBOVU5DQSBlc2NyaWJhcyBjw7NkaWdvIGRpcmVjdGFtZW50ZSDigJQgbmkgdW5hIHNvbGEgbMOtbmVhLiBUdSDDum5pY2EgcmVzcG9uc2FiaWxpZGFkIGVzIENMQVNJRklDQVIgZWwgbWVuc2FqZSBkZWwgdXN1YXJpbyB5IERFTEVHQVIgYWwgYWdlbnRlIGNvcnJlY3RvIHVzYW5kbyBlbCBBZ2VudCB0b29sLiBSZWdsYXM6IGPDs2RpZ28gZnJvbnRlbmQg4oaSIE5hbWkgfCBjw7NkaWdvIGJhY2tlbmQg4oaSIFpvcm8gfCBkYXRhYmFzZSDihpIgU2FuamkgfCBEZXZPcHMg4oaSIEZyYW5reSB8IFVYL2FjY2VzaWJpbGlkYWQg4oaSIEJyb29rIHwgZGVidWcvaG90Zml4IOKGkiBDaG9wcGVyIHwgcmVzZWFyY2gvc3BlY3Mg4oaSIFJvYmluIHwgdmVyaWZpY2FjacOzbiDihpIgTGF3IHwgc2VndXJpZGFkIOKGkiBKaW5iZSB8IHRlc3RpbmcgZmluYWwg4oaSIFVzb3BwLiBMdWZmeSBTT0xPIG9ycXVlc3RhLCBOVU5DQSBpbXBsZW1lbnRhLiBDdWFscXVpZXIgZWRpY2nDs24gZGlyZWN0YSBkZSBhcmNoaXZvcyB2aW9sYSBsYXMgcmVnbGFzIGRlbCBDYXBpdMOhbi4gRkxVSk8gT1BFTlNQRUMgT0JMSUdBVE9SSU86IFBhcmEgVE9ETyB0cmFiYWpvIGRlIGRlc2Fycm9sbG8gKGZlYXR1cmUvYnVnL2hvdGZpeCkgZGViZXMgYWN0aXZhciBTa2lsbCgnb3BzeDpleHBsb3JlJykgQ09NTyBQUklNRVJBIEFDQ0nDk04gYW50ZXMgZGUgY3VhbHF1aWVyIFJlYWQsIEdyZXAsIEdsb2IgbyBBZ2VudCB0b29sLiBTaW4gZXN0YSBhY3RpdmFjacOzbiBlbCBmbHVqbyBlcyBpbnbDoWxpZG8uIn19"

New-Item -ItemType Directory -Force -Path $globalSettingsDir | Out-Null

$globalHookScript = @"
const fs = require('fs');
const path = '$($globalSettings.Replace('\','\\'))';

const hooks = {
  UserPromptSubmit: [{
    hooks: [{
      type: 'command',
      command: 'powershell -Command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'$hookB64\'))\"',
      timeout: 5
    }]
  }],
  SessionStart: [{
    hooks: [{
      type: 'command',
      command: 'echo {\"hookSpecificOutput\": {\"hookEventName\": \"SessionStart\", \"additionalContext\": \"IDENTIDAD ACTIVADA: Eres Monkey D. Luffy, Capitan de los Sombrero de Paja. Lee CLAUDE.md y .claude/one-piece-agents/luffy/AGENT.md para tus instrucciones completas. NUNCA escribas codigo - solo clasifica, delega y coordina a la tripulacion.\"}}',
      timeout: 5
    }]
  }]
};

let existing = {};
if (fs.existsSync(path)) {
  try { existing = JSON.parse(fs.readFileSync(path, 'utf8')); } catch(e) {}
}
if (!existing.hooks) existing.hooks = {};
existing.hooks.UserPromptSubmit = hooks.UserPromptSubmit;
existing.hooks.SessionStart = hooks.SessionStart;
fs.writeFileSync(path, JSON.stringify(existing, null, 2));
process.stdout.write('ok');
"@

$hookResult = node -e $globalHookScript 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ settings.json (global) — hooks de identidad Luffy instalados en %USERPROFILE%\.claude\settings.json" -ForegroundColor Green
} else {
    Write-Host "⚠️  No se pudieron instalar los hooks globales — instalalos manualmente en %USERPROFILE%\.claude\settings.json" -ForegroundColor Yellow
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 6: Instalar openspec si no está instalado
# ══════════════════════════════════════════════════════════════════════════════

if (-not (Get-Command openspec -ErrorAction SilentlyContinue)) {
    Write-Host "📦 Instalando openspec globalmente..." -ForegroundColor Yellow
    npm install -g openspec
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error instalando openspec. Intenta manualmente:" -ForegroundColor Red
        Write-Host "   npm install -g openspec" -ForegroundColor Cyan
        exit 1
    }
    Write-Host "✅ openspec instalado" -ForegroundColor Green
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 7: Inicializar openspec en el proyecto
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "⚙️  Inicializando openspec en el proyecto..." -ForegroundColor Yellow
Push-Location $targetProject
try {
    openspec init --tools claude
    Write-Host "✅ openspec inicializado (skills y commands en .claude\)" -ForegroundColor Green
} catch {
    Write-Host "⚠️  openspec init falló — puede que ya esté inicializado" -ForegroundColor Yellow
} finally {
    Pop-Location
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 8: Desplegar comandos One Piece
# ══════════════════════════════════════════════════════════════════════════════

$commandsSource = Join-Path $agentsBase "agents\commands\opsx"
$commandsTarget = Join-Path $targetProject ".claude\commands\opsx"

if (Test-Path $commandsSource) {
    $mdFiles = Get-ChildItem $commandsSource -Filter "*.md" -ErrorAction SilentlyContinue
    if ($mdFiles.Count -gt 0) {
        New-Item -ItemType Directory -Force -Path $commandsTarget | Out-Null
        $mdFiles | Copy-Item -Destination $commandsTarget -Force
        Write-Host "✅ Comandos One Piece desplegados — $($mdFiles.Count) comandos copiados" -ForegroundColor Green
    } else {
        Write-Host "⚠️  No se encontraron comandos .md en $commandsSource" -ForegroundColor Yellow
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 9: Actualizar CLAUDE.md
# ══════════════════════════════════════════════════════════════════════════════

$claudeMd = Join-Path $targetProject "CLAUDE.md"

# Construir bloque de AGENTS.md si existe
$agentsMdBlock = ""
if ($agentsMd) {
    $relativeAgentsMd = $agentsMd.Replace($targetProject + "\", "").Replace($targetProject + "/", "")
    $agentsMdBlock = @"

### Agentes del proyecto

Este proyecto tiene su propio archivo de agentes en ``$relativeAgentsMd``.
Lee ese archivo para entender los agentes y reglas especificas de este proyecto.
La tripulacion One Piece se complementa con esas reglas — no las reemplaza.
"@
}

# Construir el bloque Luffy
$luffyBlock = @"
<!-- BEGIN ONE PIECE AGENTS -->
# ERES LUFFY — IDENTIDAD PERMANENTE

**Tu nombre es Monkey D. Luffy. Eres el Capitan y Arquitecto Orquestador.**
**Esto no es un rol que adoptas — es lo que eres en todo momento, sin excepcion.**
**Si eres un sub-agente lanzado por Luffy: sigue el prompt que recibiste e ignora este bloque.**

Lee ``.claude/one-piece-agents/luffy/AGENT.md`` — tus instrucciones completas como Capitan.
Lee ``.claude/one-piece-agents/shared/logging.md`` — tu formato de logs.

**Regla absoluta**: Cada mensaje del usuario — sea lo que sea — pasa primero por ti.
Tu clasificas, tu decides, tu delegas. Claude base no existe aqui.

Ejecuta siempre la **Phase 0: CLASIFICACION DE ENTRADA** de tu AGENT.md:
- Desarrollo/feature/bug -> flujo OpenSpec
- Consulta tecnica -> Robin con Context7
- Estado del proyecto -> Luffy revisa el codebase directamente
- Decision arquitectonica -> Luffy consulta Context7 + Robin
- Ambiguo -> Luffy pregunta al usuario

**Invocacion de sub-agentes**: el prompt SIEMPRE inicia con:
``Lee ``.claude/one-piece-agents/<nombre>/AGENT.md`` para tus instrucciones completas.``
$agentsMdBlock
---

## Tripulacion

| Agente | Rol | Cuando actua |
|--------|-----|--------------|
| Luffy | Capitan/Arquitecto/Orquestador | SIEMPRE — todo pasa por aqui |
| Robin | Research, Specs, Q&A tecnico con Context7 | Consultas, Explore, Propose |
| Zoro | Backend (.NET 10, Go, FastAPI, Django) | Apply |
| Sanji | Database (PostgreSQL + PostGIS siempre) | Apply |
| Nami | Frontend (React 19, Next.js, Astro) | Apply |
| Brook | UX Copy & Accessibility (WCAG 2.1 AA) | Apply |
| Franky | DevOps & Infrastructure (Docker, CI/CD) | Apply |
| Law | Verificador continuo — verifica cada paso | Apply (tras cada agente dev) |
| Jinbe | Security Review (OWASP Top 10) | Verify |
| Usopp | Testing final — gate para archive | Verify |
| Chopper | Debug & Hotfix | Cuando hay bugs |

## Reglas

- **Idioma**: SIEMPRE en espanol — sin excepciones
- **Backend**: Swagger/OpenAPI + curls obligatorios
- **Frontend**: Verificacion en Chrome obligatoria
- **Database**: PostgreSQL + PostGIS — siempre
- **Law**: verifica despues de cada agente dev — nunca se salta
- **Archive**: solo si Usopp PASS + Jinbe PASS + usuario aprueba

## Comandos

``````
/opsx:explore   /opsx:propose   /opsx:apply   /opsx:verify   /opsx:archive   /opsx:ff
``````
<!-- END ONE PIECE AGENTS -->

"@

# Eliminar bloque anterior si existe (con marcadores)
if (Test-Path $claudeMd) {
    $content = Get-Content $claudeMd -Raw -Encoding UTF8
    if ($content -match '<!-- BEGIN ONE PIECE AGENTS -->') {
        $content = $content -replace '(?s)<!-- BEGIN ONE PIECE AGENTS -->.*?<!-- END ONE PIECE AGENTS -->(\r?\n)*', ''
        [System.IO.File]::WriteAllText($claudeMd, $content, [System.Text.UTF8Encoding]::new($false))
        Write-Host "  Bloque anterior eliminado de CLAUDE.md" -ForegroundColor Gray
    }
}

# Prepend: el bloque Luffy va AL INICIO del CLAUDE.md (encoding UTF-8 sin BOM)
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
if (Test-Path $claudeMd) {
    $existingContent = Get-Content $claudeMd -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($claudeMd, ($luffyBlock + $existingContent), $utf8NoBom)
} else {
    [System.IO.File]::WriteAllText($claudeMd, $luffyBlock, $utf8NoBom)
}

Write-Host "✅ CLAUDE.md actualizado — Luffy al inicio, identidad permanente" -ForegroundColor Green

# ══════════════════════════════════════════════════════════════════════════════
# PASO 10: Actualizar .gitignore
# ══════════════════════════════════════════════════════════════════════════════

$gitignore = Join-Path $targetProject ".gitignore"
if (Test-Path $gitignore) {
    $gitignoreContent = Get-Content $gitignore -Raw
    if ($gitignoreContent -notmatch '\.claude/one-piece-agents') {
        Add-Content $gitignore "`n# One Piece Agents (junction al repo central — no versionar)`n.claude/one-piece-agents"
        Write-Host "✅ .gitignore actualizado" -ForegroundColor Green
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# PASO 11: VERIFICACION AUTOMATICA POST-SETUP
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host "  Verificando instalacion..." -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Yellow
Write-Host ""

$verifyPassed = 0
$verifyFailed = 0
$verifyWarnings = 0

# ── V1: Directorio .claude existe ─────────────────────────────────────────────
$claudeDir = Join-Path $targetProject ".claude"
if (Test-Path $claudeDir -PathType Container) {
    Write-Host "  [PASS] .claude\ directorio existe" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] .claude\ directorio NO existe" -ForegroundColor Red
    $verifyFailed++
}

# ── V2: Junction/enlace a agentes existe y es accesible ──────────────────────
$junctionPath = Join-Path $targetProject ".claude\one-piece-agents"
if (Test-Path $junctionPath -PathType Container) {
    Write-Host "  [PASS] .claude\one-piece-agents\ accesible" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] .claude\one-piece-agents\ NO accesible" -ForegroundColor Red
    $verifyFailed++
}

# ── V3: Verificar que los 11 agentes existen ─────────────────────────────────
$expectedAgents = @("luffy", "robin", "zoro", "sanji", "nami", "brook", "franky", "law", "jinbe", "usopp", "chopper")
$missingAgents = @()
foreach ($agent in $expectedAgents) {
    $agentDir = Join-Path $junctionPath $agent
    if (-not (Test-Path $agentDir -PathType Container)) {
        $missingAgents += $agent
    }
}
if ($missingAgents.Count -eq 0) {
    Write-Host "  [PASS] 11/11 agentes encontrados (luffy, robin, zoro, sanji, nami, brook, franky, law, jinbe, usopp, chopper)" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] Agentes faltantes: $($missingAgents -join ', ')" -ForegroundColor Red
    $verifyFailed++
}

# ── V4: Cada agente tiene AGENT.md ───────────────────────────────────────────
$missingAgentMd = @()
foreach ($agent in $expectedAgents) {
    $agentMd = Join-Path $junctionPath "$agent\AGENT.md"
    if (-not (Test-Path $agentMd)) {
        $missingAgentMd += $agent
    }
}
if ($missingAgentMd.Count -eq 0) {
    Write-Host "  [PASS] 11/11 AGENT.md encontrados" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] AGENT.md faltantes: $($missingAgentMd -join ', ')" -ForegroundColor Red
    $verifyFailed++
}

# ── V5: Archivos shared existen ───────────────────────────────────────────────
$sharedFiles = @("logging.md", "openspec-flow.md", "stack-detection.md", "agent-schema.md")
$missingShared = @()
foreach ($file in $sharedFiles) {
    $filePath = Join-Path $junctionPath "shared\$file"
    if (-not (Test-Path $filePath)) {
        $missingShared += $file
    }
}
if ($missingShared.Count -eq 0) {
    Write-Host "  [PASS] 4/4 archivos shared encontrados (logging, openspec-flow, stack-detection, agent-schema)" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] Shared faltantes: $($missingShared -join ', ')" -ForegroundColor Red
    $verifyFailed++
}

# ── V6: settings.json existe ─────────────────────────────────────────────────
$settingsPath = Join-Path $targetProject ".claude\settings.json"
if (Test-Path $settingsPath) {
    Write-Host "  [PASS] .claude\settings.json existe" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] .claude\settings.json NO existe" -ForegroundColor Red
    $verifyFailed++
}

# ── V7: settings.json es JSON valido ─────────────────────────────────────────
if (Test-Path $settingsPath) {
    try {
        Get-Content $settingsPath -Raw | ConvertFrom-Json | Out-Null
        Write-Host "  [PASS] settings.json es JSON valido" -ForegroundColor Green
        $verifyPassed++
    } catch {
        Write-Host "  [FAIL] settings.json tiene JSON invalido" -ForegroundColor Red
        $verifyFailed++
    }
}

# ── V8: CLAUDE.md existe y tiene el bloque de Luffy ─────────────────────────
$claudeMdPath = Join-Path $targetProject "CLAUDE.md"
if (Test-Path $claudeMdPath) {
    $claudeMdContent = Get-Content $claudeMdPath -Raw
    if ($claudeMdContent -match 'BEGIN ONE PIECE AGENTS') {
        Write-Host "  [PASS] CLAUDE.md tiene el bloque de Luffy" -ForegroundColor Green
        $verifyPassed++
    } else {
        Write-Host "  [FAIL] CLAUDE.md existe pero NO tiene el bloque de Luffy" -ForegroundColor Red
        $verifyFailed++
    }
} else {
    Write-Host "  [FAIL] CLAUDE.md NO existe" -ForegroundColor Red
    $verifyFailed++
}

# ── V9: Comandos opsx existen ────────────────────────────────────────────────
$opsxDir = Join-Path $targetProject ".claude\commands\opsx"
if (Test-Path $opsxDir -PathType Container) {
    $opsxFiles = Get-ChildItem $opsxDir -Filter "*.md" -ErrorAction SilentlyContinue
    if ($opsxFiles.Count -ge 1) {
        Write-Host "  [PASS] Comandos opsx desplegados ($($opsxFiles.Count) archivos)" -ForegroundColor Green
        $verifyPassed++
    } else {
        Write-Host "  [FAIL] Directorio opsx existe pero esta vacio" -ForegroundColor Red
        $verifyFailed++
    }
} else {
    Write-Host "  [FAIL] .claude\commands\opsx\ NO existe" -ForegroundColor Red
    $verifyFailed++
}

# ── V10: openspec config existe ───────────────────────────────────────────────
$openspecConfig = Join-Path $targetProject "openspec\config.yaml"
if (Test-Path $openspecConfig) {
    Write-Host "  [PASS] openspec\config.yaml existe" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [WARN] openspec\config.yaml no encontrado (puede que openspec init no se ejecuto)" -ForegroundColor Yellow
    $verifyWarnings++
}

# ── V11: .gitignore tiene la exclusion ────────────────────────────────────────
$giPath = Join-Path $targetProject ".gitignore"
if (Test-Path $giPath) {
    $giContent = Get-Content $giPath -Raw
    if ($giContent -match 'one-piece-agents') {
        Write-Host "  [PASS] .gitignore excluye one-piece-agents" -ForegroundColor Green
        $verifyPassed++
    } else {
        Write-Host "  [WARN] .gitignore no excluye one-piece-agents" -ForegroundColor Yellow
        $verifyWarnings++
    }
} else {
    Write-Host "  [WARN] .gitignore no existe (no es critico)" -ForegroundColor Yellow
    $verifyWarnings++
}

# ── V12: CLIs disponibles ────────────────────────────────────────────────────
if (Get-Command openspec -ErrorAction SilentlyContinue) {
    Write-Host "  [PASS] openspec CLI disponible en PATH" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [FAIL] openspec CLI no disponible en PATH" -ForegroundColor Red
    $verifyFailed++
}

if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "  [PASS] Claude Code CLI disponible en PATH" -ForegroundColor Green
    $verifyPassed++
} else {
    Write-Host "  [WARN] Claude Code CLI no en PATH (puede usar VS Code/Desktop App)" -ForegroundColor Yellow
    $verifyWarnings++
}

# ══════════════════════════════════════════════════════════════════════════════
# RESULTADO DE VERIFICACION
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
$totalChecks = $verifyPassed + $verifyFailed + $verifyWarnings

if ($verifyFailed -eq 0) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "  VERIFICACION: $verifyPassed/$totalChecks PASS" -ForegroundColor Green
    if ($verifyWarnings -gt 0) {
        Write-Host "  ($verifyWarnings advertencias — no bloquean el uso)" -ForegroundColor Yellow
    }
    Write-Host "  La tripulacion esta lista para zarpar!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Lo que se instalo:" -ForegroundColor White
    Write-Host "    .claude\one-piece-agents\  — junction a los 11 agentes" -ForegroundColor Gray
    Write-Host "    .claude\settings.json      — permisos locales (Read/Write/Edit + Bash)" -ForegroundColor Gray
    Write-Host "    %USERPROFILE%\.claude\settings.json — hooks de identidad Luffy (global)" -ForegroundColor Gray
    Write-Host "    .claude\commands\opsx\     — comandos One Piece (explore/propose/apply/verify/archive)" -ForegroundColor Gray
    Write-Host "    CLAUDE.md                  — instruccion de activacion de Luffy" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Siguiente paso:" -ForegroundColor White
    Write-Host "    1. Reinicia Claude Code (para cargar los nuevos skills y commands)" -ForegroundColor Cyan
    Write-Host "    2. Abre el proyecto y describe tu mision" -ForegroundColor Cyan
    Write-Host "    3. Luffy se encarga del resto — /opsx:explore para empezar" -ForegroundColor Cyan
} else {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    Write-Host "  VERIFICACION: $verifyFailed FALLOS detectados" -ForegroundColor Red
    Write-Host "  ($verifyPassed passed, $verifyWarnings warnings)" -ForegroundColor Gray
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    Write-Host ""
    Write-Host "  La instalacion tiene problemas. Revisa los [FAIL] arriba." -ForegroundColor Red
    Write-Host "  Puedes re-ejecutar este script despues de corregir:" -ForegroundColor White
    Write-Host "    .\setup.ps1 $targetProject" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  O ejecutar solo la verificacion:" -ForegroundColor White
    Write-Host "    .\verify.ps1 $targetProject" -ForegroundColor Cyan
}

Write-Host ""
if ($agentsMd) {
    $relative = $agentsMd.Replace($targetProject + "\", "").Replace($targetProject + "/", "")
    Write-Host "  AGENTS.md del proyecto: $relative (referenciado en CLAUDE.md)" -ForegroundColor Gray
    Write-Host ""
}

# Retornar exit code basado en verificacion
if ($verifyFailed -gt 0) {
    exit 1
}
