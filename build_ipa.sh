#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "=== Cleaning previous build ==="
rm -rf build 2>/dev/null || true

echo "=== Building project ==="
xcodebuild -scheme BoltStrike \
    -configuration Browserstack \
    -sdk iphoneos \
    -derivedDataPath build \
    -project BoltStrike.xcodeproj \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    ONLY_ACTIVE_ARCH=NO

echo "=== Creating IPA ==="
APP_PATH="build/Build/Products/Browserstack-iphoneos/BoltStrike.app"

if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found"
    exit 1
fi

mkdir -p build/Payload
cp -r "$APP_PATH" build/Payload/
cd build
zip -r BoltStrike.ipa Payload

echo "=== Done! ==="
echo "IPA: $PROJECT_DIR/build/BoltStrike.ipa"
