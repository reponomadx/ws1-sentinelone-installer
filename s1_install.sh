#!/bin/bash

# ------------------------------------------------------------------------------
# S1 Install
# ------------------------------------------------------------------------------
# This script checks if SentinelOne is installed and installs it from Munki
# cache if not. Intended for use with Workspace ONE UEM, running every 4 hours.
#
# REQUIREMENTS:
# - SentinelOne PKG must already be present in Munki Cache.
# - A registration token is placed in the same directory.
# - A managed local account with Downloads folder access must exist.
# - Workspace ONE UEM must inject the $password variable at runtime.
#
# NOTE:
# - Replace <Base64_SentinelOne_Token> with your actual registration token.
# - Replace Your_macOS_Service_Account with your managed local account.
# - Do NOT publish real tokens or passwords in public repositories.
# ------------------------------------------------------------------------------

# Set install path and cached PKG path
S1_INSTALL="/Applications/SentinelOne"
CACHE_DIR="/Library/Application Support/AirWatch/Data/Munki/Managed Installs/Cache"
S1_PKG="${CACHE_DIR}/Sentinel-Release-24-4-1-7830_macos_v24_4_1_7830-24.4.1.7830.pkg"
TOKEN_FILE="${CACHE_DIR}/com.sentinelone.registration-token"
TARGET_USER="Your_macOS_Service_Account"
USER_DL="/Users/${TARGET_USER}/Downloads"

# 1. Check if SentinelOne is already installed
if [ -d "$S1_INSTALL" ]; then
    echo "✅ SentinelOne is already installed."
    exit 0
fi

# 2. Check if the PKG exists
if [ ! -f "$S1_PKG" ]; then
    echo "⏳ PKG not found yet. Will try again in 4 hours."
    exit 1
fi

echo "📦 SentinelOne PKG found. Proceeding with installation in 5 seconds..."
sleep 5

# 3. Create the registration token file
echo "🔐 Writing registration token..."
echo "<Base64_SentinelOne_Token>" > "$TOKEN_FILE"

# 4. Copy payloads to local Downloads folder
echo "$password" | sudo -S cp "$TOKEN_FILE" "$USER_DL/"
echo "$password" | sudo -S cp "$S1_PKG" "$USER_DL/"

# 5. Run the installer
echo "🚀 Installing SentinelOne agent..."
echo "$password" | sudo -S /usr/sbin/installer -pkg "$USER_DL/$(basename "$S1_PKG")" -target /

# 6. Cleanup
echo "🧹 Cleaning up..."
echo "$password" | sudo -S rm "$USER_DL/$(basename "$S1_PKG")"
echo "$password" | sudo -S rm "$USER_DL/$(basename "$TOKEN_FILE")"

echo "✅ SentinelOne installation complete."
exit 0
