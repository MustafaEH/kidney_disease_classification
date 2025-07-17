"""
Create a test model for immediate testing of the kidney classification API.
This creates a simple model that can be used to test the Flutter app integration.
"""

import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
import os

def create_test_model():
    """Create a simple test model for kidney classification"""
    print("Creating test kidney classification model...")
    
    IMGSIZE = 128
    
    model = Sequential()
    
    # Simple CNN architecture
    model.add(Conv2D(filters=16, kernel_size=(3, 3), activation='relu', input_shape=(IMGSIZE, IMGSIZE, 3)))
    model.add(MaxPooling2D((2,2)))
    model.add(Dropout(0.25))
    
    model.add(Conv2D(filters=32, kernel_size=(3, 3), activation='relu'))
    model.add(MaxPooling2D((2,2)))
    model.add(Dropout(0.25))
    
    model.add(Flatten())
    model.add(Dense(64, activation='relu'))
    model.add(Dropout(0.25))
    model.add(Dense(4, activation='softmax'))
    
    model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
    
    # Save the model
    model.save('kidney_model.h5')
    print("Test model saved as kidney_model.h5")
    
    # Print model summary
    print("\nModel Summary:")
    model.summary()
    
    print("\nModel classes: ['Cyst', 'Normal', 'Stone', 'Tumor']")
    print("Input shape: (128, 128, 3)")
    print("Output shape: (4,) - probabilities for each class")
    print("\nNote: This is a test model for demonstration purposes.")
    print("For production use, replace with your trained model.")
    
    return model

if __name__ == "__main__":
    create_test_model() 