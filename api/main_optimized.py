from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
import io
import base64
from PIL import Image
import numpy as np
import cv2
import tensorflow as tf
import time
from typing import Dict, Any
import logging
import threading

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="Kidney Disease Prediction API (Optimized)", version="1.0.0")

# Add CORS middleware to allow Flutter app to connect
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Model configuration
CLASSES = ['Cyst', 'Normal', 'Stone', 'Tumor']
IMGSIZE = 128
model = None
model_lock = threading.Lock()

def create_kidney_model():
    """Create the CNN model architecture"""
    model = tf.keras.Sequential()
    
    model.add(tf.keras.layers.Conv2D(filters=32, kernel_size=(3, 3), activation='relu', input_shape=(IMGSIZE, IMGSIZE, 3)))
    model.add(tf.keras.layers.MaxPooling2D((2,2)))
    model.add(tf.keras.layers.Dropout(0.25))
    
    model.add(tf.keras.layers.Conv2D(filters=64, kernel_size=(3, 3), activation='relu'))
    model.add(tf.keras.layers.MaxPooling2D((2,2)))
    
    model.add(tf.keras.layers.Conv2D(filters=128, kernel_size=(3, 3), activation='relu'))
    model.add(tf.keras.layers.MaxPooling2D((2,2)))
    
    model.add(tf.keras.layers.Flatten())
    model.add(tf.keras.layers.Dense(256, activation='relu'))
    model.add(tf.keras.layers.Dropout(0.25))
    
    model.add(tf.keras.layers.Dense(128, activation='relu'))
    model.add(tf.keras.layers.Dropout(0.25))
    
    model.add(tf.keras.layers.Dense(64, activation='relu'))
    model.add(tf.keras.layers.Dense(4, activation='softmax'))
    
    model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
    
    return model

def load_model():
    """Load or create the kidney classification model with optimizations"""
    global model
    try:
        # Try to load saved model
        model = tf.keras.models.load_model('kidney_model.h5')
        
        # Warm up the model with a dummy prediction to optimize for inference
        dummy_input = np.random.random((1, IMGSIZE, IMGSIZE, 3)).astype(np.float32)
        _ = model.predict(dummy_input, verbose=False)
        
        logger.info("Model loaded and warmed up successfully")
    except Exception as e:
        logger.warning(f"Saved model not found or error loading: {e}. Creating new model (will need training)")
        model = create_kidney_model()

def preprocess_image(image: Image.Image) -> np.ndarray:
    """Optimized image preprocessing"""
    try:
        # Convert PIL image to numpy array with correct dtype
        img_array = np.array(image, dtype=np.float32)
        
        # Convert to RGB if needed (more efficient)
        if len(img_array.shape) == 3 and img_array.shape[2] == 4:  # RGBA
            img_array = img_array[:, :, :3]  # Take only RGB channels
        elif len(img_array.shape) == 2:  # Grayscale
            img_array = np.stack([img_array] * 3, axis=-1)
        
        # Resize to model input size (more efficient with cv2)
        img_resized = cv2.resize(img_array, (IMGSIZE, IMGSIZE), interpolation=cv2.INTER_AREA)
        
        # Normalize pixel values (vectorized operation)
        img_normalized = img_resized / 255.0
        
        # Add batch dimension
        img_batch = np.expand_dims(img_normalized, axis=0)
        
        return img_batch
        
    except Exception as e:
        logger.error(f"Error preprocessing image: {e}")
        raise

def is_kidney_scan_image(image: Image.Image) -> Dict[str, Any]:
    """
    Optimized validation for kidney scan images
    """
    try:
        # Convert to numpy array
        img_array = np.array(image)
        
        # Quick checks for medical imaging characteristics
        
        # 1. Check if image is grayscale
        if len(img_array.shape) == 2:  # Grayscale
            return {
                "is_kidney_scan": True,
                "confidence": 0.8,
                "reason": "Grayscale medical image detected"
            }
        
        # 2. Quick color variance check (more efficient)
        if len(img_array.shape) == 3:
            # Use only a sample of pixels for faster computation
            sample_size = min(1000, img_array.shape[0] * img_array.shape[1])
            indices = np.random.choice(img_array.shape[0] * img_array.shape[1], sample_size, replace=False)
            sample_pixels = img_array.reshape(-1, 3)[indices]
            
            # Calculate color variance on sample
            r, g, b = sample_pixels[:, 0], sample_pixels[:, 1], sample_pixels[:, 2]
            color_variance = np.std(r - g) + np.std(g - b) + np.std(r - b)
            
            if color_variance < 20:  # Low color variance indicates grayscale-like
                return {
                    "is_kidney_scan": True,
                    "confidence": 0.8,
                    "reason": "Medical scan-like image detected (low color variation)"
                }
            
            # Quick brightness and contrast check
            brightness = np.mean(sample_pixels)
            contrast = np.std(sample_pixels)
            
            if 50 < brightness < 200 and 20 < contrast < 100:
                return {
                    "is_kidney_scan": True,
                    "confidence": 0.7,
                    "reason": "Medical image characteristics detected"
                }
        
        return {
            "is_kidney_scan": False,
            "confidence": 0.9,
            "reason": "Image does not appear to be a medical scan"
        }
        
    except Exception as e:
        return {
            "is_kidney_scan": False,
            "confidence": 0.5,
            "reason": f"Error validating image: {str(e)}"
        }

def predict_kidney_disease(image: Image.Image) -> Dict[str, Any]:
    """Optimized prediction using the trained model"""
    global model
    
    if model is None:
        raise Exception("Model not loaded")
    
    try:
        # Quick validation (faster version)
        validation = is_kidney_scan_image(image)
        
        if not validation["is_kidney_scan"]:
            return {
                "disease": "Invalid Image",
                "confidence": validation["confidence"],
                "severity": "None",
                "message": f"This image does not appear to be a kidney scan. {validation['reason']}. Please upload a clear kidney ultrasound, CT scan, or MRI image for analysis.",
                "recommendations": [
                    "Upload a clear kidney ultrasound image",
                    "Use CT scan or MRI images of the kidney area",
                    "Ensure the image shows kidney structures clearly",
                    "Avoid photos of people, objects, or non-medical images",
                    "Make sure the image is well-lit and in focus"
                ],
                "timestamp": time.time(),
                "validation_error": True
            }
        
        # Preprocess image
        processed_image = preprocess_image(image)
        
        # Make prediction with thread safety
        with model_lock:  # Thread-safe prediction
            predictions = model.predict(processed_image, verbose=False)
        
        # Get predicted class and confidence
        predicted_class_idx = np.argmax(predictions[0])
        confidence = float(predictions[0][predicted_class_idx])
        predicted_class = CLASSES[predicted_class_idx]
        
        # Get severity and message
        if predicted_class.lower() == 'normal':
            severity = "None"
            message = "No kidney disease detected. Your kidneys appear healthy."
        else:
            if confidence > 0.9:
                severity = "High"
                message = f"Strong indication of {predicted_class.lower()} detected. Please consult a healthcare professional immediately."
            elif confidence > 0.7:
                severity = "Medium"
                message = f"Moderate indication of {predicted_class.lower()} detected. Please consult a healthcare professional for proper diagnosis."
            else:
                severity = "Low"
                message = f"Possible indication of {predicted_class.lower()} detected. Consider consulting a healthcare professional for further evaluation."
        
        # Get recommendations
        if predicted_class.lower() == 'normal':
            recommendations = [
                "Continue maintaining a healthy lifestyle",
                "Stay hydrated with adequate water intake",
                "Regular exercise and balanced diet",
                "Annual check-ups recommended"
            ]
        else:
            recommendations = [
                "Consult a nephrologist immediately",
                "Follow up with additional tests",
                "Monitor symptoms closely",
                "Maintain prescribed medications if any"
            ]
            
            if predicted_class.lower() == 'cyst':
                recommendations.extend([
                    "Monitor cyst size regularly",
                    "Avoid activities that may cause trauma to the kidney area"
                ])
            elif predicted_class.lower() == 'stone':
                recommendations.extend([
                    "Increase water intake to help pass stones",
                    "Follow dietary recommendations to prevent future stones"
                ])
            elif predicted_class.lower() == 'tumor':
                recommendations.extend([
                    "Seek immediate medical attention",
                    "Prepare for potential imaging and biopsy procedures"
                ])
        
        return {
            "disease": predicted_class,
            "confidence": confidence,
            "severity": severity,
            "message": message,
            "recommendations": recommendations,
            "timestamp": time.time(),
            "validation_error": False
        }
        
    except Exception as e:
        logger.error(f"Error making prediction: {e}")
        raise

@app.on_event("startup")
async def startup_event():
    """Load model on startup"""
    load_model()

@app.get("/")
async def root():
    return {"message": "Kidney Disease Prediction API (Optimized)", "status": "running"}

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "kidney-disease-prediction-optimized"}

@app.post("/predict")
async def predict_disease(file: UploadFile = File(...)):
    """
    Predict kidney disease from uploaded image
    """
    try:
        # Validate file type
        if not file.content_type or not file.content_type.startswith('image/'):
            raise HTTPException(status_code=400, detail="File must be an image")
        
        # Read and validate image
        image_data = await file.read()
        image = Image.open(io.BytesIO(image_data))
        
        # Convert to RGB if necessary
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        logger.info(f"Processing image: {file.filename}, size: {image.size}")
        
        # Get prediction
        prediction = predict_kidney_disease(image)
        
        return JSONResponse(content=prediction)
        
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")

@app.post("/predict-base64")
async def predict_disease_base64(data: Dict[str, str]):
    """
    Predict kidney disease from base64 encoded image
    """
    try:
        if "image" not in data:
            raise HTTPException(status_code=400, detail="Image data not provided")
        
        # Decode base64 image
        image_data = base64.b64decode(data["image"])
        image = Image.open(io.BytesIO(image_data))
        
        # Convert to RGB if necessary
        if image.mode != 'RGB':
            image = image.convert('RGB')
        
        logger.info(f"Processing base64 image, size: {image.size}")
        
        # Get prediction
        prediction = predict_kidney_disease(image)
        
        return JSONResponse(content=prediction)
        
    except Exception as e:
        logger.error(f"Error processing base64 image: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000) 