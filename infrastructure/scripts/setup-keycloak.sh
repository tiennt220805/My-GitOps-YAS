#!/bin/bash
set -e
set -x

echo "--- Installing Keycloak Operator ---"
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/kubernetes.yml

echo "--- Applying RBAC for Keycloak Operator ---"
kubectl apply -f ../base/keycloak/keycloak/role-binding.yaml
