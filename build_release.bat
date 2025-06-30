@echo off
echo ========================================
echo Building Release APK for Kidney App
echo ========================================
echo.

echo Step 1: Cleaning previous builds...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Building release APK...
flutter build apk --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo Your APK is located at:
echo build/app/outputs/flutter-apk/app-release.apk
echo.
echo You can now:
echo 1. Copy this APK to your Android device
echo 2. Install it (enable "Install from unknown sources")
echo 3. Use the app without developer mode!
echo.
echo Note: Make sure your API server is running at:
echo http://192.168.1.4:8000
echo.
pause 