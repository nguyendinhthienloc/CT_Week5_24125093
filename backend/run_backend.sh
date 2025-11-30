#!/usr/bin/env bash
set -euo pipefail

# Minimal helper to create venv, install deps, and run the Flask backend (Linux / macOS)
# Usage: ./run_backend.sh

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

echo "Backend folder: $ROOT_DIR"

if [ ! -f "$VENV_DIR/bin/activate" ]; then
  echo "Creating virtual environment in $VENV_DIR..."
  python3 -m venv "$VENV_DIR"
fi

echo "Activating venv..."
# shellcheck source=/dev/null
source "$VENV_DIR/bin/activate"

echo "Upgrading pip and installing requirements..."
pip install --upgrade pip
pip install -r "$ROOT_DIR/requirements.txt"

echo "Starting Flask backend on http://0.0.0.0:5001 (Ctrl+C to stop)"
python "$ROOT_DIR/app.py"
