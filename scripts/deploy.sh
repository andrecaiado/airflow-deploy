#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-local}"
DRY_RUN="${DRY_RUN:-false}"
NAMESPACE="airflow"
RELEASE_NAME="airflow"
CHART="apache-airflow/airflow"
CHART_VERSION="1.15.0"

VALUES_DIR="values"
SECRETS_DIR="secrets"

# Validate environment argument
if [[ ! -f "${VALUES_DIR}/${ENVIRONMENT}.yaml" ]]; then
  echo "Unknown environment: ${ENVIRONMENT}"
  exit 1
fi

# Prevent accidental production deployments
CURRENT_CONTEXT=$(kubectl config current-context)
if [[ "${ENVIRONMENT}" == "production" && "${CURRENT_CONTEXT}" != "prod-cluster" ]]; then
  echo "Refusing to deploy to production from context ${CURRENT_CONTEXT}"
  exit 1
fi

# Handle dry run
HELM_ARGS=""
if [[ "${DRY_RUN}" == "true" ]]; then
  HELM_ARGS="--dry-run --debug"
fi

echo "Deploying Airflow to environment: ${ENVIRONMENT}"

kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1 || \
  kubectl create namespace "${NAMESPACE}"

helm upgrade --install "${RELEASE_NAME}" "${CHART}" \
  --version "${CHART_VERSION}" \
  --namespace "${NAMESPACE}" \
  -f "${VALUES_DIR}/base.yaml" \
  -f "${VALUES_DIR}/${ENVIRONMENT}.yaml" \
  -f "${SECRETS_DIR}/${ENVIRONMENT}.yaml" \
  ${HELM_ARGS}
