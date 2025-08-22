#!/usr/bin/env bash
set -euo pipefail

# -----------------------------
# Paths
# -----------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."
BUILD_DIR="$PROJECT_ROOT/build"
INCLUDE_DIR="$PROJECT_ROOT/include"  # separate headers folder
CRATE_NAME="rust_core"
XCFRAMEWORK_NAME="RustCore.xcframework"

# Ensure build dir exists
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$INCLUDE_DIR"

# -----------------------------
# Set Protobuf compiler
# -----------------------------
export PROTOC=$(which protoc)

# -----------------------------
# Clean previous builds
# -----------------------------
cargo clean

# -----------------------------
# Build Rust library slices
# -----------------------------
TARGETS=(
  "aarch64-apple-darwin"
)

for TARGET in "${TARGETS[@]}"; do
    echo "🔨 Building $CRATE_NAME for $TARGET..."
    cargo build --release --target "$TARGET"
done

# -----------------------------
# Generate C header for Swift
# -----------------------------
echo "📄 Generating C header via cbindgen..."
cbindgen --crate "$CRATE_NAME" --output "$INCLUDE_DIR/rust_core.h"

# -----------------------------
# Create XCFramework
# -----------------------------
echo "📦 Creating XCFramework..."
xcodebuild -create-xcframework \
  -library "$PROJECT_ROOT/target/aarch64-apple-darwin/release/lib${CRATE_NAME}.a" \
  -headers "$INCLUDE_DIR" \
  -output "$BUILD_DIR/$XCFRAMEWORK_NAME"

echo "✅ XCFramework built successfully at $BUILD_DIR/$XCFRAMEWORK_NAME"
