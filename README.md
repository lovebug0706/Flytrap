# Flytrap
A semi-automatic APK installer for Android.

This script requires the following software:

1. **adb**: Android Debug Bridge
   - Install using your package manager. For Arch Linux, run:
     ```bash
     sudo pacman -S android-tools
     ```

2. **zenity**: GUI dialog tool
   - Install using your package manager. For Arch Linux, run:
     ```bash
     sudo pacman -S zenity
     ```

## Usage

Run the script to install APKs:
```bash
./Flytrap.sh [FLAGS]
```

## Flags

**-h | --help**: Shows the supported flags.

**-c | --compat**: Allows older apps to be installed on Android 14 and higher.
