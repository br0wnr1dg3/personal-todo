#!/bin/bash
# Build and bundle PersonalTodo as a macOS .app
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "Building..."
swift build -c release

APP_DIR="$SCRIPT_DIR/build/PersonalTodo.app/Contents/MacOS"
mkdir -p "$APP_DIR"

# Copy binary
cp .build/release/PersonalTodo "$APP_DIR/PersonalTodo"

# Copy Info.plist
cp Sources/Info.plist "$SCRIPT_DIR/build/PersonalTodo.app/Contents/Info.plist"

echo "Built: $SCRIPT_DIR/build/PersonalTodo.app"
echo ""
echo "To install to Applications:"
echo "  cp -r build/PersonalTodo.app /Applications/"
echo ""
echo "To run now:"
echo "  open build/PersonalTodo.app"
