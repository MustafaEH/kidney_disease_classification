# 🚀 Quick Start Guide - Kidney Disease Prediction App

## Prerequisites
- Python 3.8+ installed
- Flutter SDK installed
- Android Studio / VS Code with Flutter extension
- Android emulator or physical device connected

## 🎯 One-Click Setup (Windows)

**Simply double-click `start_app.bat`** and it will:
1. Install all dependencies
2. Create a test model
3. Start the API server
4. Launch the Flutter app

## 📋 Manual Setup (Alternative)

### Step 1: Install API Dependencies
```bash
cd api
pip install -r requirements.txt
```

### Step 2: Create Test Model
```bash
python create_test_model.py
```

### Step 3: Install Flutter Dependencies
```bash
cd ..
flutter pub get
```

### Step 4: Start API Server
```bash
cd api
python main.py
```

### Step 5: Start Flutter App (in new terminal)
```bash
cd ..
flutter run
```

## 📱 How to Use the App

1. **Launch the app** - You'll see the kidney scan interface
2. **Take or select an image** - Use camera or gallery
3. **Click "Analyze Kidney"** - The app will send the image to the API
4. **View results** - See disease prediction, confidence, and recommendations

## 🔧 API Endpoints

- **Health Check**: `http://localhost:8000/health`
- **Predict**: `http://localhost:8000/predict` (POST with image file)
- **Predict Base64**: `http://localhost:8000/predict-base64` (POST with base64 image)

## 🎯 Expected Results

The app will classify kidney images into:
- **Normal**: Healthy kidneys
- **Cyst**: Kidney cysts
- **Stone**: Kidney stones  
- **Tumor**: Kidney tumors

Each prediction includes:
- Disease classification
- Confidence score
- Severity level
- Personalized recommendations

## 🐛 Troubleshooting

### API Not Starting
- Check if Python and pip are installed
- Ensure all dependencies are installed: `pip install -r api/requirements.txt`

### Flutter App Issues
- Run `flutter doctor` to check setup
- Ensure device/emulator is connected
- Try `flutter clean && flutter pub get`

### Model Issues
- The test model will give random predictions
- Replace `api/kidney_model.h5` with your trained model for real predictions

## 📞 Support

If you encounter issues:
1. Check the console output for error messages
2. Ensure all prerequisites are installed
3. Try the manual setup steps above

## 🎉 Success!

Once everything is running:
- API will be available at `http://localhost:8000`
- Flutter app will show the kidney scan interface
- You can test with any kidney image 