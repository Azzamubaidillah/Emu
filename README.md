# Emu - Android Emulator Runner for macOS

**Emu** is a lightweight macOS application that allows you to list and launch your Android Virtual Devices (AVDs) directly from your menu bar or window, without needing to open Android Studio.

## Features

- 🚀 **Fast Launch**: Quickly start your Android emulators.
- 📋 **List AVDs**: Automatically detects and lists all available AVDs from your Android SDK.
- ⚙️ **Advanced Options**:
  - **Cold Boot**: Start the emulator from a cold state (`-no-snapshot-load`).
  - **Wipe Data**: Reset the emulator data (`-wipe-data`).
  - **No Boot Animation**: Disable the boot animation for faster startup (`-no-boot-anim`).
- 🛠 **Configurable**: Custom Android SDK path support.

## Requirements

- macOS
- Android SDK installed (usually via Android Studio)
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
