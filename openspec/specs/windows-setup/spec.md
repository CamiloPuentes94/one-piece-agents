# windows-setup Specification

## Purpose
TBD - created by archiving change setup-windows. Update Purpose after archive.
## Requirements
### Requirement: Setup PowerShell nativo para Windows
El sistema SHALL proveer un script `setup.ps1` que ejecute el proceso de instalación completo en Windows usando PowerShell 5.1+, con paridad funcional a `setup.sh`.

#### Scenario: Ejecución exitosa con Developer Mode activo
- **WHEN** el usuario ejecuta `.\setup.ps1 C:\ruta\mi-proyecto` con Developer Mode activo o como Administrador
- **THEN** el script crea `.claude\one-piece-agents` como symlink a `agents\`, copia `settings.json`, inicializa openspec, despliega comandos opsx, actualiza `CLAUDE.md` con bloque Luffy al inicio, y actualiza `.gitignore`

#### Scenario: Fallo por symlink sin permisos
- **WHEN** el usuario ejecuta `.\setup.ps1` sin Developer Mode activo ni permisos de Administrador
- **THEN** el script muestra un mensaje de error claro indicando cómo activar Developer Mode (`Configuración → Sistema → Para desarrolladores → Modo desarrollador`) y termina con código de error distinto de cero

#### Scenario: openspec no instalado
- **WHEN** `Get-Command openspec` falla al inicio del script
- **THEN** el script muestra un mensaje claro pidiendo `npm install -g openspec` y termina con código de error

#### Scenario: CLAUDE.md ya tiene bloque Luffy
- **WHEN** el usuario re-ejecuta `setup.ps1` en un proyecto que ya tiene el bloque `<!-- BEGIN ONE PIECE AGENTS -->`
- **THEN** el script elimina el bloque anterior y agrega el nuevo al inicio de CLAUDE.md (actualización idempotente)

#### Scenario: settings.json ya existe
- **WHEN** el proyecto ya tiene `.claude\settings.json`
- **THEN** el script muestra `⚠️ .claude\settings.json ya existe — saltando` y no sobreescribe el archivo existente

### Requirement: Wrapper CMD para setup desde terminal clásico
El sistema SHALL proveer un script `setup.bat` que permita ejecutar el setup desde CMD invocando `setup.ps1` via `powershell.exe`.

#### Scenario: Ejecución desde CMD
- **WHEN** el usuario ejecuta `setup.bat C:\ruta\mi-proyecto` desde CMD
- **THEN** `setup.bat` invoca `powershell.exe -ExecutionPolicy Bypass -File "%~dp0setup.ps1"` con los mismos argumentos y produce el mismo resultado que ejecutar `setup.ps1` directamente

#### Scenario: Propagación de código de error
- **WHEN** `setup.ps1` falla con un error
- **THEN** `setup.bat` propaga el código de error (`%ERRORLEVEL%`) para que sea detectable por scripts padre o CI/CD

### Requirement: Permisos Windows en settings.json
El archivo `.claude\settings.json` desplegado por el setup SHALL incluir permisos para los comandos PowerShell y Windows que los agentes necesitan ejecutar.

#### Scenario: Agente ejecuta comandos PowerShell
- **WHEN** un agente (Franky, Zoro, etc.) necesita crear directorios, copiar archivos o verificar rutas en Windows
- **THEN** Claude Code pre-aprueba los comandos `New-Item`, `Remove-Item`, `Copy-Item`, `Get-Content`, `Set-Content`, `mklink`, `where`, `icacls`, `powershell` sin pedir confirmación al usuario

### Requirement: Documentación de requisitos Windows en README
El README.md SHALL incluir una sección de instalación Windows que documente los requisitos previos y pasos específicos para Windows.

#### Scenario: Usuario Windows lee el README
- **WHEN** un desarrollador Windows lee la sección de instalación del README
- **THEN** encuentra instrucciones claras para: (1) activar Developer Mode, (2) instalar openspec con `npm install -g openspec`, (3) ejecutar `setup.bat` o `.\setup.ps1`

#### Scenario: Requisito de Admin/Developer Mode documentado
- **WHEN** el README menciona el setup de Windows
- **THEN** incluye una advertencia explícita de que se requiere Developer Mode activo o ejecución como Administrador para crear symlinks

