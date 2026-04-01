## 1. Script PowerShell — setup.ps1

- [ ] 1.1 Crear `setup.ps1` con encabezado, `$ErrorActionPreference = "Stop"`, detección de `$PSScriptRoot` y `$TargetProject`
- [ ] 1.2 Implementar verificación de openspec (`Get-Command openspec`) con mensaje de error claro y exit code
- [ ] 1.3 Implementar creación de `.claude\` con `New-Item -ItemType Directory -Force`
- [ ] 1.4 Implementar symlink con `New-Item -ItemType SymbolicLink` + manejo de error con instrucciones de Developer Mode
- [ ] 1.5 Implementar detección de `AGENTS.md` (en raíz y en `.claude\`)
- [ ] 1.6 Implementar copia condicional de `settings.json` (skip si ya existe)
- [ ] 1.7 Implementar inicialización de openspec (`openspec init --tools claude`)
- [ ] 1.8 Implementar despliegue de comandos opsx (crear directorio + copiar `.md`)
- [ ] 1.9 Implementar actualización de `CLAUDE.md`: eliminar bloque anterior con regex `(?s)<!-- BEGIN ONE PIECE AGENTS -->.*?<!-- END ONE PIECE AGENTS -->\r?\n?`, construir here-string con bloque Luffy, prepend al archivo
- [ ] 1.10 Implementar actualización de `.gitignore` (agregar `.claude/one-piece-agents` si no existe)
- [ ] 1.11 Implementar resumen final de salida con los mismos mensajes que `setup.sh`

## 2. Script CMD — setup.bat

- [ ] 2.1 Crear `setup.bat` con `@echo off`, detección de `%~dp0` y propagación de argumentos
- [ ] 2.2 Implementar llamada a `powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*`
- [ ] 2.3 Implementar propagación de código de error (`exit /b %ERRORLEVEL%`)

## 3. Permisos — settings.json

- [ ] 3.1 Simplificar `.claude/settings.json` a permisos totales: reemplazar toda la lista de comandos Bash por `"Bash(*)"` + mantener `"Read(**)"`, `"Write(**)"`, `"Edit(**)"` — los agentes necesitan autonomía completa sin prompts

## 4. Documentación — README.md

- [ ] 4.1 Agregar sección "Instalación en Windows" con subsecciones: Requisitos previos, Pasos de instalación, Advertencia sobre symlinks (Developer Mode / Admin)
- [ ] 4.2 Documentar instalación manual de openspec: `npm install -g openspec` como paso obligatorio previo en Windows
- [ ] 4.3 Documentar cómo ejecutar desde CMD (`setup.bat`) y desde PowerShell (`.\setup.ps1`)
- [ ] 4.4 Documentar activación de Developer Mode: `Configuración → Sistema → Para desarrolladores → Modo desarrollador`

## 5. Landing page — HowToUseSection.astro

- [ ] 5.1 Agregar selector de OS (macOS/Linux | Windows) en el bloque "Instalar en tu proyecto" del componente `HowToUseSection.astro` en `one-piece-agents-landing/`
- [ ] 5.2 Panel macOS/Linux: mostrar comandos actuales (`./setup.sh`)
- [ ] 5.3 Panel Windows CMD: mostrar pasos previos (`npm install -g openspec`) + comando `setup.bat`
- [ ] 5.4 Panel Windows PowerShell: mostrar pasos previos + comando `.\setup.ps1`
- [ ] 5.5 Agregar nota de advertencia visible sobre Developer Mode / Admin para symlinks en los paneles Windows
