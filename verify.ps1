# One Piece Agents — Verificacion de Instalacion (Windows PowerShell)
# Verifica que todo esta correctamente instalado en un proyecto
#
# USO:
#   .\verify.ps1 C:\ruta\a\mi-proyecto
#   .\verify.ps1                          (usa directorio actual)

$ErrorActionPreference = "Continue"

$targetProject = if ($args[0]) { $args[0] } else { (Get-Location).Path }

if (-not (Test-Path $targetProject -PathType Container)) {
    Write-Host "ERROR: El directorio $targetProject no existe" -ForegroundColor Red
    exit 1
}

$targetProject = (Resolve-Path $targetProject).Path

Write-Host ""
Write-Host "One Piece Agents — Verificacion" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Proyecto: $targetProject" -ForegroundColor White
Write-Host ""

$passed = 0
$failed = 0
$warnings = 0

function Test-Check {
    param([string]$Name, [bool]$Condition, [string]$FailMsg = "", [bool]$IsWarning = $false)
    if ($Condition) {
        Write-Host "  [PASS] $Name" -ForegroundColor Green
        $script:passed++
    } elseif ($IsWarning) {
        Write-Host "  [WARN] $Name" -ForegroundColor Yellow
        if ($FailMsg) { Write-Host "         $FailMsg" -ForegroundColor Gray }
        $script:warnings++
    } else {
        Write-Host "  [FAIL] $Name" -ForegroundColor Red
        if ($FailMsg) { Write-Host "         $FailMsg" -ForegroundColor Gray }
        $script:failed++
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# SECCION 1: ESTRUCTURA DE ARCHIVOS
# ══════════════════════════════════════════════════════════════════════════════

Write-Host "  --- Estructura de archivos ---" -ForegroundColor White

$claudeDir = Join-Path $targetProject ".claude"
Test-Check ".claude\ directorio existe" (Test-Path $claudeDir -PathType Container) "Ejecuta setup.ps1 primero"

$junctionPath = Join-Path $targetProject ".claude\one-piece-agents"
$junctionExists = Test-Path $junctionPath -PathType Container
Test-Check ".claude\one-piece-agents\ accesible" $junctionExists "El junction/enlace no se creo correctamente"

# Verificar si es junction o copia
if ($junctionExists) {
    $item = Get-Item $junctionPath -Force -ErrorAction SilentlyContinue
    if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
        # .Target puede ser string[] en PowerShell 5.1 — tomar el primero
        $linkTarget = if ($item.Target -is [array]) { $item.Target[0] } else { $item.Target }
        if ($linkTarget) {
            Test-Check "Enlace apunta a: $linkTarget" (Test-Path $linkTarget -PathType Container) "El directorio destino del enlace no existe"
        }
    } else {
        Write-Host "  [INFO] one-piece-agents es una copia directa (no junction)" -ForegroundColor Gray
    }
}

# ══════════════════════════════════════════════════════════════════════════════
# SECCION 2: AGENTES (11 agentes + shared)
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "  --- Agentes ---" -ForegroundColor White

$expectedAgents = @("luffy", "robin", "zoro", "sanji", "nami", "brook", "franky", "law", "jinbe", "usopp", "chopper")
$allAgentsOk = $true
$agentDetails = @()

foreach ($agent in $expectedAgents) {
    $agentDir = Join-Path $junctionPath $agent
    $agentMd = Join-Path $agentDir "AGENT.md"
    $toolsYaml = Join-Path $agentDir "tools.yaml"

    $dirOk = Test-Path $agentDir -PathType Container
    $mdOk = Test-Path $agentMd
    $toolsOk = Test-Path $toolsYaml

    if ($dirOk -and $mdOk) {
        # Verificar que AGENT.md no esta vacio
        $mdContent = Get-Content $agentMd -Raw -ErrorAction SilentlyContinue
        $mdNotEmpty = $mdContent -and $mdContent.Length -gt 100
        if ($mdNotEmpty) {
            $agentDetails += "PASS"
        } else {
            $agentDetails += "EMPTY"
            $allAgentsOk = $false
        }
    } else {
        $agentDetails += "MISSING"
        $allAgentsOk = $false
    }
}

if ($allAgentsOk) {
    Test-Check "11/11 agentes con AGENT.md valido" $true
} else {
    for ($i = 0; $i -lt $expectedAgents.Count; $i++) {
        $agent = $expectedAgents[$i]
        $status = $agentDetails[$i]
        if ($status -eq "PASS") {
            Write-Host "    [OK]   $agent" -ForegroundColor Green
        } elseif ($status -eq "EMPTY") {
            Write-Host "    [FAIL] $agent — AGENT.md vacio o corrupto" -ForegroundColor Red
        } else {
            Write-Host "    [FAIL] $agent — directorio o AGENT.md no encontrado" -ForegroundColor Red
        }
    }
    $failed++
}

# Shared files
$sharedFiles = @("logging.md", "openspec-flow.md", "stack-detection.md", "agent-schema.md")
$allSharedOk = $true
foreach ($file in $sharedFiles) {
    if (-not (Test-Path (Join-Path $junctionPath "shared\$file"))) {
        $allSharedOk = $false
    }
}
Test-Check "4/4 archivos shared (logging, openspec-flow, stack-detection, agent-schema)" $allSharedOk "Faltan archivos en agents\shared\"

# ══════════════════════════════════════════════════════════════════════════════
# SECCION 3: CONFIGURACION
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "  --- Configuracion ---" -ForegroundColor White

# settings.json
$settingsPath = Join-Path $targetProject ".claude\settings.json"
$settingsExists = Test-Path $settingsPath
Test-Check ".claude\settings.json existe" $settingsExists "Ejecuta setup.ps1 para generarlo"

if ($settingsExists) {
    try {
        $settingsObj = Get-Content $settingsPath -Raw | ConvertFrom-Json
        Test-Check "settings.json es JSON valido" $true
    } catch {
        Test-Check "settings.json es JSON valido" $false "El archivo tiene sintaxis JSON invalida"
    }
}

# CLAUDE.md
$claudeMdPath = Join-Path $targetProject "CLAUDE.md"
$claudeMdExists = Test-Path $claudeMdPath
Test-Check "CLAUDE.md existe" $claudeMdExists "Ejecuta setup.ps1 para generarlo"

if ($claudeMdExists) {
    $claudeMdContent = Get-Content $claudeMdPath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    $hasLuffy = $claudeMdContent -match 'BEGIN ONE PIECE AGENTS'
    Test-Check "CLAUDE.md contiene bloque de Luffy" $hasLuffy "El bloque <!-- BEGIN ONE PIECE AGENTS --> no esta presente"

    # Solo verificar posicion si el bloque existe
    if ($hasLuffy) {
        # Quitar posible BOM antes de comparar
        $trimmedContent = $claudeMdContent.TrimStart([char]0xFEFF, [char]0xFFFE)
        $luffyFirst = $trimmedContent -match '^<!-- BEGIN ONE PIECE AGENTS -->'
        if (-not $luffyFirst) {
            Test-Check "Bloque de Luffy esta al INICIO del archivo" $false "El bloque debe ser lo primero en CLAUDE.md para maxima prioridad" -IsWarning $true
        } else {
            Test-Check "Bloque de Luffy esta al INICIO del archivo" $true
        }
    }
}

# Comandos opsx
$opsxDir = Join-Path $targetProject ".claude\commands\opsx"
$opsxExists = Test-Path $opsxDir -PathType Container
if ($opsxExists) {
    $opsxCount = (Get-ChildItem $opsxDir -Filter "*.md" -ErrorAction SilentlyContinue).Count
    Test-Check "Comandos opsx desplegados ($opsxCount archivos .md)" ($opsxCount -ge 1) "Directorio opsx vacio"
} else {
    Test-Check "Directorio .claude\commands\opsx\ existe" $false "Ejecuta setup.ps1 para generarlo"
}

# openspec config
$openspecConfig = Join-Path $targetProject "openspec\config.yaml"
Test-Check "openspec\config.yaml existe" (Test-Path $openspecConfig) "openspec init puede no haberse ejecutado" -IsWarning $true

# .gitignore
$giPath = Join-Path $targetProject ".gitignore"
if (Test-Path $giPath) {
    $giContent = Get-Content $giPath -Raw -ErrorAction SilentlyContinue
    $giHasExclude = $giContent -match 'one-piece-agents'
    Test-Check ".gitignore excluye one-piece-agents" $giHasExclude "Agrega '.claude/one-piece-agents' a .gitignore" -IsWarning $true
} else {
    Test-Check ".gitignore existe" $false "No es critico pero recomendado" -IsWarning $true
}

# ══════════════════════════════════════════════════════════════════════════════
# SECCION 4: HERRAMIENTAS CLI
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "  --- Herramientas CLI ---" -ForegroundColor White

# Node.js
$nodeOk = [bool](Get-Command node -ErrorAction SilentlyContinue)
if ($nodeOk) {
    $nodeVer = (node --version) 2>$null
    Test-Check "Node.js $nodeVer" $true
} else {
    Test-Check "Node.js instalado" $false "Instala desde https://nodejs.org o: winget install OpenJS.NodeJS.LTS"
}

# npm
$npmOk = [bool](Get-Command npm -ErrorAction SilentlyContinue)
if ($npmOk) {
    $npmVer = (npm --version) 2>$null
    Test-Check "npm $npmVer" $true
} else {
    Test-Check "npm instalado" $false "Se instala con Node.js"
}

# Git
$gitOk = [bool](Get-Command git -ErrorAction SilentlyContinue)
if ($gitOk) {
    $gitVer = (git --version) 2>$null
    Test-Check "$gitVer" $true
} else {
    Test-Check "Git instalado" $false "Instala desde https://git-scm.com o: winget install Git.Git"
}

# openspec
$openspecOk = [bool](Get-Command openspec -ErrorAction SilentlyContinue)
if ($openspecOk) {
    $osVer = (openspec --version) 2>$null
    Test-Check "openspec $osVer" $true
} else {
    Test-Check "openspec CLI instalado" $false "Ejecuta: npm install -g openspec"
}

# Claude Code
$claudeOk = [bool](Get-Command claude -ErrorAction SilentlyContinue)
if ($claudeOk) {
    Test-Check "Claude Code CLI disponible" $true
} else {
    Test-Check "Claude Code CLI" $false "npm install -g @anthropic-ai/claude-code (o usa VS Code/Desktop App)" -IsWarning $true
}

# ══════════════════════════════════════════════════════════════════════════════
# RESULTADO FINAL
# ══════════════════════════════════════════════════════════════════════════════

Write-Host ""
$total = $passed + $failed + $warnings

if ($failed -eq 0) {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "  RESULTADO: $passed/$total PASS — Todo correcto" -ForegroundColor Green
    if ($warnings -gt 0) {
        Write-Host "  ($warnings advertencias — no bloquean el uso)" -ForegroundColor Yellow
    }
    Write-Host "  La tripulacion esta lista para zarpar!" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
} else {
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    Write-Host "  RESULTADO: $failed FALLOS — Instalacion incompleta" -ForegroundColor Red
    Write-Host "  ($passed passed, $warnings warnings)" -ForegroundColor Gray
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Para corregir, ejecuta:" -ForegroundColor White
    Write-Host "    .\setup.ps1 $targetProject" -ForegroundColor Cyan
}

Write-Host ""
exit $failed
