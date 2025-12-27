# How to Start the Face Recognition Service

## Quick Start

1. **Open a terminal/command prompt** in your project root directory

2. **Make sure Python is installed:**
   ```bash
   python --version
   ```
   Should show Python 3.8 or higher

3. **Install dependencies (if not already done):**
   ```bash
   pip install -r requirements_face_recognition.txt
   ```

4. **Start the service:**
   ```bash
   python face_recognition_service.py
   ```

5. **You should see:**
   ```
   Starting Face Recognition Service...
   Model loaded successfully!
    * Running on http://0.0.0.0:8001
   ```

6. **Keep this terminal open** - the service must be running for face recognition to work

## Important Notes

- **The service must be running** before you try to use face recognition in the app
- **Don't close the terminal** while using the app
- The service runs on **port 8001**
- For Android emulator, the app connects to `http://10.0.2.2:8001`
- For physical device, update the URL in `face_recognition_service.dart` to your PC's IP

## Troubleshooting

### "Connection refused" error?
- Make sure the Python service is running
- Check that port 8001 is not being used by another app
- Verify the URL in `face_recognition_service.dart` matches your setup

### "Model not found" error?
- Make sure `FaceRecognition/siamesemodelv2.h5` exists
- Check the path in `face_recognition_service.py` (line 20)

### Port already in use?
- Change port in `face_recognition_service.py` (last line)
- Update the URL in `face_recognition_service.dart` to match

