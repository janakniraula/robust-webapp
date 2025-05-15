#!/bin/bash

# Create namespace for logging
kubectl create namespace logging

# Add Elastic Helm repository
helm repo add elastic https://helm.elastic.co

# Update Helm repositories
helm repo update

# Download latest Elasticsearch values
helm show values elastic/elasticsearch > elasticsearch-values.yaml

# Download latest Kibana values
helm show values elastic/kibana > kibana-values.yaml

# Download latest Logstash values
helm show values elastic/logstash > logstash-values.yaml