#!/bin/bash
# ==============================================================
# Build script: transferMoney_SDK → XCFramework
# Chạy: chmod +x build_xcframework.sh && ./build_xcframework.sh
# ==============================================================

set -e  # dừng ngay nếu có lỗi

SCHEME="transferMoney_SDK"
FRAMEWORK_NAME="transferMoney_SDK"
BUILD_DIR=".build/xcframework_build"
OUTPUT="$FRAMEWORK_NAME.xcframework"

echo "→ Dọn build cũ..."
rm -rf "$BUILD_DIR" "$OUTPUT"
mkdir -p "$BUILD_DIR"

# ── 1. Build cho iOS device (arm64) ────────────────────────────
echo "→ Build iOS device..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -archivePath "$BUILD_DIR/ios-device" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# ── 2. Build cho iOS Simulator (arm64 + x86_64) ────────────────
echo "→ Build iOS Simulator..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios-simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# ── 3. Đóng gói thành XCFramework ──────────────────────────────
echo "→ Tạo XCFramework..."
xcodebuild -create-xcframework \
  -framework "$BUILD_DIR/ios-device.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -framework "$BUILD_DIR/ios-simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework" \
  -output "$OUTPUT"

echo ""
echo "✓ Xong! File output: $OUTPUT"
echo "  Giao file này cho dev — họ sẽ không thấy source code bên trong."
