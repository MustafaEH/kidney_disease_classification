import numpy as np
import cv2
import tensorflow as tf
from PIL import Image
import logging
from typing import Dict, Any, Tuple
import os

logger = logging.getLogger(__name__)

class KidneyModelService:
    def __init__(self):
        self.model = None
        self.classes = ['Cyst', 'Normal', 'Stone', 'Tumor']
        self.IMGSIZE = 128
        self.model_path = 'kidney_model.h5'
        self.load_model()
    
    def load_model(self):
        """Load the trained kidney classification model"""
        try:
            if os.path.exists(self.model_path):
                self.model = tf.keras.models.load_model(self.model_path)
                logger.info("Model loaded successfully from saved file")
            else:
                logger.warning("Saved model not found. Creating new model (will need training)")
                self.model = self.create_model()
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            self.model = self.create_model()
    
    def create_model(self):
        """Create the CNN model architecture"""
        from tensorflow.keras.models import Sequential
        from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
        
        model = Sequential()
        
        model.add(Conv2D(filters=32, kernel_size=(3, 3), activation='relu', input_shape=(self.IMGSIZE, self.IMGSIZE, 3)))
        model.add(MaxPooling2D((2,2)))
        model.add(Dropout(0.25))
        
        model.add(Conv2D(filters=64, kernel_size=(3, 3), activation='relu'))
        model.add(MaxPooling2D((2,2)))
        
        model.add(Conv2D(filters=128, kernel_size=(3, 3), activation='relu'))
        model.add(MaxPooling2D((2,2)))
        
        model.add(Flatten())
        model.add(Dense(256, activation='relu'))
        model.add(Dropout(0.25))
        
        model.add(Dense(128, activation='relu'))
        model.add(Dropout(0.25))
        
        model.add(Dense(64, activation='relu'))
        model.add(Dense(4, activation='softmax'))
        
        model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
        
        return model
    
    def preprocess_image(self, image: Image.Image) -> np.ndarray:
        """Preprocess image for model input"""
        try:
            # Convert PIL image to numpy array
            img_array = np.array(image)
            
            # Convert to RGB if needed
            if len(img_array.shape) == 3 and img_array.shape[2] == 4:  # RGBA
                img_array = cv2.cvtColor(img_array, cv2.COLOR_RGBA2RGB)
            elif len(img_array.shape) == 2:  # Grayscale
                img_array = cv2.cvtColor(img_array, cv2.COLOR_GRAY2RGB)
            
            # Resize to model input size
            img_resized = cv2.resize(img_array, (self.IMGSIZE, self.IMGSIZE))
            
            # Normalize pixel values
            img_normalized = img_resized.astype(np.float32) / 255.0
            
            # Add batch dimension
            img_batch = np.expand_dims(img_normalized, axis=0)
            
            return img_batch
            
        except Exception as e:
            logger.error(f"Error preprocessing image: {e}")
            raise
    
    def predict(self, image: Image.Image) -> Dict[str, Any]:
        """Make prediction on the input image"""
        try:
            if self.model is None:
                raise Exception("Model not loaded")
            
            # Preprocess image
            processed_image = self.preprocess_image(image)
            
            # Make prediction
            predictions = self.model.predict(processed_image, verbose=False)
            
            # Get predicted class and confidence
            predicted_class_idx = np.argmax(predictions[0])
            confidence = float(predictions[0][predicted_class_idx])
            predicted_class = self.classes[predicted_class_idx]
            
            # Get all class probabilities
            class_probabilities = {
                class_name: float(prob) 
                for class_name, prob in zip(self.classes, predictions[0])
            }
            
            return {
                'disease': predicted_class,
                'confidence': confidence,
                'class_probabilities': class_probabilities,
                'predictions': predictions[0].tolist()
            }
            
        except Exception as e:
            logger.error(f"Error making prediction: {e}")
            raise
    
    def get_severity_and_message(self, disease: str, confidence: float) -> Tuple[str, str]:
        """Get severity level and message based on prediction"""
        if disease.lower() == 'normal':
            severity = "None"
            message = "No kidney disease detected. Your kidneys appear healthy."
        else:
            if confidence > 0.9:
                severity = "High"
                message = f"Strong indication of {disease.lower()} detected. Please consult a healthcare professional immediately."
            elif confidence > 0.7:
                severity = "Medium"
                message = f"Moderate indication of {disease.lower()} detected. Please consult a healthcare professional for proper diagnosis."
            else:
                severity = "Low"
                message = f"Possible indication of {disease.lower()} detected. Consider consulting a healthcare professional for further evaluation."
        
        return severity, message
    
    def get_recommendations(self, disease: str, severity: str) -> list:
        """Get personalized recommendations based on prediction"""
        if disease.lower() == 'normal':
            return [
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
            
            if disease.lower() == 'cyst':
                recommendations.extend([
                    "Monitor cyst size regularly",
                    "Avoid activities that may cause trauma to the kidney area"
                ])
            elif disease.lower() == 'stone':
                recommendations.extend([
                    "Increase water intake to help pass stones",
                    "Follow dietary recommendations to prevent future stones"
                ])
            elif disease.lower() == 'tumor':
                recommendations.extend([
                    "Seek immediate medical attention",
                    "Prepare for potential imaging and biopsy procedures"
                ])
            
            return recommendations

# Global model service instance
model_service = KidneyModelService() 