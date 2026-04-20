#!/bin/bash
set -e
set -x

# 1. Thêm các kho lưu trữ Helm cần thiết
helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator
helm repo add strimzi https://strimzi.io/charts/
helm repo add elastic https://helm.elastic.co

echo "Updating Helm Repos..."
helm repo update || true

# 2. Cài đặt các Operators (Cluster-level)
echo "Installing Postgres Operator..."
helm upgrade --install postgres-operator postgres-operator-charts/postgres-operator \
 --create-namespace --namespace postgres-operator

echo "Installing Kafka Operator (Strimzi)..."
helm upgrade --install kafka-operator strimzi/strimzi-kafka-operator \
 --version 0.45.0 \
 --create-namespace --namespace kafka-operator \
 --set watchAnyNamespace=true

echo "Installing Elasticsearch Operator (ECK)..."
helm upgrade --install elastic-operator elastic/eck-operator \
 --create-namespace --namespace elastic-system