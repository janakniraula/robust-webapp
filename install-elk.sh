#!/bin/bash

# Install Helm if not already installed
if ! command -v helm &> /dev/null; then
    echo "Helm not found. Installing Helm..."
    # Download Helm installation script
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    # Make the script executable
    chmod 700 get_helm.sh
    # Run the script to install Helm
    ./get_helm.sh
    # Clean up
    rm get_helm.sh
    echo "Helm installed successfully."
else
    echo "Helm is already installed."
fi

# Create namespace for logging
kubectl create namespace logging

# Add Elastic Helm repository
helm repo add elastic https://helm.elastic.co
helm repo update

# Create directories for persistent volumes if needed
mkdir -p /data/elasticsearch
chmod 777 /data/elasticsearch

# Note: The actual installation will be done using the kubectl apply commands
# with the YAML files we'll create in the next step
echo "ELK Stack repositories and prerequisites set up successfully."
echo "Please use the kubectl apply commands provided separately to deploy the components."