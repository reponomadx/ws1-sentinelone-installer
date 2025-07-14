#!/bin/bash

# ------------------------------------------------------------------------------
# S1 Upgrade
# ------------------------------------------------------------------------------
# This script checks the currently installed SentinelOne version on macOS and
# upgrades it using a pre-staged PKG file if it is out of date.
#
# REQUIREMENTS:
# - SentinelOne PKG must already be present in Munki Cache
# - Workspace ONE UEM must inject the $password variable at runtime
# - A managed local macOS account must exist for upgrade staging
# ------------------------------------------------------------------------------

# Configuration
CACHE_DIR="/Library/Application Support/AirWatch/Data/Munki/Managed Installs/Cache"
PKG_NAME="Your_SentinelOne-PKG.pkg"
S1_PKG="${CACHE_DIR}/${PKG_NAME}"
TARGET_USER="Your_macOS_Service_Account"
USER_DL="/Users/${TARGET_USER}/Downloads"
EXPECTED_VERSION="24.4.1.7830" #SentinelOne version being updated to

# Function to run sudo commands using the password injected by WS1
run_as_sudo() {
  echo "$password" | sudo -S "$@"
}

# 1. Verify PKG is available before proceeding
if [ ! -f "$S1_PKG" ]; then
  echo "⏳ SentinelOne PKG not yet available. Will retry later."
  exit 1
else
  echo "📦 PKG found. Checking installed version..."
fi

# 2. Get installed version
s1_current_output=$(run_as_sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl version 2>/dev/null)
s1_installed_version="${s1_current_output:12}"

# 3. Compare version and upgrade if needed
if [ "$s1_installed_version" != "$EXPECTED_VERSION" ]; then
  echo "⚠️ SentinelOne is out of date (v$s1_installed_version). Updating in 5 seconds..."
  sleep 5

  # Copy PKG to Downloads folder
  run_as_sudo cp "$S1_PKG" "$USER_DL/"

  # Upgrade SentinelOne using CLI
  run_as_sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl upgrade-pkg "$USER_DL/$PKG_NAME"

  # Clean up
  run_as_sudo rm "$USER_DL/$PKG_NAME"

  # Confirm updated version
  new_version=$(run_as_sudo /Library/Sentinel/sentinel-agent.bundle/Contents/MacOS/sentinelctl version)
  echo "✅ SentinelOne upgrade complete. Now running: ${new_version:12}"

else
  echo "✅ SentinelOne is up to date (v$s1_installed_version)."

  # Optional: remove PKG if still present
  run_as_sudo rm -f "$USER_DL/$PKG_NAME"
  exit 0
fi
