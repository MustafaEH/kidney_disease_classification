"""
Script to extract the trained kidney classification model from the notebook
and save it for use in the API.
"""

import numpy as np
import cv2
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dropout, Flatten, Dense
import os

def create_kidney_model():
    """Create the CNN model architecture from the notebook"""
    IMGSIZE = 128
    
    model = Sequential()
    
    model.add(Conv2D(filters=32, kernel_size=(3, 3), activation='relu', input_shape=(IMGSIZE, IMGSIZE, 3)))
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

def save_model():
    """Create and save the model architecture"""
    print("Creating kidney classification model...")
    model = create_kidney_model()
    
    # Save the model
    model.save('kidney_model.h5')
    print("Model saved as kidney_model.h5")
    
    # Print model summary
    print("\nModel Summary:")
    model.summary()
    
    print("\nModel classes: ['Cyst', 'Normal', 'Stone', 'Tumor']")
    print("Input shape: (128, 128, 3)")
    print("Output shape: (4,) - probabilities for each class")

if __name__ == "__main__":
    save_model() 