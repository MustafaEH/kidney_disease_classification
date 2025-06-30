# Kidney Disease Prediction API

A FastAPI backend for predicting kidney diseases from medical images using a trained CNN model.

## Model Information

The API uses a CNN model that classifies kidney images into 4 categories:
- **Cyst**: Kidney cysts
- **Normal**: Healthy kidneys
- **Stone**: Kidney stones
- **Tumor**: Kidney tumors

**Model Architecture:**
- Input: 128x128 RGB images
- Output: 4-class probabilities
- Architecture: CNN with Conv2D, MaxPooling2D, Dropout, and Dense layers

## Setup

### 1. Install Dependencies
```bash
pip install -r requirements.txt
```

### 2. Model Setup

#### Option A: Use Pre-trained Model (Recommended)
If you have the trained model file (`model4.h5` from the notebook):
```bash
# Copy your trained model to the api directory
cp /path/to/your/model4.h5 kidney_model.h5
```

#### Option B: Create Model Architecture
If you don't have the trained model, create the architecture:
```bash
python setup_model.py
```
**Note:** This creates an untrained model. You'll need to train it or load pre-trained weights.

### 3. Run the API Server
```bash
python main.py
```

The API will be available at `http://localhost:8000`

## API Endpoints

- `GET /` - API status
- `GET /health` - Health check
- `POST /predict` - Predict disease from uploaded image file
- `POST /predict-base64` - Predict disease from base64 encoded image

## Usage

### Upload Image File
```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@kidney_image.jpg"
```

### Base64 Image
```bash
curl -X POST "http://localhost:8000/predict-base64" \
     -H "Content-Type: application/json" \
     -d '{"image": "base64_encoded_image_data"}'
```

## Response Format
```json
{
  "disease": "Normal",
  "confidence": 0.95,
  "severity": "None",
  "message": "No kidney disease detected. Your kidneys appear healthy.",
  "recommendations": [
    "Continue maintaining a healthy lifestyle",
    "Stay hydrated with adequate water intake",
    "Regular exercise and balanced diet",
    "Annual check-ups recommended"
  ],
  "timestamp": 1703123456.789
}
```

## Model Integration Steps

### 1. Extract Model from Notebook
From your Jupyter notebook, save the trained model:
```python
# In your notebook, after training
model.save('kidney_model.h5')
```

### 2. Copy Model to API Directory
```bash
cp /path/to/your/kidney_model.h5 api/
```

### 3. Test the API
```bash
# Start the API
cd api
python main.py

# Test with an image
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@test_image.jpg"
```

## Integration with Flutter

The Flutter app will send images to this API and display the prediction results.

## Troubleshooting

### Model Loading Issues
- Ensure `kidney_model.h5` exists in the api directory
- Check that TensorFlow is properly installed
- Verify the model file is not corrupted

### Prediction Issues
- Ensure images are in RGB format
- Images will be automatically resized to 128x128
- Check API logs for detailed error messages

### Performance
- First prediction may be slower due to model loading
- Subsequent predictions will be faster
- Consider using GPU acceleration for better performance 