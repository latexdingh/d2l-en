#!/bin/bash
# Build script for TensorFlow version of d2l-en
# Mirrors structure of build_pytorch.sh and build_jax.sh

set -e

# Environment setup
echo "=== Setting up TensorFlow build environment ==="
pip install tensorflow tensorflow-datasets
pip install d2l

# Verify TensorFlow installation
python -c "import tensorflow as tf; print('TensorFlow version:', tf.__version__)"

# Set framework environment variable
export FRAMEWORK=tensorflow

# Navigate to project root
cd "$(dirname "$0")/../.."

echo "=== Installing project dependencies ==="
pip install -e .
pip install -r requirements.txt

echo "=== Building TensorFlow notebooks ==="
if [ -d "tensorflow" ]; then
    cd tensorflow
else
    echo "No tensorflow directory found, building from root"
fi

# Run notebook builds
echo "=== Executing notebooks ==="
python ../utils/build_notebooks.py \
    --framework tensorflow \
    --timeout 1800 \
    --output-dir _build/tensorflow

echo "=== Building HTML documentation ==="
make html FRAMEWORK=tensorflow

echo "=== TensorFlow build complete ==="
