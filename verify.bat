@echo off
REM One Piece Agents — Verificacion de Instalacion (Windows CMD)
REM
REM USO:
REM   verify.bat C:\ruta\a\mi-proyecto
REM   verify.bat                          (usa directorio actual)

where powershell >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ERROR: PowerShell no esta disponible.
    pause
    exit /b 1
)

powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0verify.ps1" %*

if %ERRORLEVEL% neq 0 (
    echo.
    echo La verificacion encontro problemas. Revisa los mensajes arriba.
    echo.
)

pause
exit /b %ERRORLEVEL%
