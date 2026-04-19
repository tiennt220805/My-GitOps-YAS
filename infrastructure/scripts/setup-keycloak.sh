#!/bin/bash
set -e
set -x

echo "Installing Keycloak CRDs..."
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# BỔ SUNG: Cài đặt Keycloak Operator
echo "Installing Keycloak Operator..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install keycloak-operator bitnami/keycloak-operator \
  --create-namespace --namespace keycloak-operator