@echo off
cd /d "%~dp0"
docker compose down
echo PUPR Traffic Monitoring stopped. Database volume is preserved.
pause
