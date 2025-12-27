# Configure Android Emulator to Use PC Webcam

This guide will help you configure the Android emulator to use your PC's real webcam instead of the virtual camera.

## Method 1: Configure via Extended Controls (Quick Fix)

### Step-by-Step:

1. **Open Extended Controls**
   - In your Android Emulator, look for the **three vertical dots (⋮)** on the right sidebar
   - Click it to open the Extended Controls panel

2. **Navigate to Camera Settings**
   - In the left menu, click **Camera** (or find it in the list)
   - You'll see two sections:
     - **Front Camera**
     - **Back Camera**

3. **Configure Front Camera**
   - Click the dropdown next to **Front Camera**
   - Change from `VirtualScene` to `Webcam0`
   - If `Webcam0` doesn't work, try:
     - `Integrated Camera`
     - `USB Video Device`
     - Any option that mentions your webcam

4. **Configure Back Camera (Optional)**
   - Set it to `Webcam0` as well, or leave as `VirtualScene`

5. **Save Settings**
   - Click **OK** or **Close** to save

6. **Restart the App**
   - Close AgroSense completely
   - Reopen it
   - Try face recognition again

## Method 2: Configure During AVD Creation/Edit

If Method 1 doesn't work, configure it when creating or editing the AVD:

1. **Open Android Studio**
   - Go to **Tools** → **Device Manager** (or **AVD Manager**)

2. **Edit Your AVD**
   - Find your emulator in the list
   - Click the **pencil icon** (Edit) next to it

3. **Show Advanced Settings**
   - Scroll down and click **Show Advanced Settings**

4. **Configure Cameras**
   - Find **Front Camera** dropdown
   - Select **Webcam0** (or your webcam name)
   - Find **Back Camera** dropdown
   - Select **Webcam0** or **VirtualScene**

5. **Finish**
   - Click **Finish** to save
   - **Cold Boot** the emulator (restart it completely)

## Method 3: Check Windows Camera Access

Sometimes Windows blocks the emulator from accessing the camera:

1. **Open Windows Settings**
   - Press `Win + I`
   - Go to **Privacy & Security** → **Camera**

2. **Enable Camera Access**
   - Turn ON **"Let apps access your camera"**
   - Turn ON **"Let desktop apps access your camera"** (important!)

3. **Check App Permissions**
   - Scroll down to see which apps have camera access
   - Make sure Android Studio/Emulator is allowed

4. **Restart Emulator**
   - Close and reopen the emulator

## Method 4: Verify Webcam is Available

1. **Test Webcam in Windows**
   - Open **Camera** app on Windows
   - If it works, your webcam is fine
   - If not, check webcam drivers

2. **Check if Webcam is Being Used**
   - Close all apps that might use the camera:
     - Zoom, Teams, Skype
     - Other video conferencing apps
     - Other camera apps

3. **Check Device Manager**
   - Press `Win + X` → **Device Manager**
   - Look under **Cameras** or **Imaging devices**
   - Make sure your webcam appears and has no errors (yellow triangle)

## Method 5: Command Line Configuration

If you prefer command line:

1. **List available cameras:**
   ```bash
   adb shell "ls /dev/video*"
   ```

2. **Check emulator camera settings:**
   ```bash
   adb shell getprop ro.kernel.qemu.camera
   ```

3. **Set camera via command (if supported):**
   ```bash
   emulator -avd YourAVDName -camera-front webcam0
   ```

## Troubleshooting

### Webcam0 Not Available?

1. **Check if webcam is detected:**
   - Open Device Manager
   - Look for your camera under "Cameras" or "Imaging devices"
   - If missing, update drivers

2. **Try different camera names:**
   - In Extended Controls > Camera
   - Try all available options one by one
   - Common names: `Webcam0`, `Integrated Camera`, `USB Video Device`

3. **Restart everything:**
   - Close emulator
   - Close Android Studio/VS Code
   - Restart computer (sometimes needed)
   - Reopen and try again

### Camera Shows Black Screen?

1. **Grant camera permission to the app** (already done, but verify)
2. **Check if another app is using the camera**
3. **Try restarting the emulator with cold boot**

### Still Shows Virtual Scene?

1. **Make sure you clicked OK after changing settings**
2. **Cold boot the emulator:**
   - Close emulator completely
   - In AVD Manager, click the dropdown arrow next to your AVD
   - Select **Cold Boot Now**

3. **Verify settings were saved:**
   - Open Extended Controls > Camera again
   - Make sure it still shows `Webcam0`

## Quick Checklist

- [ ] Extended Controls > Camera > Front Camera = `Webcam0`
- [ ] Clicked OK to save settings
- [ ] Windows Camera Privacy: Desktop apps allowed
- [ ] No other app using webcam
- [ ] Emulator restarted (cold boot if needed)
- [ ] App restarted
- [ ] Tested camera in emulator's Camera app first

## Verify It's Working

**Before testing in AgroSense:**

1. Open the **Camera app** on the emulator
2. If you see your real face → Camera is configured correctly ✅
3. If you see green character → Still using VirtualScene ❌

**Then test AgroSense:**
- Navigate to Face Authentication
- Tap "Capture Face"
- You should see your real face in the camera preview

## Still Not Working?

If none of the above works:

1. **Update Android Emulator:**
   - Android Studio > Help > Check for Updates
   - Update Emulator to latest version

2. **Create New AVD:**
   - Create a fresh emulator
   - Configure camera during creation
   - Test with new AVD

3. **Check Emulator Logs:**
   - Extended Controls > Settings > Logcat
   - Look for camera-related errors

4. **Alternative: Use Physical Device:**
   - Connect your Android phone via USB
   - Enable USB debugging
   - Run app on physical device (camera will definitely work)

