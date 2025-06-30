# Production Setup Guide

## 🚀 Building a Standalone APK

### Quick Build
```bash
build_release.bat
```

### Manual Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## 📱 Installing the APK

### Step 1: Enable Unknown Sources
1. Go to **Settings** → **Security** (or **Privacy**)
2. Enable **"Install from unknown sources"** or **"Install unknown apps"**
3. Allow installation from your file manager

### Step 2: Install the APK
1. Copy `build/app/outputs/flutter-apk/app-release.apk` to your device
2. Open the APK file
3. Tap **"Install"**
4. Wait for installation to complete

## 🔧 Running the API Server

### Option 1: Manual Start
```bash
cd api
python main.py
```

### Option 2: Create a Startup Script
Create `start_api_server.bat`:
```batch
@echo off
cd /d D:\mustafa\kidney\api
python main.py
pause
```

### Option 3: Windows Service (Advanced)
You can set up the API as a Windows service for automatic startup.

## 🌐 Network Requirements

### For Home Use:
- ✅ Both device and computer on same WiFi network
- ✅ Computer IP: `192.168.1.4` (your current IP)
- ✅ API server running on port `8000`

### For Different Networks:
Update the IP in `lib/core/api_service.dart`:
```dart
'http://YOUR_NEW_IP:8000'
```

## 📋 Usage Checklist

### Before Using:
- [ ] API server is running (`python main.py`)
- [ ] Computer and phone on same network
- [ ] APK installed on device
- [ ] Camera permissions granted

### Daily Use:
1. **Start API server** on your computer
2. **Open the app** on your phone
3. **Check WiFi icon** (should be green)
4. **Take/select kidney image**
5. **Analyze** and view results

## 🔒 Security Considerations

### For Personal Use:
- ✅ Current setup is fine
- ✅ Local network only

### For Production/Public Use:
- [ ] Use HTTPS
- [ ] Add authentication
- [ ] Deploy API to cloud server
- [ ] Add rate limiting
- [ ] Implement proper error handling

## 🛠️ Troubleshooting

### App won't connect:
1. Check if API server is running
2. Verify IP address is correct
3. Check Windows Firewall settings
4. Ensure both devices on same network

### App crashes:
1. Check camera permissions
2. Verify storage permissions
3. Restart the app
4. Reinstall if needed

### API server issues:
1. Check Python dependencies
2. Verify port 8000 is available
3. Check firewall settings
4. Restart the server

## 📞 Support

If you encounter issues:
1. Check the console output
2. Verify network connectivity
3. Test API manually: `http://192.168.1.4:8000/health`
4. Restart both app and server

## 🎯 Success Indicators

✅ **App works without developer mode**
✅ **Can take photos and analyze**
✅ **Shows prediction results**
✅ **Works on different devices**
✅ **No connection errors**

**Your kidney analysis app is now production-ready!** 🫁✨ 