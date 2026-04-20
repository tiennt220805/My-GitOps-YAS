#!/bin/bash
set -e
set -x

echo "--- Installing Keycloak Operator ---"
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.2/kubernetes/kubernetes.yml

echo "--- Deploying Keycloak Instance ---"
sleep 30

helm upgrade --install keycloak ../base/keycloak/keycloak \
  --namespace keycloak --create-namespace \
  -f ../../environments/test/values-shared.yaml \
  -f ./cluster-config.yaml

#echo "--- Applying RBAC for Keycloak Operator ---"
#kubectl apply -f ../base/keycloak/role-binding.yaml