# Troubleshooting Connection Timeout

## Quick Fix Checklist

### ✅ Step 1: Verify Python Service is Running

1. **Open a terminal/command prompt** in your project root
2. **Run the service:**
   ```bash
   python face_recognition_service.py
   ```

3. **You should see:**
   ```
   Starting Face Recognition Service...
   Model loaded successfully!
    * Running on http://0.0.0.0:8001
   ```

4. **If you see errors**, check:
   - Is Python installed? (`python --version`)
   - Are dependencies installed? (`pip install -r requirements_face_recognition.txt`)
   - Does the model file exist? (`FaceRecognition/siamesemodelv2.h5`)

### ✅ Step 2: Test Service is Accessible

**From your PC (not emulator):**
1. Open a web browser
2. Go to: `http://localhost:8001/health`
3. You should see: `{"status": "ok", "service": "face_recognition"}`

**If this doesn't work:**
- The service isn't running properly
- Check the terminal for error messages
- Make sure port 8001 isn't being used by another app

### ✅ Step 3: Check Emulator Connection

The app uses `http://10.0.2.2:8001` to connect from Android emulator to your PC.

**Verify the URL is correct:**
- Open `lib/services/face_recognition_service.dart`
- Line 9 should be: `static const String _baseUrl = 'http://10.0.2.2:8001';`

### ✅ Step 4: Common Issues & Solutions

#### Issue: "Connection timeout"
**Causes:**
- Python service not running
- Firewall blocking port 8001
- Wrong URL in Flutter app

**Solutions:**
1. Make sure Python service is running (see Step 1)
2. Check Windows Firewall:
   - Windows Settings → Privacy & Security → Windows Security → Firewall
   - Allow Python through firewall if prompted
3. Verify URL in `face_recognition_service.dart`

#### Issue: "Connection refused"
**Causes:**
- Service crashed
- Port already in use
- Service not started

**Solutions:**
1. Restart the Python service
2. Check if another app is using port 8001:
   ```bash
   netstat -ano | findstr :8001
   ```
3. If port is in use, change port in `face_recognition_service.py` (last line)

#### Issue: Service starts but model doesn't load
**Check:**
- Model file exists: `FaceRecognition/siamesemodelv2.h5`
- Model path is correct in `face_recognition_service.py` (line 20)
- You have enough RAM (TensorFlow models can be large)

### ✅ Step 5: Test with Simple Request

**Test the service manually:**

1. **Keep Python service running**
2. **Open another terminal**
3. **Test with curl (if available):**
   ```bash
   curl http://localhost:8001/health
   ```
   Should return: `{"status": "ok", "service": "face_recognition"}`

4. **Or test in Python:**
   ```python
   import requests
   response = requests.get('http://localhost:8001/health')
   print(response.json())
   ```

### ✅ Step 6: Check Service Logs

When you run the Python service, watch for:
- ✅ "Model loaded successfully!" - Good!
- ✅ "Running on http://0.0.0.0:8001" - Good!
- ❌ Any error messages - These tell you what's wrong

**Common errors:**
- `FileNotFoundError` → Model file missing
- `ModuleNotFoundError` → Missing Python packages
- `Address already in use` → Port 8001 taken by another app

## Quick Test Procedure

1. **Terminal 1:** Start Python service
   ```bash
   python face_recognition_service.py
   ```

2. **Browser:** Test health endpoint
   ```
   http://localhost:8001/health
   ```

3. **App:** Try face recognition
   - Should connect successfully
   - If timeout, check firewall

## Still Not Working?

### Alternative: Use Physical Device

If emulator connection keeps failing:

1. **Find your PC's IP address:**
   - Windows: `ipconfig` → Look for IPv4 Address
   - Example: `192.168.1.100`

2. **Update Flutter service:**
   - In `lib/services/face_recognition_service.dart`
   - Change to: `static const String _baseUrl = 'http://192.168.1.100:8001';`

3. **Connect phone and PC to same WiFi network**

4. **Test on physical device**

### Check Python Service Code

If the service crashes immediately:

1. **Run with verbose output:**
   ```bash
   python -u face_recognition_service.py
   ```

2. **Check for import errors:**
   ```bash
   python -c "import flask, cv2, numpy, tensorflow; print('All imports OK')"
   ```

3. **Test model loading:**
   ```python
   import tensorflow as tf
   model = tf.keras.models.load_model('FaceRecognition/siamesemodelv2.h5')
   print('Model loaded!')
   ```

## Summary

**Most Common Fix:**
1. Make sure Python service is running
2. Test `http://localhost:8001/health` in browser
3. If that works, the issue is emulator connection
4. Check firewall settings
5. Verify URL is `http://10.0.2.2:8001` in Flutter code

The service MUST be running before you use the app!

