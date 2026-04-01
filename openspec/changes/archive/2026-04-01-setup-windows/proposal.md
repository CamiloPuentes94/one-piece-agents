## Why

El sistema One Piece Agents solo soporta Unix/macOS mediante `setup.sh`. Desarrolladores en Windows no pueden usar el sistema sin instalar Git Bash, lo cual no es evidente ni está documentado. Se necesita soporte nativo para CMD y PowerShell, con documentación clara de los requisitos previos.

## What Changes

- **NUEVO** `setup.ps1` — Implementación completa del script de setup en PowerShell, equivalente funcional de `setup.sh`
- **NUEVO** `setup.bat` — Wrapper CMD que invoca `setup.ps1` via PowerShell; permite a usuarios de CMD ejecutar el setup sin cambiar de shell
- **MODIFICADO** `.claude/settings.json` — Agregar permisos para comandos Windows/PowerShell (`New-Item`, `Remove-Item`, `Copy-Item`, `mklink`, `where`, `icacls`, `powershell`)
- **MODIFICADO** `README.md` — Sección de requisitos Windows: Developer Mode o permisos de administrador para symlinks, instalación manual de openspec (`npm install -g openspec`)

## Capabilities

### New Capabilities

- `windows-setup`: Scripts de instalación nativos para Windows — `setup.ps1` (PowerShell completo) y `setup.bat` (wrapper CMD). Misma funcionalidad que `setup.sh`: crea symlink a agents/, copia settings.json, inicializa openspec, despliega comandos opsx, actualiza CLAUDE.md con bloque Luffy, actualiza .gitignore.

### Modified Capabilities

<!-- Sin cambios de requisitos en specs existentes — solo archivos nuevos e infraestructura -->

## Impact

- Archivos nuevos: `setup.ps1`, `setup.bat`
- Archivos modificados: `.claude/settings.json`, `README.md`
- Sin cambios en `agents/`, `CLAUDE.md`, ni en el flujo OpenSpec
- Dependencia nueva: Developer Mode de Windows activado O ejecución como Administrador (para `mklink /D`)
- Dependencia existente documentada: `npm install -g openspec` debe hacerse manualmente en Windows antes de correr el setup
