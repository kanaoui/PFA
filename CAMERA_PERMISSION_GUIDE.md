# Camera Permission Guide for Android Emulator

This guide will help you grant camera permissions for the AgroSense app on Android emulator.

## Method 1: Grant Permission via App Settings (Recommended)

1. **Open Settings on the Emulator**
   - Swipe down from the top to open the notification panel
   - Tap the gear icon (⚙️) to open Settings
   - OR go to Apps > AgroSense

2. **Navigate to App Permissions**
   - Go to **Apps** or **App Management**
   - Find and tap **AgroSense**
   - Tap **Permissions**

3. **Enable Camera Permission**
   - Find **Camera** in the permissions list
   - Tap it and select **Allow** or toggle it ON

4. **Restart the App**
   - Close the app completely
   - Reopen AgroSense
   - Try using face recognition again

## Method 2: Grant Permission When Prompted

1. **Run the App**
   - Launch AgroSense
   - Navigate to Face Authentication screen

2. **Permission Dialog**
   - When you tap "Capture Face", Android will show a permission dialog
   - Tap **Allow** or **While using the app**

3. **If Dialog Doesn't Appear**
   - The permission might be permanently denied
   - Follow Method 1 to enable it manually

## Method 3: Using ADB Commands (For Developers)

If you're comfortable with command line:

1. **Open Terminal/Command Prompt**
2. **Find your emulator device:**
   ```bash
   adb devices
   ```
3. **Grant camera permission:**
   ```bash
   adb shell pm grant com.example.agrosense android.permission.CAMERA
   ```
   (Replace `com.example.agrosense` with your actual package name)

## Method 4: Reset App Permissions

If permissions are stuck:

1. **Go to Settings > Apps > AgroSense**
2. **Tap Storage**
3. **Tap Clear Data** (this will reset the app)
4. **Reopen the app** and grant permissions when prompted

## Troubleshooting

### Permission Still Not Working?

1. **Check Android Version**
   - Android 6.0+ requires runtime permissions
   - Older versions might need different handling

2. **Verify Manifest**
   - Ensure `AndroidManifest.xml` has:
     ```xml
     <uses-permission android:name="android.permission.CAMERA"/>
     ```

3. **Check Emulator Camera**
   - Some emulators don't have camera support
   - Go to **Extended Controls** (three dots) > **Camera**
   - Set **Front Camera** to **Webcam0** or **VirtualScene**

4. **Restart Emulator**
   - Sometimes a simple restart fixes permission issues
   - Close and reopen the emulator

### Emulator Camera Setup

1. **Open Extended Controls** (three dots menu in emulator toolbar)
2. **Go to Camera**
3. **Set Front Camera** to:
   - **Webcam0** (uses your computer's webcam)
   - **VirtualScene** (virtual camera for testing)
4. **Set Back Camera** similarly
5. **Click OK**

### Testing Camera Access

1. Open the camera app on the emulator
2. If it works, the hardware is fine
3. If not, check emulator camera settings

## Quick Fix Checklist

- [ ] Camera permission added to AndroidManifest.xml ✅ (Already done)
- [ ] App restarted after permission grant
- [ ] Emulator camera is enabled and configured
- [ ] Permission granted in Settings > Apps > AgroSense > Permissions
- [ ] App has been reinstalled (if needed)

## For VS Code Users

After making changes to `AndroidManifest.xml`:

1. **Stop the app** (if running)
2. **Clean build:**
   ```bash
   flutter clean
   flutter pub get
   ```
3. **Rebuild and run:**
   ```bash
   flutter run
   ```

The permission should now be requested automatically when you try to use the camera!

