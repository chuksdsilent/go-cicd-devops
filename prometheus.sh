#!/bin/bash
  helm repo add stable https://charts.helm.sh/stable || true
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
  # Check if namespace 'prometheus' exists
  if kubectl get namespace prometheus > /dev/null 2>&1; then
      # If namespace exists, upgrade the Helm release
      helm upgrade stable prometheus-community/kube-prometheus-stack -n prometheus
  else
      # If namespace does not exist, create it and install Helm release
      kubectl create namespace prometheus
      helm install stable prometheus-community/kube-prometheus-stack -n prometheus
  fi
  kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
  kubectl patch svc stable-grafana -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
