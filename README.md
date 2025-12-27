# AgroSense 🌱

**AgroSense** is an intelligent Flutter application that integrates multiple AI models to provide comprehensive agricultural and data analysis solutions. The app features a modern, user-friendly interface with Firebase authentication, voice assistant capabilities, and on-device machine learning models.

## 📋 Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [AI Models](#ai-models)
- [Screens](#screens)
- [Dependencies](#dependencies)
- [Platform Support](#platform-support)
- [Contributing](#contributing)

## ✨ Features

### 🔐 Authentication System
- **Email/Password Authentication** via Firebase Auth
- User registration and login
- Password reset functionality
- Secure session management

### 🤖 AI Models Integration

1. **ANN (Artificial Neural Network)**
   - Image classification using TensorFlow Lite
   - Pattern recognition and data analysis
   - Supports 28x28 image input

2. **CNN (Convolutional Neural Network)**
   - Advanced image processing and classification
   - Optimized for visual data analysis
   - Supports 64x64 image input

3. **LSTM (Long Short-Term Memory)**
   - Stock market prediction and forecasting
   - Time-series data analysis
   - Buy/Sell/Hold recommendations with confidence scores

4. **RAG (Retrieval-Augmented Generation)**
   - Context-aware AI responses
   - Document ingestion and retrieval
   - Intelligent question-answering system

### 🎤 Voice Assistant
- **Speech-to-Text** integration for voice input
- **Text-to-Speech** for AI responses
- Conversational interface powered by Groq API (Llama 3.3 70B)
- Real-time voice interaction

### 🎨 Modern UI/UX
- Beautiful gradient-based design
- Responsive layout (mobile and desktop)
- Animated transitions and effects
- Sidebar navigation with expandable sections
- Profile management

## 🛠 Technologies Used

### Core Framework
- **Flutter** (SDK ^3.9.2) - Cross-platform mobile development

### Backend Services
- **Firebase Core** - Backend infrastructure
- **Firebase Auth** - User authentication
- **Firebase Storage** - File storage

### Machine Learning
- **TensorFlow Lite** (`tflite_flutter`) - On-device ML inference
- Pre-trained models: ANN, CNN, LSTM

### AI Services
- **Groq API** - Fast LLM inference (Llama 3.3 70B)
- **RAG Backend** - Custom retrieval-augmented generation service

### Media & Input
- **Image Picker** - Camera and gallery access
- **File Picker** - Document selection
- **Speech to Text** - Voice input recognition
- **Flutter TTS** - Text-to-speech synthesis

### UI/UX Libraries
- **Animated Text Kit** - Text animations
- **Flutter Animate** - Advanced animations

### Utilities
- **HTTP** - API communication
- **Flutter Dotenv** - Environment variable management
- **Image** - Image processing

## 📁 Project Structure

```
AgroSense/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart         # Firebase configuration
│   ├── screens/
│   │   ├── welcome_screen.dart      # Welcome/landing screen
│   │   ├── signin_screen.dart       # Sign in screen
│   │   ├── signup_screen.dart       # Sign up screen
│   │   ├── forgot_password_screen.dart
│   │   ├── home_screen.dart         # Main dashboard
│   │   ├── ann_screen.dart          # ANN model interface
│   │   ├── cnn_screen.dart          # CNN model interface
│   │   ├── lstm_screen.dart         # Stock prediction interface
│   │   ├── rag_screen.dart          # RAG model interface
│   │   └── voice_assistant_screen.dart
│   ├── services/
│   │   ├── auth_service.dart        # Firebase authentication
│   │   ├── ann_service.dart         # ANN model service
│   │   ├── cnn_service.dart         # CNN model service
│   │   ├── lstm_service.dart        # LSTM model service
│   │   ├── rag_service.dart         # RAG service
│   │   ├── groq_service.dart        # Groq API integration
│   │   └── local_storage_service.dart
│   └── widgets/
│       └── profile_picture_widget.dart
├── assets/
│   ├── models/
│   │   ├── ann_model.tflite         # ANN TensorFlow Lite model
│   │   ├── cnn_model.tflite         # CNN TensorFlow Lite model
│   │   └── lstm_model.tflite        # LSTM TensorFlow Lite model
│   └── labels/
│       ├── ann_labels.txt           # ANN class labels
│       ├── cnn_labels.txt           # CNN class labels
│       └── lstm_labels.txt          # LSTM prediction labels
├── android/                         # Android platform files
├── ios/                             # iOS platform files
├── web/                             # Web platform files
├── windows/                         # Windows platform files
├── linux/                           # Linux platform files
├── macos/                           # macOS platform files
├── pubspec.yaml                     # Flutter dependencies
└── README.md                        # This file
```

## 🚀 Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase account
- Groq API key (for voice assistant)

### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd AgroSense
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android/iOS apps to your Firebase project
3. Download `google-services.json` for Android and place it in `android/app/`
4. Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`
5. Run `flutterfire configure` to generate `firebase_options.dart`

### Step 4: Environment Configuration
Create a `.env` file in the root directory:
```env
GROQ_API_KEY=your_groq_api_key_here
```

Get your Groq API key from [Groq Console](https://console.groq.com/)

### Step 5: Run the App
```bash
flutter run
```

## ⚙️ Configuration

### Firebase Configuration
- Ensure `firebase_options.dart` is properly generated
- Configure Firebase Auth in Firebase Console
- Enable Email/Password authentication method

### Model Files
Ensure all TensorFlow Lite models are present in `assets/models/`:
- `ann_model.tflite`
- `cnn_model.tflite`
- `lstm_model.tflite`

### Label Files
Ensure all label files are present in `assets/labels/`:
- `ann_labels.txt`
- `cnn_labels.txt`
- `lstm_labels.txt`

### RAG Backend (Optional)
If using the RAG feature, ensure the backend service is running:
- Default URL: `http://10.0.2.2:8000` (Android emulator)
- For physical devices, update the URL in `rag_service.dart`

## 📱 Usage

### Getting Started
1. **Launch the app** - You'll see the welcome screen
2. **Sign Up/Login** - Create an account or sign in with existing credentials
3. **Explore Features** - Access the home screen with all available AI models

### Using AI Models

#### ANN Model
1. Navigate to **ANN Model** from the sidebar
2. Select an image from gallery or camera
3. View classification results with confidence scores

#### CNN Model
1. Navigate to **CNN Model** from the sidebar
2. Upload an image (64x64 recommended)
3. Get detailed image analysis and predictions

#### Stock Prediction (LSTM)
1. Navigate to **Stock Prediction** from the sidebar
2. Enter historical stock prices
3. Receive predictions (Buy/Sell/Hold) with recommendations

#### RAG Model
1. Navigate to **RAG Model** from the sidebar
2. Upload documents for ingestion
3. Ask questions and get context-aware answers

### Voice Assistant
1. Tap **Voice Assistant** from the sidebar
2. Use the microphone button to speak
3. Get AI-powered responses via text or voice
4. Type messages directly if preferred

## 🤖 AI Models

### ANN (Artificial Neural Network)
- **Purpose**: Pattern recognition and image classification
- **Input**: 28x28 RGB images
- **Output**: Classification labels with confidence scores
- **Use Cases**: General image classification, pattern detection

### CNN (Convolutional Neural Network)
- **Purpose**: Advanced image processing
- **Input**: 64x64 RGB images
- **Output**: Detailed image analysis with top predictions
- **Use Cases**: Visual data analysis, feature detection

### LSTM (Long Short-Term Memory)
- **Purpose**: Time-series forecasting and stock prediction
- **Input**: Historical stock price data
- **Output**: Buy/Sell/Hold predictions with confidence and recommendations
- **Use Cases**: Market analysis, trend forecasting

### RAG (Retrieval-Augmented Generation)
- **Purpose**: Context-aware question answering
- **Input**: Documents and questions
- **Output**: Intelligent responses based on ingested documents
- **Use Cases**: Document Q&A, knowledge retrieval

## 🖥 Screens

### Welcome Screen
- App introduction and branding
- Navigation to sign in/sign up

### Authentication Screens
- **Sign In**: Email/password login
- **Sign Up**: User registration
- **Forgot Password**: Password reset functionality

### Home Screen
- Main dashboard with feature overview
- Sidebar navigation
- Quick access to all AI models
- User profile display
- Voice assistant access

### Model Screens
Each AI model has a dedicated screen with:
- Model-specific interface
- Input controls (image picker, data entry, etc.)
- Results display with visualizations
- Confidence scores and recommendations

### Voice Assistant Screen
- Real-time speech recognition
- Text input option
- Conversation history
- Text-to-speech responses
- Visual feedback for listening state

## 📦 Dependencies

### Production Dependencies
```yaml
firebase_core: ^3.6.0
firebase_auth: ^5.3.1
firebase_storage: ^12.3.2
image_picker: ^1.1.2
cupertino_icons: ^1.0.8
animated_text_kit: ^4.2.2
flutter_animate: ^4.5.0
http: ^1.2.0
speech_to_text: ^7.0.0
flutter_tts: ^4.0.2
flutter_dotenv: ^5.1.0
tflite_flutter: ^0.12.1
image: ^4.1.7
file_picker: ^8.0.0
```

### Dev Dependencies
```yaml
flutter_test:
  sdk: flutter
flutter_lints: ^5.0.0
```

## 🌐 Platform Support

- ✅ **Android** - Fully supported
- ✅ **iOS** - Fully supported
- ✅ **Web** - Supported
- ✅ **Windows** - Supported
- ✅ **Linux** - Supported
- ✅ **macOS** - Supported

## 🔒 Security Notes

- API keys are stored in `.env` file (not committed to version control)
- Firebase handles secure authentication
- Models run on-device for privacy
- User data is stored securely in Firebase

## 🐛 Troubleshooting

### Common Issues

**Model Loading Errors**
- Ensure model files are in `assets/models/`
- Check that labels files are in `assets/labels/`
- Verify model file formats are correct

**Firebase Errors**
- Verify `firebase_options.dart` is generated
- Check Firebase project configuration
- Ensure authentication methods are enabled

**Groq API Errors**
- Verify `GROQ_API_KEY` in `.env` file
- Check API key validity
- Monitor rate limits

**Speech Recognition Issues**
- Grant microphone permissions
- Check device compatibility
- Verify speech services are available

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is part of a 5th year EMSI academic project.

## 👥 Authors

- Developed as part of 5th year EMSI curriculum

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Groq for fast AI inference
- TensorFlow team for TensorFlow Lite

---

**AgroSense** - Intelligent Solutions Hub 🌱✨
