@echo off
cd /d "%~dp0"
echo Starting PUPR Traffic Monitoring...
docker compose up --build -d
if errorlevel 1 (
  echo Failed to start. Check Docker Desktop and the error above.
  pause
  exit /b 1
)
echo.
echo Dashboard: http://localhost:3000
echo API health: http://localhost:8000/api/health
echo.
pause
