#!/bin/bash
set -e
set -x

echo "Installing Keycloak Operator (Official Bundle)..."

kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/kubernetes.yml

echo "Waiting for Keycloak Operator to be ready..."
kubectl rollout status deployment/keycloak-operator -n keycloak-operator --timeout=3m || true