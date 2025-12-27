import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

class FaceDetectionService {
  late FaceDetector _faceDetector;

  FaceDetectionService() {
    final options = FaceDetectorOptions(
      enableClassification: false,
      enableLandmarks: false,
      enableContours: false,
      enableTracking: false,
      minFaceSize: 0.1,
      performanceMode: FaceDetectorMode.fast,
    );
    _faceDetector = FaceDetector(options: options);
  }

  /// Detects face in image and crops it to 250x250
  /// Returns the cropped face image, or null if no face detected
  Future<Uint8List?> detectAndCropFace(File imageFile, {int targetSize = 250}) async {
    try {
      // Read image
      final imageBytes = await imageFile.readAsBytes();
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Detect faces
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        print('No face detected in image');
        return null;
      }

      // Get the largest face (most likely the main subject)
      Face largestFace = faces.first;
      for (final face in faces) {
        final currentArea = face.boundingBox.width * face.boundingBox.height;
        final largestArea = largestFace.boundingBox.width * largestFace.boundingBox.height;
        if (currentArea > largestArea) {
          largestFace = face;
        }
      }

      // Decode image for cropping
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw 'Failed to decode image';
      }

      // Get face bounding box
      final boundingBox = largestFace.boundingBox;
      
      // Calculate crop region with some padding
      final padding = 0.2; // 20% padding around face
      final paddingX = (boundingBox.width * padding).round();
      final paddingY = (boundingBox.height * padding).round();
      
      int x = ((boundingBox.left - paddingX).clamp(0, originalImage.width)).toInt();
      int y = ((boundingBox.top - paddingY).clamp(0, originalImage.height)).toInt();
      int width = ((boundingBox.width + (paddingX * 2)).clamp(1, originalImage.width - x)).toInt();
      int height = ((boundingBox.height + (paddingY * 2)).clamp(1, originalImage.height - y)).toInt();

      // Crop the face region
      final croppedImage = img.copyCrop(
        originalImage,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Resize to target size (250x250)
      final resizedImage = img.copyResize(
        croppedImage,
        width: targetSize,
        height: targetSize,
        interpolation: img.Interpolation.cubic,
      );

      // Convert to JPEG bytes
      final outputBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 95),
      );

      return outputBytes;
    } catch (e) {
      print('Face detection error: $e');
      return null;
    }
  }

  /// Saves cropped face to a file
  Future<File?> detectAndSaveCroppedFace(
    File imageFile,
    String outputPath, {
    int targetSize = 250,
  }) async {
    try {
      final croppedBytes = await detectAndCropFace(imageFile, targetSize: targetSize);
      
      if (croppedBytes == null) {
        return null;
      }

      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(croppedBytes);
      return outputFile;
    } catch (e) {
      print('Error saving cropped face: $e');
      return null;
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}

