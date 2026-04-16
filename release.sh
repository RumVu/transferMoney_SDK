#!/bin/bash
# Release script for transferMoney SDK
# Usage: ./release.sh <version>
# Example: ./release.sh 0.0.5

set -e

if [ -z "$1" ]; then
    echo "Usage: ./release.sh <version>"
    echo "Example: ./release.sh 0.0.5"
    exit 1
fi

VERSION=$1
echo "📦 Releasing v$VERSION..."

# Update version in transferMoney_SDK.swift
echo "Updating version in source..."
sed -i '' "s/public static let version = \".*\"/public static let version = \"$VERSION\"/" \
    Sources/transferMoney_SDK/transferMoney_SDK.swift

# Update version in tests
echo "Updating version in tests..."
sed -i '' "s/XCTAssertEqual(TransferMoneySDK.version, \".*\")/XCTAssertEqual(TransferMoneySDK.version, \"$VERSION\")/" \
    Tests/transferMoney_SDKTests/transferMoney_SDKTests.swift
sed -i '' "s/XCTAssertEqual(result.sdkVersion, \".*\")/XCTAssertEqual(result.sdkVersion, \"$VERSION\")/" \
    Tests/transferMoney_SDKTests/transferMoney_SDKTests.swift

# Run tests
echo "Running tests..."
swift test

# Commit
echo "Committing changes..."
git add Sources/ Tests/
git commit -m "Release v$VERSION"

# Tag
echo "Creating tag v$VERSION..."
git tag "v$VERSION"

# Push
echo "Pushing to GitHub..."
git push origin main --tags

echo "✅ Release v$VERSION complete!"
echo "📝 Remember to create GitHub Release at: https://github.com/RumVu/transferMoney_SDK/releases/new?tag=v$VERSION"
