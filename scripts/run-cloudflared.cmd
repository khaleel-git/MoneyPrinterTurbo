@echo off
setlocal

set "CLOUDFLARED_CONFIG=%USERPROFILE%\.cloudflared\config.yml"
set "WEBUI_PORT=8501"

echo ***** Waiting for WebUI on port %WEBUI_PORT%... *****
:wait_loop
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $t = New-Object Net.Sockets.TcpClient; $t.Connect('127.0.0.1', %WEBUI_PORT%); $t.Close(); exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto wait_loop
)
echo ***** WebUI is ready. Starting Cloudflare Tunnel... *****

if exist "%CLOUDFLARED_CONFIG%" (
    echo ***** Using config: %CLOUDFLARED_CONFIG% *****
    cloudflared tunnel --config "%CLOUDFLARED_CONFIG%" run moneyprinter
) else (
    echo ***** No config.yml found. Starting quick tunnel... *****
    cloudflared tunnel --url "http://127.0.0.1:%WEBUI_PORT%" --no-autoupdate
)
