@echo off
echo ========================================
echo Kidney Disease Prediction App Setup
echo ========================================
echo.

echo Step 1: Installing API dependencies...
cd api
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo Error installing API dependencies
    pause
    exit /b 1
)

echo.
echo Step 2: Creating test model...
python create_test_model.py
if %errorlevel% neq 0 (
    echo Error creating test model
    pause
    exit /b 1
)

echo.
echo Step 3: Installing Flutter dependencies...
cd ..
flutter pub get
if %errorlevel% neq 0 (
    echo Error installing Flutter dependencies
    pause
    exit /b 1
)

echo.
echo Step 4: Starting API server...
cd api
start "Kidney API" python main.py

echo.
echo Step 5: Waiting for API to start...
timeout /t 5 /nobreak > nul

echo.
echo Step 6: Starting Flutter app...
cd ..
flutter run

echo.
echo Setup complete! The app should now be running.
echo API is available at: http://localhost:8000
echo.
pause 