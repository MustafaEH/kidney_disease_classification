@echo off
echo Setting up firewall rule for Kidney API...
echo.
echo This script needs to be run as Administrator
echo.
echo Adding firewall rule to allow port 8000...
netsh advfirewall firewall add rule name="Kidney API" dir=in action=allow protocol=TCP localport=8000
echo.
echo Firewall rule added successfully!
echo.
echo Your API server should now be accessible from LDPlayer
echo.
pause 