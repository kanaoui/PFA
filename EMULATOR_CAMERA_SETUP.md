# Fix: Camera Showing Virtual Scene Instead of Your Face

If you're seeing a pixelated green character (like a Minecraft Creeper) instead of your face, the emulator is using a virtual camera. Here's how to fix it:

## Quick Fix: Enable Real Camera in Emulator

### Step 1: Open Extended Controls
1. In your Android Emulator, look for the **three dots (⋮)** button on the right sidebar
2. Click it to open **Extended Controls**

### Step 2: Configure Camera
1. In the Extended Controls menu, click **Camera** (or find it in the list)
2. You'll see two camera options:
   - **Front Camera**
   - **Back Camera**

3. For **Front Camera**, change from:
   - `VirtualScene` (shows the green character) 
   - **TO:** `Webcam0` (uses your computer's webcam)

4. For **Back Camera**, you can also set it to `Webcam0` if needed

5. Click **OK** to save

### Step 3: Restart the App
1. Close the AgroSense app completely
2. Reopen it
3. Try face recognition again - you should now see your actual face!

## Alternative: If Webcam0 Doesn't Work

If `Webcam0` doesn't appear or doesn't work:

1. **Check your webcam:**
   - Make sure your webcam is not being used by another app
   - Try opening the Camera app on your computer to test

2. **Try different webcam options:**
   - In Extended Controls > Camera
   - Look for other webcam options like `Webcam1`, `Integrated Camera`, etc.
   - Try each one until you see your face

3. **Restart the emulator:**
   - Close the emulator completely
   - Reopen it
   - Configure camera again

## For VS Code Users

After configuring the camera:

1. **Hot restart the app:**
   - Press `r` in the terminal where Flutter is running
   - OR click the restart button in VS Code

2. **If that doesn't work, full restart:**
   ```bash
   # Stop the app (Ctrl+C in terminal)
   # Then run again
   flutter run
   ```

## Verify Camera is Working

1. **Test in emulator's Camera app:**
   - Open the Camera app on the emulator
   - If you see your face there, the camera is configured correctly
   - If you still see the green character, the camera needs to be reconfigured

2. **Check camera permissions:**
   - Settings > Apps > AgroSense > Permissions
   - Make sure Camera is enabled

## Troubleshooting

### Still seeing the green character?

1. **Make sure no other app is using the webcam:**
   - Close Zoom, Teams, Skype, or any video apps
   - Close other camera apps

2. **Check Windows Camera Privacy Settings:**
   - Windows Settings > Privacy > Camera
   - Make sure "Allow apps to access your camera" is ON
   - Make sure "Allow desktop apps to access your camera" is ON

3. **Try a different emulator:**
   - If using Android Studio emulator, try creating a new AVD
   - Make sure it has camera support enabled

4. **Check emulator settings:**
   - When creating/editing the AVD, make sure:
     - Front Camera: Webcam0
     - Back Camera: Webcam0 (or VirtualScene if you don't need it)

### Camera shows black screen?

1. **Grant camera permission** (see CAMERA_PERMISSION_GUIDE.md)
2. **Check if webcam works in other apps** (like Windows Camera app)
3. **Restart the emulator**

### No camera option in Extended Controls?

1. **Update Android Emulator** to the latest version
2. **Check AVD configuration:**
   - Android Studio > Tools > Device Manager
   - Edit your AVD
   - Show Advanced Settings
   - Check Camera settings

## Quick Summary

**The Problem:** Emulator is using VirtualScene (green character) instead of real camera

**The Solution:** 
1. Extended Controls (⋮) > Camera
2. Change Front Camera from `VirtualScene` to `Webcam0`
3. Click OK
4. Restart app

That's it! You should now see your actual face instead of the green character.

