@echo off
setlocal

set "CLOUDFLARED_CONFIG=%USERPROFILE%\.cloudflared\config.yml"
set "WEBUI_URL=http://127.0.0.1:8501"

echo ***** Waiting for WebUI to be ready at %WEBUI_URL% *****
:wait_loop
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r = Invoke-WebRequest -Uri '%WEBUI_URL%' -UseBasicParsing -TimeoutSec 2; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto wait_loop
)
echo ***** WebUI is ready. Starting Cloudflare Tunnel... *****

if exist "%CLOUDFLARED_CONFIG%" (
    echo ***** Using config: %CLOUDFLARED_CONFIG% *****
    cloudflared tunnel run --config "%CLOUDFLARED_CONFIG%"
) else (
    echo ***** No config.yml found. Starting quick tunnel to %WEBUI_URL% *****
    cloudflared tunnel --url "%WEBUI_URL%" --no-autoupdate
)
