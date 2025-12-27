import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/face_recognition_service.dart';
import 'home_screen.dart';

class FaceAuthScreen extends StatefulWidget {
  const FaceAuthScreen({super.key});

  @override
  State<FaceAuthScreen> createState() => _FaceAuthScreenState();
}

class _FaceAuthScreenState extends State<FaceAuthScreen>
    with SingleTickerProviderStateMixin {
  final FaceRecognitionService _faceService = FaceRecognitionService();
  final ImagePicker _picker = ImagePicker();
  
  File? _capturedImage;
  bool _isProcessing = false;
  bool _isCapturing = false;
  String _statusMessage = 'Position your face in the frame';
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.status;
    
    if (cameraStatus.isDenied) {
      final result = await Permission.camera.request();
      if (result.isDenied) {
        if (mounted) {
          _showError('Camera permission is required. Please grant permission in app settings.');
        }
        return;
      }
    }
    
    if (cameraStatus.isPermanentlyDenied) {
      if (mounted) {
        _showError('Camera permission is permanently denied. Please enable it in Settings > Apps > AgroSense > Permissions');
        // Optionally open app settings
        await openAppSettings();
      }
      return;
    }
  }

  Future<void> _captureFace() async {
    setState(() {
      _isCapturing = true;
      _statusMessage = 'Capturing image...';
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) {
        setState(() {
          _isCapturing = false;
          _statusMessage = 'No image captured';
        });
        return;
      }

      final imageFile = File(image.path);
      setState(() {
        _capturedImage = imageFile;
        _isCapturing = false;
        _statusMessage = 'Image captured. Verifying...';
      });

      // Automatically verify after capture
      await _verifyFace();
    } catch (e) {
      setState(() {
        _isCapturing = false;
        _statusMessage = 'Failed to capture image';
      });
      _showError('Failed to capture image: $e');
    }
  }

  Future<void> _verifyFace() async {
    if (_capturedImage == null) {
      _showError('Please capture an image first');
      return;
    }

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Verifying face...';
    });

    try {
      // Save input image
      final savedImage = await _faceService.saveInputImage(_capturedImage!);
      
      // Verify face
      final isVerified = await _faceService.verifyFace(savedImage);

      if (mounted) {
        if (isVerified) {
          setState(() {
            _statusMessage = 'Face recognized! Access granted.';
          });
          
          // Navigate to home screen after short delay
          await Future.delayed(const Duration(seconds: 1));
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          }
        } else {
          setState(() {
            _statusMessage = 'Face not recognized. Please try again.';
            _isProcessing = false;
            _capturedImage = null;
          });
          _showError('Face not recognized. Please ensure good lighting and face the camera directly.');
        }
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _statusMessage = 'Verification failed';
      });
      _showError('Verification error: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E7), Color(0xFFE8F5E9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF22C55E).withOpacity(0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Face Recognition',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF15803D),
                            ),
                          ),
                          Text(
                            'Secure Authentication',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Face Icon with Animation
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isProcessing ? _pulseAnimation.value : 1.0,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: _isProcessing
                                      ? [
                                          const Color(0xFF22C55E),
                                          const Color(0xFF16A34A),
                                        ]
                                      : [
                                          const Color(0xFF16A34A),
                                          const Color(0xFF15803D),
                                        ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: (_isProcessing
                                            ? const Color(0xFF22C55E)
                                            : const Color(0xFF16A34A))
                                        .withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isProcessing
                                    ? Icons.face_retouching_natural
                                    : Icons.face_rounded,
                                size: 100,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Status Message
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _isProcessing
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF15803D),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _isProcessing
                            ? 'Detecting face and comparing...'
                            : 'Position your face clearly in the frame',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF16A34A),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Captured Image Preview
                      if (_capturedImage != null && !_isProcessing) ...[
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF22C55E).withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _capturedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Processing Indicator
                      if (_isProcessing) ...[
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(
                          color: Color(0xFF22C55E),
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                      ],

                      const SizedBox(height: 40),

                      // Capture Button
                      if (!_isProcessing && _capturedImage == null)
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF22C55E).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isCapturing ? null : _captureFace,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isCapturing
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Capture Face',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                      // Retry Button
                      if (!_isProcessing && _capturedImage != null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _capturedImage = null;
                                    _statusMessage = 'Position your face in the frame';
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF15803D),
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF22C55E),
                                    width: 2,
                                  ),
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF22C55E).withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _verifyFace,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text(
                                    'Verify',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

