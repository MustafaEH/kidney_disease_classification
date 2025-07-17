# Cloud Deployment Guide - Access from Anywhere

## 🚀 Deploy API to Cloud

### Option A: Heroku (Easy & Free)

#### Step 1: Prepare for Heroku
Create `Procfile` in the `api` folder:
```
web: uvicorn main:app --host=0.0.0.0 --port=$PORT
```

#### Step 2: Create requirements.txt
```bash
cd api
pip freeze > requirements.txt
```

#### Step 3: Deploy to Heroku
```bash
# Install Heroku CLI
# Login to Heroku
heroku login

# Create app
heroku create your-kidney-api

# Deploy
git add .
git commit -m "Deploy kidney API"
git push heroku main
```

#### Step 4: Update App Configuration
```dart
static List<String> get alternativeUrls => [
  'https://your-kidney-api.herokuapp.com',  // Your Heroku URL
  'http://192.168.1.4:8000',               // Local backup
  // ... other URLs
];
```

### Option B: Railway (Simple & Fast)

#### Step 1: Connect to Railway
1. Go to railway.app
2. Connect your GitHub repository
3. Deploy automatically

#### Step 2: Get Your URL
Railway provides a URL like: `https://your-app.railway.app`

#### Step 3: Update App
```dart
'https://your-app.railway.app'
```

### Option C: Google Cloud Run

#### Step 1: Create Dockerfile
```dockerfile
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

#### Step 2: Deploy
```bash
gcloud run deploy kidney-api --source .
```

## 🔧 Update API for Cloud

### Step 1: Environment Variables
Update `api/main.py`:
```python
import os

# Use environment variable for port
PORT = int(os.environ.get("PORT", 8000))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=PORT)
```

### Step 2: CORS Settings
Update CORS in `api/main.py`:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### Step 3: Model Loading
Ensure model file is included in deployment:
```python
# In create_test_model.py, save to current directory
model.save('./kidney_model.h5')
```

## 📱 Update Flutter App

### Step 1: Add Cloud URL
Update `lib/core/api_service.dart`:
```dart
static List<String> get alternativeUrls => [
  'https://your-cloud-api.com',    // Cloud URL
  'http://192.168.1.4:8000',       // Local backup
  'http://10.0.2.2:8000',          // Emulator
  'http://localhost:8000',          // iOS simulator
];
```

### Step 2: Test Connection
```dart
// Test cloud connection
final isCloudAvailable = await http.get(
  Uri.parse('https://your-cloud-api.com/health')
).timeout(Duration(seconds: 5));
```

## 🌐 Benefits of Cloud Deployment

### ✅ Advantages:
- **Works from anywhere** (mobile data, different WiFi)
- **No port forwarding needed**
- **Always available** (24/7)
- **Scalable** (handles multiple users)
- **Professional** (HTTPS, domain name)

### ⚠️ Considerations:
- **Cost**: Some cloud services charge after free tier
- **Security**: API is publicly accessible
- **Dependencies**: Requires internet connection
- **Setup**: More complex than local setup

## 🛡️ Security for Cloud Deployment

### Add Authentication:
```python
# In api/main.py
from fastapi import HTTPException, Depends
from fastapi.security import HTTPBearer

security = HTTPBearer()

@app.post("/predict")
async def predict_disease(
    file: UploadFile = File(...),
    token: str = Depends(security)
):
    # Verify token
    if token != "your-secret-token":
        raise HTTPException(status_code=401, detail="Invalid token")
    # ... rest of code
```

### Rate Limiting:
```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter

@app.post("/predict")
@limiter.limit("10/minute")
async def predict_disease(request: Request, file: UploadFile = File(...)):
    # ... your code
```

## 📊 Monitoring

### Health Checks:
```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": time.time(),
        "model_loaded": model is not None
    }
```

### Logging:
```python
import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.post("/predict")
async def predict_disease(file: UploadFile = File(...)):
    logger.info(f"Processing image: {file.filename}")
    # ... rest of code
```

## 🎯 Quick Deployment Checklist

### For Heroku:
- [ ] Create Procfile
- [ ] Update requirements.txt
- [ ] Deploy with Heroku CLI
- [ ] Update app configuration
- [ ] Test from mobile data

### For Railway:
- [ ] Connect GitHub repository
- [ ] Deploy automatically
- [ ] Get deployment URL
- [ ] Update app configuration
- [ ] Test connection

## 🚀 Production Recommendations

### Best Practices:
1. **Use HTTPS** for all connections
2. **Add authentication** to prevent abuse
3. **Implement rate limiting** to control usage
4. **Monitor usage** and costs
5. **Set up alerts** for downtime
6. **Backup your model** regularly

### Scaling:
- **Start with free tier** (Heroku, Railway)
- **Monitor usage** and upgrade as needed
- **Consider paid services** for production use
- **Implement caching** for better performance

**Your app can now work from anywhere in the world!** 🌍✨ 