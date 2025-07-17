
# 🏥 Kidney Disease Prediction App

A comprehensive mobile application that leverages artificial intelligence to detect and classify kidney diseases from medical images. Built with Flutter for cross-platform mobile development and powered by a sophisticated FastAPI backend with deep learning models.

## 🌟 Key Features

### �� AI-Powered Disease Detection
- **Multi-Class Classification**: Detects4 kidney conditions (Cyst, Normal, Stone, Tumor)
- **Two-Stage Pipeline**: Binary kidney detection + disease classification for enhanced accuracy
- **Advanced Models**: ResNet152, VGG16 custom CNN models with transfer learning
- **Real-time Processing**: Fast inference with optimized TensorFlow models

### 📱 Cross-Platform Mobile App
- **Flutter Framework**: Native performance on iOS and Android
- **Bilingual Support**: English and Arabic localization
- **Intuitive UI/UX**: Modern Material Design with responsive layouts
- **Image Capture**: Camera and gallery integration with validation

### 🏗️ Robust Backend Architecture
- **FastAPI Framework**: High-performance Python backend
- **RESTful API**: Clean endpoints for prediction and segmentation
- **CORS Support**: Seamless mobile app integration
- **Error Handling**: Comprehensive validation and user feedback

### �� Advanced Features
- **Tumor Segmentation**: Precise tumor boundary detection
- **Image Validation**: Quality assessment and filtering
- **Confidence Scoring**: Reliability metrics for predictions
- **Recommendations**: Personalized health advice based on results

## ��️ Technical Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.7+
- **State Management**: Provider pattern
- **Image Processing**: Image picker, compression, and validation
- **Localization**: Multi-language support (EN/AR)
- **UI Components**: Custom widgets and responsive design

### Backend (Python/FastAPI)
- **Framework**: FastAPI with Uvicorn
- **Machine Learning**: TensorFlow/Keras, ResNet152**Image Processing**: OpenCV, PIL, NumPy
- **Performance**: Model optimization, caching, compression
- **Validation**: Enhanced image validation and OOD detection

### Models & AI
- **Primary Model**: ResNet152 with transfer learning
- **Fallback Models**: VGG16, Custom CNN architectures
- **Binary Classifier**: Kidney vs non-kidney detection
- **Segmentation**: U-Net architecture for tumor detection
- **Optimization**: TensorFlow Lite support, model quantization

## 📊 Performance Metrics

- **Accuracy**: High classification accuracy across disease categories
- **Speed**: Sub-second inference times on mobile devices
- **Reliability**: Robust error handling and validation
- **Scalability**: Multi-worker support for production deployment

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Flutter SDK 3.7+
- Android Studio / Xcode
- TensorFlow 2.x

### Backend Setup
```bash
cd api
pip install -r requirements.txt
python main.py
```

### Mobile App Setup
```bash
flutter pub get
flutter run
```

### API Endpoints
- `POST /predict` - Disease classification
- `POST /segment-tumor` - Tumor segmentation
- `GET /health` - Service health check
- `GET /docs` - Interactive API documentation

## 📁 Project Structure
kidney/
├── api/ # FastAPI backend 

│ ├── main.py # Main API server

│ ├── services.py # ML model services

│ ├── enhanced_validation.py # Image validation

│ └── models/ # Trained ML models

├── lib/ # Flutter app source

│ ├── screens/ # UI screens

│ ├── widgets/ # Reusable components

│ ├── models/ # Data models

│ ├── providers/ # State management

│ └── core/ # Core services

├── assets/ # App assets

└── docs/ # Documentation


## �� Configuration

### Model Configuration
- Place trained models in `api/` directory
- Configure model paths in `main.py`
- Adjust confidence thresholds as needed

### API Configuration
- Update CORS settings for production
- Configure worker processes for scaling
- Set up environment variables for deployment

### Mobile App Configuration
- Update API base URL in `api_service.dart`
- Configure image quality settings
- Customize UI themes and localization



## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests and documentation
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## �� Acknowledgments

- Medical imaging datasets and research
- TensorFlow and Keras communities
- Flutter development team
- Open-source contributors

## 📞 Support

For questions, issues, or contributions, please open an issue on GitHub or contact the development team.

---

**Built with ❤️ for advancing medical AI and improving healthcare accessibility**
