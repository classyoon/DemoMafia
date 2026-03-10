#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PBXPROJ="$ROOT_DIR/DemoMafia.xcodeproj/project.pbxproj"
APPICON_DIR="$ROOT_DIR/DemoMafia/Assets.xcassets/AppIcon.appiconset"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

require_match() {
  local pattern="$1"
  local file="$2"
  local label="$3"
  if ! rg -q "$pattern" "$file"; then
    fail "Missing $label"
  fi
}

if [ ! -f "$PBXPROJ" ]; then
  fail "Missing project file: $PBXPROJ"
fi

if [ ! -d "$APPICON_DIR" ]; then
  fail "Missing app icon catalog: $APPICON_DIR"
fi

require_match 'IPHONEOS_DEPLOYMENT_TARGET = 16\.0;' "$PBXPROJ" "iOS 16 deployment target"
require_match 'INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO;' "$PBXPROJ" "ITSAppUsesNonExemptEncryption=NO"
require_match 'PRODUCT_BUNDLE_IDENTIFIER = com\.conner\.yoon\.mafiaparty\.ios;' "$PBXPROJ" "iOS bundle identifier"
require_match 'INFOPLIST_KEY_CFBundleDisplayName = "Mafia Party";' "$PBXPROJ" "display name"

if rg -q '#Preview' "$ROOT_DIR/DemoMafia" -g '*.swift'; then
  fail "Found #Preview macro in runtime Swift files (use PreviewProvider for CLI reliability)"
fi

for icon in \
  AppIcon-iOS-1024.png \
  AppIcon-iOS-1024-dark.png \
  AppIcon-iOS-1024-tinted.png \
  AppIcon-mac-16x16@1x.png \
  AppIcon-mac-16x16@2x.png \
  AppIcon-mac-32x32@1x.png \
  AppIcon-mac-32x32@2x.png \
  AppIcon-mac-128x128@1x.png \
  AppIcon-mac-128x128@2x.png \
  AppIcon-mac-256x256@1x.png \
  AppIcon-mac-256x256@2x.png \
  AppIcon-mac-512x512@1x.png \
  AppIcon-mac-512x512@2x.png
do
  if [ ! -f "$APPICON_DIR/$icon" ]; then
    fail "Missing app icon image: $icon"
  fi
done

pass "App Store readiness checks passed"
