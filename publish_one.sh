#!/bin/bash
# publish_one.sh - Helper script to publish a single package

set -e

if [ -z "$1" ]; then
    echo "Usage: ./publish_one.sh <package-name>"
    echo ""
    echo "Example: ./publish_one.sh exai"
    echo ""
    echo "Available packages:"
    ls -1 packages/ | grep -v "^$"
    exit 1
fi

PACKAGE_NAME=$1
PACKAGE_DIR="packages/$PACKAGE_NAME"

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "❌ Error: Package directory '$PACKAGE_DIR' not found"
    exit 1
fi

echo "🚀 Publishing $PACKAGE_NAME to PyPI"
echo "======================================"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ Error: uv is not installed"
    exit 1
fi

# Check if token is set
if [ -z "$UV_PUBLISH_TOKEN" ]; then
    echo "⚠️  Warning: UV_PUBLISH_TOKEN not set"
    echo "Set it with: export UV_PUBLISH_TOKEN=\"pypi-YOUR_TOKEN\""
    echo ""
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

cd "$PACKAGE_DIR"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info/

# Build and publish
echo "🔨 Building and publishing..."
if [ -z "$UV_PUBLISH_TOKEN" ]; then
    uv publish
else
    uv publish --token "$UV_PUBLISH_TOKEN"
fi

echo ""
echo "✅ Successfully published $PACKAGE_NAME!"
echo "   Visit: https://pypi.org/project/$PACKAGE_NAME/"

