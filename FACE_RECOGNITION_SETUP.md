# Face Recognition Authentication Setup Guide

This guide will help you set up the face recognition authentication system for AgroSense.

## Prerequisites

1. Python 3.8 or higher installed
2. The face recognition model file: `FaceRecognition/siamesemodelv2.h5`
3. Verification images in: `FaceRecognition/application_data/verification_images/`

## Step 1: Install Python Dependencies

1. Open a terminal in the project root directory
2. Install the required Python packages:

```bash
pip install -r requirements_face_recognition.txt
```

Or install manually:

```bash
pip install flask flask-cors numpy opencv-python Pillow tensorflow
```

## Step 2: Verify File Structure

Make sure your project has the following structure:

```
AgroSense/
├── FaceRecognition/
│   ├── siamesemodelv2.h5          # Your trained model
│   └── application_data/
│       ├── input_image/            # Will be created automatically
│       └── verification_images/   # Your reference images (60+ images)
│           ├── image1.jpg
│           ├── image2.jpg
│           └── ...
├── face_recognition_service.py    # Python service
└── lib/
    └── screens/
        └── face_auth_screen.dart  # Flutter authentication screen
```

## Step 3: Start the Python Service

1. Open a terminal in the project root directory
2. Run the face recognition service:

```bash
python face_recognition_service.py
```

You should see:
```
Starting Face Recognition Service...
Model loaded successfully!
 * Running on http://0.0.0.0:8001
```

## Step 4: Configure Flutter App

The Flutter app is already configured to connect to `http://localhost:8001` by default.

### For Android Emulator:
- Use `http://10.0.2.2:8001` (update in `lib/services/face_recognition_service.dart`)

### For Physical Device:
- Find your computer's IP address (e.g., `192.168.1.100`)
- Update the `_baseUrl` in `lib/services/face_recognition_service.dart`:
  ```dart
  static const String _baseUrl = 'http://192.168.1.100:8001';
  ```

## Step 5: Test the Service

1. Make sure the Python service is running
2. Launch your Flutter app
3. Tap "Authenticate with Face" on the welcome screen
4. Grant camera permissions when prompted
5. Capture your face
6. The app will verify your face against the verification images

## Troubleshooting

### Model Not Found
- Ensure `siamesemodelv2.h5` is in the `FaceRecognition/` directory
- Check the path in `face_recognition_service.py` (line 20)

### No Verification Images
- Ensure images are in `FaceRecognition/application_data/verification_images/`
- Supported formats: `.jpg`, `.jpeg`, `.png`
- You should have at least 10-20 verification images for best results

### Connection Error
- Check if Python service is running on port 8001
- Verify the URL in `face_recognition_service.dart` matches your setup
- For physical devices, ensure phone and computer are on the same network

### Low Recognition Accuracy
- Adjust the `threshold` value in `face_recognition_service.py` (line 120)
- Typical values: 0.7-0.9
- Lower threshold = more lenient (more false positives)
- Higher threshold = stricter (more false negatives)

### Model Architecture Issues
- If your model has a different input size, update `preprocess_image()` function
- If your model outputs embeddings differently, update `get_face_embedding()` function
- Check your model's expected input/output format

## Model Customization

If your Siamese model has a different architecture:

1. **Input Size**: Update the resize dimensions in `preprocess_image()` (line 35)
2. **Embedding Extraction**: Modify `get_face_embedding()` based on your model's output layer
3. **Similarity Metric**: You can change from cosine similarity to Euclidean distance if preferred

## Security Notes

- The service runs on your local network - not suitable for production without additional security
- For production, add authentication tokens, HTTPS, and rate limiting
- Consider using Firebase Authentication alongside face recognition for better security

## Next Steps

1. Test with multiple face images
2. Fine-tune the similarity threshold
3. Add error handling for edge cases
4. Consider adding face detection before recognition (using OpenCV or ML Kit)

