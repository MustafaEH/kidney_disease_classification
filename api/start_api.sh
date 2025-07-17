#!/bin/bash
echo "Starting Kidney Disease Prediction API..."
echo ""
echo "Installing dependencies..."
pip install -r requirements.txt
echo ""
echo "Starting server..."
python main.py 