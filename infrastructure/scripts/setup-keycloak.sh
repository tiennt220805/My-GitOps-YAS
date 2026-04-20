#!/bin/bash
set -e
set -x

# echo "--- Installing Keycloak Operator ---"
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/kubernetes.yml

# echo "--- Applying RBAC for Keycloak Operator ---"
# kubectl apply -f ../base/keycloak/keycloak/role-binding.yaml

# Create namespace for Keycloak Operator
kubectl create namespace keycloak-operator --dry-run=client -o yaml | kubectl apply -f -

# Install CRD và Operator
echo "--- Installing Keycloak Operator into keycloak-operator namespace ---"
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

curl -s https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/kubernetes.yml | \
sed 's/namespace: default/namespace: keycloak-operator/g' | \
kubectl apply -f - -n keycloak-operator

echo "--- Applying RBAC for Keycloak Operator ---"
kubectl apply -f ../base/keycloak/keycloak/role-binding.yaml

echo "--- Patching Keycloak Operator to Cluster-wide mode ---"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PATCH_FILE="$SCRIPT_DIR/../base/keycloak/keycloak/keycloak-operator-patch.yaml"

if [ -f "$PATCH_FILE" ]; then
    kubectl patch deployment keycloak-operator \
      -n keycloak-operator \
      --type=strategic \
      --patch-file "$PATCH_FILE"
    
    echo "Patch applied successfully."
else
    echo "Error: File patch not found at $PATCH_FILE"
    exit 1
fi