#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PBXPROJ="$ROOT_DIR/DemoMafia.xcodeproj/project.pbxproj"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

check_no_details_export_in_compile_root() {
  if [ -d "$ROOT_DIR/DemoMafia/MafiaUI_SwiftFiles" ]; then
    fail "Found MafiaUI_SwiftFiles under active compile root (DemoMafia/)"
  fi
}

check_no_detailspro_in_compile_root() {
  if find "$ROOT_DIR/DemoMafia" -type f -name '*.detailspro' -print -quit | grep -q .; then
    fail "Found .detailspro file under active compile root (DemoMafia/)"
  fi
}

check_has_ios_target_support() {
  if ! rg -n 'SUPPORTED_PLATFORMS = "iphoneos iphonesimulator";' "$PBXPROJ" >/dev/null 2>&1; then
    fail "No iOS-supported target found in project.pbxproj"
  fi
}

check_no_conners_runtime_folders_at_root() {
  if [ -d "$ROOT_DIR/Conners Mafia IOS" ] || [ -d "$ROOT_DIR/Conners Mafia IOSTests" ] || [ -d "$ROOT_DIR/Conners Mafia IOSUITests" ]; then
    fail "Found legacy Conners folders at repo root; expected archive location"
  fi
}

check_no_details_export_in_compile_root
check_no_detailspro_in_compile_root
check_has_ios_target_support
check_no_conners_runtime_folders_at_root

echo "[PASS] Structure checks passed"
