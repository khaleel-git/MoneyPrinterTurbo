@echo off
setlocal

set "LOG_FILE=%~1"
set "CLOUDFLARED_CONFIG=%USERPROFILE%\.cloudflared\config.yml"

if not defined LOG_FILE set "LOG_FILE=%~dp0cloudflared-webui.log"

if exist "%CLOUDFLARED_CONFIG%" (
	cloudflared tunnel run --config "%CLOUDFLARED_CONFIG%" > "%LOG_FILE%" 2>&1
) else (
	cloudflared tunnel --url "http://127.0.0.1:8501" --no-autoupdate > "%LOG_FILE%" 2>&1
)
