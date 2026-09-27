#!/bin/bash

set -euo pipefail

WELCOME_MSG="jvillavi DevOps Blog"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONTAINERFILE="$PROJECT_ROOT/container/Containerfile"
IMAGE_NAME="localhost/devopsblog:latest"

# Pre-requisites checks
echo "Checking prerequisites..."

if ! command -v podman >/dev/null 2>&1; then
    echo "😵 Podman is not installed. Please install Podman to continue"
    exit 1
fi

# Optional: figlet + lolcat for style
if command -v figlet >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
    figlet "$WELCOME_MSG" | lolcat
else
    echo "$WELCOME_MSG"
fi

echo "--------------------------------------------------"
echo "PROJECT ROOT: $PROJECT_ROOT"
echo "CONTAINERFILE: $CONTAINERFILE"
echo "IMAGE: $IMAGE_NAME"
echo "--------------------------------------------------"

echo "Building multi-stage container image..."
podman build \
    -t "$IMAGE_NAME" \
    -f "$CONTAINERFILE" \
    "$PROJECT_ROOT"

echo ""
echo "✅ Build complete!"
echo ""
echo "Run locally:"
echo "  podman run -d -p 8080:80 --name devopsblog $IMAGE_NAME"
echo ""
echo "Deploy to k3s:"
echo "  $SCRIPT_DIR/deploy.sh"