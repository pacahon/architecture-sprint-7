https://docs.cilium.io/en/latest/gettingstarted/k8s-install-default/#cilium-quick-installation

```bash
kubectl apply -f pods/frontend.yaml
kubectl apply -f pods/backend_api.yaml
kubectl apply -f pods/admin_frontend.yaml
kubectl apply -f pods/admin_backend_api.yaml 

kubectl apply -f non-admin-api-allow.yaml 
```