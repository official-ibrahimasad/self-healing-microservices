#!/bin/bash
# chaos-demo.sh — run this live during the presentation
echo "=== CHAOS DEMO ==="
echo "Current pods:"
kubectl get pods -n production -l app=flask-api

POD=$(kubectl get pods -n production -l app=flask-api \
  -o jsonpath='{.items[0].metadata.name}')

echo ""
echo "Killing pod: $POD"
kubectl delete pod $POD -n production

curl -s -X POST http://admin:prom-operator@localhost:3000/api/annotations \
  -H "Content-Type: application/json" \
  -d '{
  "text": "Pod Killed Here",
  "tags": ["chaos", "demo"],
  "time": '"$(date +%s%3N)"'
}' > /dev/null

echo ""
echo "Watch Kubernetes recover automatically:"
kubectl get pods -n production -w
