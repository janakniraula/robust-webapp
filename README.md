# Simple Web Application Deployment on Kubernetes with ELK Stack for Monitoring

This repository contains instructions for setting up a Kubernetes cluster, deploying a Java application, exposing the application via services, and monitoring logs using the ELK Stack with Filebeat.

## Task Overview
1. **Kubernetes Cluster Setup**: Create a Kubernetes cluster with one master node and one worker node.
2. **Deploy Java Application**: Package the application as a WAR file, containerize it, and deploy it on the cluster.
3. **Expose Application via Services**: Use NodePort and Ingress for external access.
4. **Log Monitoring**: Configure the ELK Stack (Elasticsearch, Logstash, Kibana) and Filebeat for log collection.

---

## Prerequisites
- `kubectl` CLI installed
- Docker installed
- Kubernetes installed k3s
- Linux

---

## 1. Kubernetes Cluster Setup
Follow these steps to set up a Kubernetes cluster:

1. Install Kubernetes k3s on both master and worker nodes.
   - For k3s:
     ```bash
     curl -sfL https://get.k3s.io | sh -
     ```
2. Connect worker node to master node:
   - Retrieve the join token from the master node:
     ```bash
     sudo cat /var/lib/rancher/k3s/server/node-token
     ```
   - Use the token to join the worker node:
     ```bash
     sudo k3s agent --server https://<MASTER_IP>:6443 --token <TOKEN>
     ```
3. Validate cluster setup:
   ```bash
   kubectl get nodes
   ```

---

## 2. Deploy the Java Application

### Step 1: Package the Application
- Build the Java application and package it into a `.war` file.

### Step 2: Create a Docker Image

- Used github actions to build `WAR` file, create Docker image, and push to DockerHub.

- Used a base image of `tomcat` and created a custom Docker image named simple-webapp:1.0:

### Step 3: Create Kubernetes Deployment
- Created a `deployment.yaml` file which pulls the simple-webapp:1.0 from docekrhub:

- Apply the deployment:
  ```bash
  kubectl apply -f deployment.yaml
  ```

## 3. Expose Application via Services

### NodePort Service
- Create a `services.yaml` file:

- Apply the service:
  ```bash
  kubectl apply -f service.yaml
  ```

### Ingress Resource
- Ensure an Ingress controller (e.g., Nginx) is installed:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
  ```

- Create an `ingress.yaml` file:

- Apply the Ingress resource:
  ```bash
  kubectl apply -f ingress.yaml
  ```

---

## 4. Log Monitoring with ELK Stack

### Step 1: Deploy Elasticsearch, Logstash, and Kibana
- Use Helm charts or manifests to deploy the ELK Stack in your cluster. Example with Helm:
  ```bash
  helm repo add elastic https://helm.elastic.co
  helm install elasticsearch elastic/elasticsearch
  helm install kibana elastic/kibana
  helm install logstash elastic/logstash
  ```

### Step 2: Set Up Filebeat
- Install Filebeat as a DaemonSet:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/elastic/beats/main/deploy/kubernetes/filebeat-kubernetes.yaml
  ```

- Configure Filebeat to forward logs to Logstash:

- Apply the configuration:
  ```bash
  kubectl apply -f filebeat-config.yaml
  ```

### Step 3: Access Kibana
- Forward Kibana to a local port:
  ```bash
  kubectl port-forward service/kibana-kb-http 5601:5601
  ```
- Open `http://localhost:5601` in your browser.


## Verification
1. Confirm the application is running:
   ```bash
   curl http://<NODE_IP>:30007
   ```
2. Access the application via Ingress:
   - Add the domain `java-app.local` in your `/etc/hosts` file pointing to the Node IP.
   - Open `http://java-app.local` in your browser.
3. Check logs in Kibana for the Java application.

## Cleanup
To clean up the resources:
```bash
kubectl delete -f deployment.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f ingress.yaml
helm uninstall elasticsearch kibana logstash
```
