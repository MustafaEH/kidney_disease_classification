@echo off
echo ========================================
echo Starting Kidney Analysis API Server
echo ========================================
echo.

echo Starting API server...
echo Server will be available at: http://192.168.1.4:8000
echo.
echo Keep this window open while using the app.
echo Press Ctrl+C to stop the server.
echo.

cd /d D:\mustafa\kidney\api
python main.py

echo.
echo Server stopped.
pause 