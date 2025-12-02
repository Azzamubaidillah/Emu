# Emu - Android Emulator Runner for macOS

**Emu** is a lightweight macOS application that allows you to list and launch your Android Virtual Devices (AVDs) and iOS Simulators directly from your menu bar or window.

## Features

- 🚀 **Fast Launch**: Quickly start your Android emulators and iOS simulators.
- 📋 **Side-by-Side View**: Clean split view to manage Android and iOS devices simultaneously.
- 📱 **iOS Support**: 
  - Lists iOS Simulators with OS version.
  - **Boot**, **Shutdown**, and **Erase Content & Settings** directly from the app.
- ⚙️ **Advanced Options (Android)**:
  - **Cold Boot**: Start the emulator from a cold state (`-no-snapshot-load`).
  - **Wipe Data**: Reset the emulator data (`-wipe-data`).
  - **No Boot Animation**: Disable the boot animation for faster startup (`-no-boot-anim`).
- 🛠 **Configurable**: Custom Android SDK path support.

## Requirements

- macOS
- Android SDK installed (usually via Android Studio)
- Xcode installed (for iOS Simulator support)
- **App Sandbox Disabled**: Due to the nature of launching external processes (`emulator` binary), this app requires the App Sandbox to be disabled to function correctly.

## Installation & Build

1.  Clone the repository:
    ```bash
    git clone https://github.com/Azzamubaidillah/Emu.git
    ```
2.  Open `Emu.xcodeproj` in Xcode.
3.  Ensure **App Sandbox** is disabled in the target's "Signing & Capabilities" tab.
4.  Build and Run (Cmd+R).

## Usage

1.  Launch **Emu**.
2.  The app will list your available AVDs.
3.  Click the **Play** button to launch an emulator.
4.  **Right-click** or click the arrow on the Play button to access advanced options like **Cold Boot** or **Wipe Data**.
5.  If your emulators aren't showing up, go to **Settings** (Cmd+,) and ensure the **Android SDK Path** is correct (Default: `~/Library/Android/sdk`).

## Troubleshooting

### "File not found" or Emulator not launching
Ensure that the **App Sandbox** is disabled in Xcode. The app needs permission to execute the `emulator` binary from your Android SDK, which is restricted by the default sandbox.

## License

MIT
