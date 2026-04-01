## Context

`setup.sh` usa Bash, `ln -s`, `perl`, `mktemp` y sintaxis POSIX — todo incompatible con CMD y PowerShell nativos. Windows requiere `mklink /D` para symlinks (requiere Developer Mode o Admin), y PowerShell para manipulación de texto avanzada (reemplazar bloques en CLAUDE.md). Git Bash existe como fallback pero no está garantizado ni documentado.

## Goals / Non-Goals

**Goals:**
- `setup.ps1` con paridad funcional completa con `setup.sh`
- `setup.bat` como wrapper CMD que invoca `setup.ps1` vía `powershell.exe`
- Documentar en README: requisito de Developer Mode/Admin para symlinks, y `npm install -g openspec` previo
- Actualizar `settings.json` con permisos para comandos Windows/PowerShell

**Non-Goals:**
- Soporte a Windows < 10
- Soporte a PowerShell < 5.1
- Eliminar o reemplazar `setup.sh` (sigue siendo el script principal para Unix/macOS)
- Instalación automática de openspec en Windows (se documenta como paso manual)

## Decisions

### 1. setup.bat como wrapper, no implementación completa

**Decisión:** `setup.bat` llama a `setup.ps1` via `powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*`.

**Alternativa considerada:** Implementación CMD nativa completa.

**Razón:** La manipulación de CLAUDE.md (regex, reemplazo de bloque) es inviable en CMD puro sin recurrir a `powershell.exe` de todos modos. Un wrapper es más simple, mantenible y no duplica lógica. Windows 10+ incluye PowerShell 5.1 por defecto.

### 2. Symlink real (mklink /D) en lugar de junction o copia

**Decisión:** Usar `New-Item -ItemType SymbolicLink` en PowerShell (equivale a `mklink /D`).

**Alternativa considerada:** Junction (`/J`) no requiere admin pero no funciona igual que symlink en todos los contextos. Copia directa rompe la sincronización con el repo central.

**Razón:** El usuario confirmó preferencia por symlink real. El requisito de Developer Mode/Admin se documenta explícitamente.

**Fallback:** Si falla la creación del symlink, el script muestra un mensaje claro con instrucciones para activar Developer Mode: `Configuración → Sistema → Para desarrolladores → Modo desarrollador`.

### 3. Permisos settings.json por nombre de comando, no por shell

**Decisión:** Agregar entradas `Bash(New-Item:*)`, `Bash(Remove-Item:*)`, etc. al settings.json.

**Razón:** Claude Code en Windows usa el mismo mecanismo de permisos `Bash(...)` pero invoca PowerShell. Agregar los comandos PowerShell más comunes de los agentes cubre los casos de uso sin over-permissioning.

### 4. Manipulación de CLAUDE.md en PowerShell

**Decisión:** Usar `-replace` con regex multilinea en PowerShell:
```powershell
$content = $content -replace '(?s)<!-- BEGIN ONE PIECE AGENTS -->.*?<!-- END ONE PIECE AGENTS -->\r?\n?', ''
```

**Razón:** Equivalente directo del `perl -i -0pe` de setup.sh. PowerShell maneja regex multilinea nativamente con el flag `(?s)`.

## Risks / Trade-offs

- **[Risk] Symlinks bloqueados en entornos corporativos** → El wrapper bat muestra mensaje de error claro con instrucciones. El usuario puede activar Developer Mode sin necesitar al área de IT en Windows 10/11.
- **[Risk] Política de ejecución de PowerShell restrictiva** → `setup.bat` usa `-ExecutionPolicy Bypass` explícitamente, lo que permite ejecutar el script sin modificar la política global del sistema.
- **[Risk] openspec no instalado** → El script verifica con `Get-Command openspec` antes de continuar y falla con mensaje claro si no está instalado, pidiendo al usuario que ejecute `npm install -g openspec` primero.
- **[Trade-off] setup.bat depende de PowerShell** → Aceptable ya que PowerShell 5.1 viene preinstalado en Windows 10+ y PowerShell 7 es recomendado.

## Migration Plan

No hay migración — es adición pura. `setup.sh` no se modifica. Los usuarios Windows ejecutan `setup.bat` o `.\setup.ps1` según su preferencia de shell.

## Open Questions

- ¿La "página web" mencionada por el usuario es una GitHub Pages site separada o el README.md del repo? (pendiente de confirmación — por ahora se actualiza README.md)
