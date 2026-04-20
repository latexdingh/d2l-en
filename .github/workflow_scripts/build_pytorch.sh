#!/bin/bash
# Build script for PyTorch framework version of d2l-en
set -e

# Source environment variables
SOURCE_DIR=$(dirname "$0")
source "$SOURCE_DIR/../actions/setup_env_vars/action.yml" 2>/dev/null || true

echo "========================================"
echo "Building d2l-en (PyTorch)"
echo "========================================"

# Check required environment variables
if [ -z "$REPO_DIR" ]; then
    REPO_DIR=$(pwd)
fi

if [ -z "$OUTPUT_DIR" ]; then
    OUTPUT_DIR="$REPO_DIR/_build/pytorch"
fi

echo "Repository directory: $REPO_DIR"
echo "Output directory: $OUTPUT_DIR"

# Install dependencies
echo "Installing Python dependencies..."
pip install torch torchvision --quiet
pip install d2l --quiet
pip install sphinx myst-parser sphinx-book-theme --quiet

# Verify PyTorch installation
python -c "import torch; print(f'PyTorch version: {torch.__version__}')" || {
    echo "ERROR: PyTorch installation failed"
    exit 1
}

# Set framework environment variable
export FRAMEWORK=pytorch

# Navigate to repo directory
cd "$REPO_DIR"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Execute notebooks with PyTorch backend
echo "Executing notebooks..."
if [ -f "config.ini" ]; then
    echo "Found config.ini, using project configuration"
fi

# Build HTML output
echo "Building HTML documentation..."
make pytorch 2>&1 | tee "$OUTPUT_DIR/build.log" || {
    echo "ERROR: Build failed. Check $OUTPUT_DIR/build.log for details"
    exit 1
}

echo "========================================"
echo "Build completed successfully"
echo "Output available at: $OUTPUT_DIR"
echo "========================================"
