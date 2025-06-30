@echo off
echo Setting up splash screen with kidney image...
echo.

echo Step 1: Installing dependencies...
flutter pub get

echo.
echo Step 2: Generating splash screen...
flutter pub run flutter_native_splash:create

echo.
echo Step 3: Generating app icons...
flutter pub run flutter_launcher_icons:main

echo.
echo Splash screen setup complete!
echo The kidney image will now appear as a splash screen when the app starts.
echo.
pause 