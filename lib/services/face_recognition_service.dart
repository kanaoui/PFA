import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'face_detection_service.dart';

class FaceRecognitionService {
  // HTTP service URL - update this to match your Python service
  // For Android Emulator: use 10.0.2.2 instead of localhost
  static const String _baseUrl = 'http://10.0.2.2:8001';
  // For real device on same network: http://YOUR_PC_IP:8001
  // For localhost (if testing on same machine): http://localhost:8001

  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  bool _isInitialized = false;

  Future<void> initialize() async {
    _isInitialized = true;
  }

  /// Captures face image, detects and crops face, then verifies against verification images
  /// Returns true if face is recognized, false otherwise
  Future<bool> verifyFace(File capturedImage) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Step 1: Detect and crop face to 250x250
      print('Detecting face in image...');
      final croppedFaceBytes = await _faceDetectionService.detectAndCropFace(
        capturedImage,
        targetSize: 250,
      );

      if (croppedFaceBytes == null) {
        throw 'No face detected in the image. Please ensure your face is clearly visible and well-lit.';
      }

      print('Face detected and cropped to 250x250');

      // Step 2: Encode cropped face to base64
      final base64Image = base64Encode(croppedFaceBytes);

      // Step 3: Send to Python service for verification
      print('Sending to verification service...');
      final response = await http.post(
        Uri.parse('$_baseUrl/verify_face'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw 'Connection timeout. Please ensure the Python service is running on port 8001.';
        },
      );

      if (response.statusCode != 200) {
        throw 'Server error (${response.statusCode}): ${response.body}';
      }

      final data = jsonDecode(response.body);
      return data['verified'] == true;
    } catch (e) {
      print('Face verification error: $e');
      if (e.toString().contains('Connection refused') || 
          e.toString().contains('Failed host lookup')) {
        throw 'Cannot connect to face recognition service. Please ensure the Python service is running:\n\n1. Open terminal in project root\n2. Run: python face_recognition_service.py\n3. Make sure it shows "Running on http://0.0.0.0:8001"';
      }
      throw 'Face verification failed: $e';
    }
  }

  /// Saves captured image to input_image folder
  Future<File> saveInputImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final inputImageDir = Directory(
        path.join(appDir.path, 'FaceRecognition', 'application_data', 'input_image'),
      );

      if (!await inputImageDir.exists()) {
        await inputImageDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedImage = File(
        path.join(inputImageDir.path, 'input_$timestamp.jpg'),
      );

      await imageFile.copy(savedImage.path);
      return savedImage;
    } catch (e) {
      throw 'Failed to save input image: $e';
    }
  }

  /// Gets the path to verification images directory
  Future<String> getVerificationImagesPath() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      return path.join(
        appDir.path,
        'FaceRecognition',
        'application_data',
        'verification_images',
      );
    } catch (e) {
      throw 'Failed to get verification images path: $e';
    }
  }
}

