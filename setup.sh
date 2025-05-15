# Step 1: Create the logging namespace
kubectl create namespace logging

# Step 2: Deploy Elasticsearch
kubectl apply -f elasticsearch.yaml

# Step 3: Wait for Elasticsearch to be ready
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n logging --timeout=300s

kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
kubectl apply -f ingress.yaml

# Step 4: Deploy Kibana
kubectl apply -f kibana.yaml

# Step 5: Deploy Logstash
kubectl apply -f logstash.yaml

# Step 6: Deploy Filebeat
kubectl apply -f filebeat.yaml

# Step 7: Verify all pods are running
kubectl get pods -n logging

# Step 8: Get Kibana service URL (if using NodePort)
kubectl get svc -n logging

# Step 9: Get Elasticsearch password (if needed)
kubectl get secret elasticsearch-es-elastic-user -n logging -o=jsonpath='{.data.elastic}' | base64 --decode; echo

# Step 10: Monitor logs
kubectl logs -f -l app=filebeat -n logging

# Step 11: Port forward Kibana (for local access)
kubectl port-forward service/kibana-kb-http 5601 -n logging
