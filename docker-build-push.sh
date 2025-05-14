#!/bin/bash

# Docker Hub credentials
DOCKER_USERNAME="janakniroula"
IMAGE_NAME="simple-webapp"
TAG="1.0"
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$TAG"

echo "===== Building Docker Image ====="
docker build -t $FULL_IMAGE_NAME .

# Optional: Run the container locally to test
echo "===== Running Container Locally for Testing ====="
CONTAINER_ID=$(docker run -d -p 8080:8080 $FULL_IMAGE_NAME)
echo "Container started with ID: $CONTAINER_ID"
echo "Application is available at http://localhost:8080"
echo "Press Enter to continue with push (or Ctrl+C to abort)..."
read

# Stop the test container
echo "===== Stopping Test Container ====="
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

# Login to Docker Hub
echo "===== Logging in to Docker Hub ====="
echo "Please enter your Docker Hub password when prompted"
docker login -u $DOCKER_USERNAME

# Push the image to Docker Hub
echo "===== Pushing Image to Docker Hub ====="
docker push $FULL_IMAGE_NAME

echo "===== Process Complete ====="
echo "Image is now available at: $FULL_IMAGE_NAME"
echo "You can deploy to Kubernetes with:"
echo "kubectl apply -f k8s-deployment.yaml"
echo "kubectl apply -f k8s-service.yaml"
echo "kubectl apply -f k8s-ingress.yaml"