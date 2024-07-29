#!/bin/bash
# Flytrap Version 0.1
# Function to display a banner with light blue text
display_banner() {
    # Clear the console screen
    clear
    
    # Define colors
    LIGHT_BLUE='\033[1;34m'
    RESET='\033[0m'
    
    # Display the banner
    # I made this for my Motorola Razr, because when it updated to Android 14, I couldnt easily install old apps.
    # I went with Flytrap because of the Venus Flytrap, and theres also a razor called Venus, by Gillette. my dumbass thought phillips made it
    echo -e "${LIGHT_BLUE}"
    echo "============================================"
    echo "        Flytrap (Android 14 Edition)        "
    echo "============================================"
    echo -e "${RESET}The (semi) automatic APK installer! Hit enter to continue."
}

# Function to print an error message and exit
print_error_and_exit() {
    local message="$1"
    echo -e "\e[31mError: $message\e[0m"  # Print error message in red
    exit 1
}

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -C, --compat       Install with compatibility mode (bypass low target SDK block)"
    echo "  -h, --help         Display this help message"
    exit 0
}

# Default values
COMPAT=false

# Parse command line arguments
while [[ "$1" != "" ]]; do
    case $1 in
        -C | --compat )        COMPAT=true
                               ;;
        -h | --help )          display_help
                               ;;
        * )                    print_error_and_exit "Invalid option: $1"
                               ;;
    esac
    shift
done

# Display the banner
display_banner

# Wait for user to hit enter
read -p ""

# Check if zenity is installed
if ! command -v zenity &> /dev/null
then
    print_error_and_exit "Zenity is not installed. Please install it using your package manager."
fi

# Display file selection dialog and store the selected file paths
APK_PATHS=$(zenity --file-selection --multiple --file-filter="*.apk" --title="Select APK Files" --separator=" ")

# Check if files were selected
if [ -z "$APK_PATHS" ]; then
    echo "No files selected. Exiting."
    exit 1
fi

# Check if adb is installed
if ! command -v adb &> /dev/null
then
    print_error_and_exit "adb is not installed. Please install it using your package manager."
fi

# Split the selected files into an array
IFS=' ' read -r -a APK_ARRAY <<< "$APK_PATHS"

# Install each APK file
for APK_PATH in "${APK_ARRAY[@]}"; do
    APK_NAME=$(basename "$APK_PATH")
    echo "Installing $APK_NAME..."

    if [ "$COMPAT" = true ]; then
        adb install --bypass-low-target-sdk-block "$APK_PATH"
    else
        adb install "$APK_PATH"
    fi

    # Check the result of adb install and display appropriate message
    if [ $? -eq 0 ]; then
        echo "$APK_NAME installed successfully."
    else
        echo "Failed to install $APK_NAME."
    fi
    
    # Add a line break after each installation
    echo ""
done

# Exit the script
exit 0

