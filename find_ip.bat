@echo off
echo Finding your computer's IP address for LDPlayer configuration...
echo.

echo IPv4 Addresses:
ipconfig | findstr /i "IPv4"

echo.
echo ========================================
echo For LDPlayer, try these IP addresses:
echo 1. 10.0.3.2 (LDPlayer default)
echo 2. 10.0.2.2 (Standard Android emulator)
echo 3. Your computer's actual IP (from above)
echo.
echo Make sure your API server is running on port 8000
echo ========================================

pause 