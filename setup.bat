@echo off
REM One Piece Agents — Setup Script (Windows CMD)
REM
REM USO:
REM   1. Click derecho en este archivo -> Ejecutar como administrador
REM   2. O abrir CMD como Administrador y ejecutar: setup.bat C:\ruta\a\mi-proyecto
REM
REM NO requiere Developer Mode. NO requiere configuraciones especiales.

REM Verificar que PowerShell esta disponible
where powershell >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: PowerShell no esta disponible en este sistema.
    echo PowerShell viene incluido en Windows 7+ y Windows Server 2008+.
    echo.
    echo Si estas en una version muy antigua de Windows, actualiza tu sistema.
    echo.
    pause
    exit /b 1
)

REM Ejecutar el script de PowerShell con permisos de bypass
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0setup.ps1" %*

if %ERRORLEVEL% neq 0 (
    echo.
    echo ══════════════════════════════════════════════════════════════
    echo   El setup encontro errores. Revisa los mensajes arriba.
    echo ══════════════════════════════════════════════════════════════
    echo.
    pause
    exit /b %ERRORLEVEL%
)

echo.
pause
exit /b 0
