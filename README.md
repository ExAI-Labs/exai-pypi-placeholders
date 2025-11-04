# exai-pypi-placeholders

This repository contains placeholder packages for ExAI Labs to reserve names on PyPI.

## Packages

This repository contains the following placeholder packages:

- `exai-py` - Main package (PyPI name: `exai-py`, import: `exai`)
- `exai-sdk` - SDK package
- `exai-paywall` - Paywall package
- `exai-core` - Core package
- `exai-cli` - CLI package
- `exai-wallet` - Wallet package
- `exai-client` - Client package

## Structure

Each package is located in its own directory under `packages/`:

```
packages/
├── exai/
│   ├── pyproject.toml
│   ├── README.md
│   └── exai/
│       └── __init__.py
├── exai-sdk/
│   ├── pyproject.toml
│   ├── README.md
│   └── exai_sdk/
│       └── __init__.py
└── ...
```

## Publishing to PyPI

### Prerequisites

1. **Create a PyPI account** (if you don't have one):
   - Go to https://pypi.org/account/register/
   - Create an account

2. **Create an API token**:
   - Go to https://pypi.org/manage/account/
   - Scroll to "API tokens" section
   - Click "Add API token"
   - Create a token with scope: "Entire account" (for all packages) or create separate tokens per package
   - **Save the token** - you'll only see it once!
   - **Important:** The token will start with `pypi-` prefix - use the entire token including the prefix when setting `UV_PUBLISH_TOKEN`

3. **Install uv** (if not already installed):
   ```bash
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   
   # Or with pip
   pip install uv
   
   # Verify installation
   uv --version
   ```

### Publishing Each Package

#### Option 1: Publish One at a Time (Recommended for first time)

Navigate to each package directory and publish with `uv`:

```bash
# Example for exai package
cd packages/exai

# Build the package first (creates dist/ directory)
uv build

# Then publish to PyPI
# Replace YOUR_API_TOKEN with your actual PyPI API token
uv publish --token pypi-YOUR_API_TOKEN

# Or first test on TestPyPI:
# 1. Create a TestPyPI account at https://test.pypi.org/account/register/
# 2. Get a TestPyPI API token
# 3. Build and publish to TestPyPI:
uv build
uv publish --token pypi-YOUR_TESTPYPI_TOKEN --publish-url https://test.pypi.org/legacy/
```

**Security Note:** For better security, you can set the token as an environment variable instead of passing it directly:

```bash
# Set environment variable (more secure)
# Note: uv uses UV_PUBLISH_TOKEN, not PYPI_API_TOKEN
# Set UV_PUBLISH_TOKEN with your PyPI API token (must include 'pypi-' prefix)
export UV_PUBLISH_TOKEN="pypi-YOUR_API_TOKEN"

# Build the package first
uv build

# Then publish (uv will automatically use the token)
uv publish
```

Repeat for each package:
- `packages/exai` (publishes as `exai-py` on PyPI)
- `packages/exai-sdk`
- `packages/exai-paywall`
- `packages/exai-core`
- `packages/exai-cli`
- `packages/exai-wallet`
- `packages/exai-client`

#### Option 2: Publish All at Once (Script)

Use the provided `publish_all.sh` script or create your own:

```bash
# Set your PyPI API token as an environment variable
# Note: uv uses UV_PUBLISH_TOKEN, not PYPI_API_TOKEN
# Set UV_PUBLISH_TOKEN with your PyPI API token (must include 'pypi-' prefix)
export UV_PUBLISH_TOKEN="pypi-YOUR_API_TOKEN"

# Run the publish script
./publish_all.sh

# Or publish to TestPyPI:
PYPI_REPO=testpypi UV_PUBLISH_TOKEN="pypi-YOUR_TESTPYPI_TOKEN" ./publish_all.sh
```

**Important:** Make sure you've set your `UV_PUBLISH_TOKEN` environment variable with your PyPI API token before running the script.

### Configuring Credentials with uv

`uv` can use environment variables or keyring for secure token storage:

**Option 1: Environment Variable (Recommended)**
```bash
# Add to your ~/.zshrc or ~/.bashrc for persistence
# Note: uv uses UV_PUBLISH_TOKEN, not PYPI_API_TOKEN
# Set UV_PUBLISH_TOKEN with your PyPI API token (must include 'pypi-' prefix)
export UV_PUBLISH_TOKEN="pypi-YOUR_API_TOKEN"
```

**Option 2: Keyring (Most Secure)**
```bash
# Store token securely in system keyring
# uv will prompt you for the token and store it securely
uv publish --token pypi-YOUR_API_TOKEN
# Future publishes will use the stored token automatically
```

**Option 3: Pass Token Directly**
```bash
# Less secure, but works for one-time publishing
uv publish --token pypi-YOUR_API_TOKEN
```

### Testing Before Publishing

Before publishing to PyPI, test on TestPyPI:

1. **Create a TestPyPI account** (separate from PyPI):
   - Go to https://test.pypi.org/account/register/
   - Create an account

2. **Create a TestPyPI API token**:
   - Go to https://test.pypi.org/manage/account/
   - Create an API token

3. **Publish to TestPyPI**:
   ```bash
   cd packages/exai
   uv build
   uv publish --token pypi-YOUR_TESTPYPI_TOKEN --publish-url https://test.pypi.org/legacy/
   ```

4. **Test installation from TestPyPI**:
   ```bash
   pip install --index-url https://test.pypi.org/simple/ exai
   ```

5. **If everything works, publish to real PyPI**:
   ```bash
   cd packages/exai
   uv build
   uv publish --token pypi-YOUR_PYPI_TOKEN
   ```

## After Publishing

Once published, your packages will be available at:
- `https://pypi.org/project/exai-py/`
- `https://pypi.org/project/exai-sdk/`
- `https://pypi.org/project/exai-paywall/`
- etc.

Users can install them with:
```bash
pip install exai-py
pip install exai-sdk
# etc.
```

## Future: Splitting into Separate Repos

When you're ready to split these into separate repositories:

1. Move each package directory to its own repo
2. Update the `project.urls` section in each `pyproject.toml` to point to the new repo URL
3. Publish a new version (e.g., `0.0.2`)
4. PyPI will automatically update the links

The package names on PyPI won't change, so existing installations will continue to work.

## License

MIT License - Copyright (c) 2025 ExAI Labs
