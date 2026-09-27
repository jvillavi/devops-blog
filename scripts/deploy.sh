#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
IMAGE_NAME="localhost/devopsblog:latest"
KUBECTL="kubectl"
NAMESPACE="default"

# Optional: load image into k3s if building locally
# sudo k3s ctr images import <(podman save "$IMAGE_NAME" --format oci-archive)

echo "Deploying DevOps Blog to k3s..."
echo "--------------------------------------------------"

echo "Applying Kubernetes manifests..."
$KUBECTL apply -f "$PROJECT_ROOT/manifests/" --namespace="$NAMESPACE"

echo "Waiting for deployment to be ready..."
$KUBECTL rollout status deployment/devops-blog --namespace="$NAMESPACE" --timeout=60s

echo ""
echo "✅ Deployment complete!"
echo ""
$KUBECTL get pods --namespace="$NAMESPACE" -l app=devops-blog
echo ""
echo "Get logs:"
echo "  kubectl logs -l app=devops-blog --namespace=$NAMESPACE"

# Optional: show ingress URL
if $KUBECTL get ingress devops-blog --namespace="$NAMESPACE" >/dev/null 2>&1; then
    echo ""
    $KUBECTL get ingress devops-blog --namespace="$NAMESPACE"
fi