# Splash Screen Setup

## Quick Setup

1. **Run the setup script:**
   ```bash
   setup_splash.bat
   ```

2. **Or run manually:**
   ```bash
   flutter pub get
   flutter pub run flutter_native_splash:create
   flutter pub run flutter_launcher_icons:main
   ```

## What this does:

- ✅ Adds a splash screen with the kidney image
- ✅ Shows the kidney image when the app starts
- ✅ Works on both light and dark themes
- ✅ Supports Android 12+ splash screen
- ✅ Centers the image properly
- ✅ Uses the kidney image as app icon too

## Features:

- **White background** for light theme
- **Black background** for dark theme
- **Kidney image** centered on screen
- **Fullscreen** splash screen
- **200px image size** for good visibility
- **Android 12+ support** with proper splash screen

## After setup:

1. **Clean and rebuild:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test the splash screen** by restarting the app

The kidney image will now appear as a beautiful splash screen when your app starts! 🫁 