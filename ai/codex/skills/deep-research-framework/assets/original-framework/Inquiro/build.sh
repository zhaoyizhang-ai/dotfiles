#!/bin/bash
# build.sh — Run on your Mac to build and test Inquiro
# Usage: ./Inquiro/build.sh
set -euo pipefail

cd "$(dirname "$0")"

echo "=== Inquiro Build ==="
echo ""

# Step 1: Check environment
if [[ "$(uname)" != "Darwin" ]]; then
    echo "ERROR: This script must be run on macOS."
    exit 1
fi

if ! command -v swift &>/dev/null; then
    echo "ERROR: Swift not found. Install Xcode or Xcode Command Line Tools."
    exit 1
fi

SWIFT_VERSION=$(swift --version 2>&1 | head -1)
echo "Swift: $SWIFT_VERSION"
echo ""

# Step 2: Build (debug)
echo "--- Building (debug) ---"
swift build 2>&1
echo ""
echo "✅ Debug build succeeded"
echo ""

# Step 3: Run tests
echo "--- Running tests ---"
swift test 2>&1
echo ""
echo "✅ Tests passed"
echo ""

# Step 4: Build app bundle (if xcodegen available)
if command -v xcodegen &>/dev/null; then
    echo "--- Generating Xcode project ---"
    xcodegen generate 2>&1
    echo ""

    echo "--- Building .app bundle ---"
    xcodebuild -project Inquiro.xcodeproj \
        -scheme Inquiro \
        -configuration Debug \
        -derivedDataPath .build/xcode \
        build 2>&1 | tail -5
    echo ""

    APP_PATH=".build/xcode/Build/Products/Debug/Inquiro.app"
    if [ -d "$APP_PATH" ]; then
        echo "✅ App bundle built: $APP_PATH"
        echo ""
        echo "To run: open $APP_PATH"
    fi
else
    echo "--- Skipping .app bundle (xcodegen not installed) ---"
    echo "Install: brew install xcodegen"
    echo "Then re-run this script to build the full .app"
fi

echo ""
echo "=== Done ==="
