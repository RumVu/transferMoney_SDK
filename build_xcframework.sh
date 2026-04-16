#!/bin/bash
# ==============================================================
# Build script: transferMoney_SDK → XCFramework
# Chạy: chmod +x build_xcframework.sh && ./build_xcframework.sh
# ==============================================================

set -e

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
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  INSTALL_PATH="/Library/Frameworks" \
  2>&1 | grep -E "error:|Build succeeded|FAILED" || true

# ── 2. Build cho iOS Simulator ─────────────────────────────────
echo "→ Build iOS Simulator..."
xcodebuild archive \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "$BUILD_DIR/ios-simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  INSTALL_PATH="/Library/Frameworks" \
  2>&1 | grep -E "error:|Build succeeded|FAILED" || true

# ── Kiểm tra output tồn tại ────────────────────────────────────
DEVICE_FW="$BUILD_DIR/ios-device.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"
SIM_FW="$BUILD_DIR/ios-simulator.xcarchive/Products/Library/Frameworks/$FRAMEWORK_NAME.framework"

# Fallback path nếu INSTALL_PATH đẩy vào thư mục khác
if [ ! -d "$DEVICE_FW" ]; then
  DEVICE_FW=$(find "$BUILD_DIR/ios-device.xcarchive" -name "$FRAMEWORK_NAME.framework" -type d | head -1)
fi
if [ ! -d "$SIM_FW" ]; then
  SIM_FW=$(find "$BUILD_DIR/ios-simulator.xcarchive" -name "$FRAMEWORK_NAME.framework" -type d | head -1)
fi

if [ ! -d "$DEVICE_FW" ]; then
  echo "❌ Không tìm thấy: $DEVICE_FW"
  exit 1
fi
if [ ! -d "$SIM_FW" ]; then
  echo "❌ Không tìm thấy: $SIM_FW"
  exit 1
fi

# ── 3. Đóng gói thành XCFramework ──────────────────────────────
echo "→ Tạo XCFramework..."
xcodebuild -create-xcframework \
  -framework "$DEVICE_FW" \
  -framework "$SIM_FW" \
  -output "$OUTPUT"

echo ""
echo "✓ Xong! File output: $(pwd)/$OUTPUT"
echo "  Giao file này cho dev — họ sẽ không thấy source code bên trong."
