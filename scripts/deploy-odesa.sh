#!/bin/bash

set -euo pipefail

# Build locally (arm64), transfer to odesa, deploy with Podman

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
IMAGE_NAME="devopsblog:latest"
TAR_FILE="/tmp/devopsblog.tar"
ROOK_HOST="rook"
ROOK_PORT="8081"

echo "Building DevOps Blog container..."
cd "$PROJECT_ROOT"
podman build -t "$IMAGE_NAME" -f container/Containerfile .

echo "Saving image to tarball..."
podman save "$IMAGE_NAME" -o "$TAR_FILE"

echo "Transferring to odesa..."
scp "$TAR_FILE" "$ROOK_HOST:/tmp/"

echo "Loading image on odesa..."
ssh "$ROOK_HOST" "podman load -i /tmp/devopsblog.tar"

echo "Stopping existing container if running..."
ssh "$ROOK_HOST" "podman rm -f devops-blog 2>/dev/null || true"

echo "Starting container on port $ROOK_PORT..."
ssh "$ROOK_HOST" "podman run -d \\
    --name devops-blog \\
    --restart unless-stopped \\
    -p ${ROOK_PORT}:80 \\
    localhost/${IMAGE_NAME}"

echo "Cleaning up..."
rm -f "$TAR_FILE"
ssh "$ROOK_HOST" "rm -f /tmp/devopsblog.tar"

echo ""
echo "✅ Blog deployed!"
echo "URL: http://odesa.local:${ROOK_PORT}"
echo ""
echo "Check status:"
echo "  ssh rook \"podman ps | grep devops-blog\""