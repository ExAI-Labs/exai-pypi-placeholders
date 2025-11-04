#!/bin/bash
# publish_all.sh - Script to publish all placeholder packages to PyPI using uv

set -e  # Exit on error

echo "🚀 ExAI Labs - Publishing placeholder packages to PyPI"
echo "=================================================="
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "❌ Error: uv is not installed"
    echo "Install it with: curl -LsSf https://astral.sh/uv/install.sh | sh"
    exit 1
fi

echo "✅ Found uv: $(uv --version)"
echo ""

# Check if UV_PUBLISH_TOKEN is set (uv uses this env var)
if [ -z "$UV_PUBLISH_TOKEN" ]; then
    echo "⚠️  Warning: UV_PUBLISH_TOKEN environment variable is not set"
    echo "Set it with: export UV_PUBLISH_TOKEN=\"pypi-YOUR_TOKEN\""
    echo ""
    read -p "Do you want to continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Get PyPI repository (default to pypi, can override with PYPI_REPO env var)
REPOSITORY="${PYPI_REPO:-pypi}"

if [ "$REPOSITORY" = "testpypi" ]; then
    echo "⚠️  Publishing to TEST PyPI (test.pypi.org)"
    PUBLISH_URL="https://test.pypi.org/legacy/"
else
    echo "📤 Publishing to PyPI (pypi.org)"
    PUBLISH_URL=""
fi

echo ""

# Process each package
for package_dir in packages/*/; do
    package_name=$(basename "$package_dir")
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Processing: $package_name"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    cd "$package_dir"
    
    # Clean previous builds
    rm -rf build/ dist/ *.egg-info/
    
    # Build and publish with uv
    echo "🔨 Building and publishing package..."
    
    if [ -z "$PUBLISH_URL" ]; then
        # Publishing to real PyPI
        if [ -z "$UV_PUBLISH_TOKEN" ]; then
            uv publish
        else
            uv publish --token "$UV_PUBLISH_TOKEN"
        fi
    else
        # Publishing to TestPyPI
        if [ -z "$UV_PUBLISH_TOKEN" ]; then
            uv publish --publish-url "$PUBLISH_URL"
        else
            uv publish --token "$UV_PUBLISH_TOKEN" --publish-url "$PUBLISH_URL"
        fi
    fi
    
    if [ $? -ne 0 ]; then
        echo "❌ Publish failed for $package_name"
        cd ../..
        exit 1
    fi
    
    echo "✅ Successfully published $package_name"
    echo ""
    
    cd ../..
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 All packages published successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━######━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To publish to TestPyPI instead, run:"
echo "  PYPI_REPO=testpypi UV_PUBLISH_TOKEN=\"pypi-YOUR_TOKEN\" ./publish_all.sh"
