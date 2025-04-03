# Generate Private Keys

```bash
mkdir keys
openssl genrsa -out ./keys/cluster_admin.key 2048
openssl genrsa -out ./keys/secure_operator.key 2048
openssl genrsa -out ./keys/tech_support.key 2048
```

# And Certificate Signing Requests

```bash
openssl req -new -key ./keys/cluster_admin.key -out ./keys/cluster_admin.csr -subj "/CN=cluster_admin"
openssl req -new -key ./keys/secure_operator.key -out ./keys/secure_operator.csr -subj "/CN=secure_operator"
openssl req -new -key ./keys/tech_support.key -out ./keys/tech_support.csr -subj "/CN=tech_support"
```

# Submitting the CSRs to the API Server

```bash
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: cluster_admin_csr
spec:
  groups:
  - system:authenticated  
  request: $(cat ./keys/cluster_admin.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # ten days
  usages:
  - client auth
EOF
```

```bash
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: secure_operator_csr
spec:
  groups:
  - system:authenticated  
  request: $(cat ./keys/secure_operator.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # ten days
  usages:
  - client auth
EOF
```

```bash
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: tech_support_csr
spec:
  groups:
  - system:authenticated  
  request: $(cat ./keys/tech_support.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 864000  # ten days
  usages:
  - client auth
EOF
```

# Approve CSRs

```bash
kubectl certificate approve cluster_admin_csr
kubectl certificate approve secure_operator_csr
kubectl certificate approve tech_support_csr
```

# And retrieve certificates

```bash
mkdir certificates
kubectl get certificatesigningrequests cluster_admin_csr -o jsonpath='{ .status.certificate }' | base64 --decode > certificates/cluster_admin.crt
kubectl get certificatesigningrequests secure_operator_csr -o jsonpath='{ .status.certificate }' | base64 --decode > certificates/secure_operator.crt
kubectl get certificatesigningrequests tech_support_csr -o jsonpath='{ .status.certificate }' | base64 --decode > certificates/tech_support.crt
```

# Configure the authentication information for the users

```bash
kubectl config set-credentials cluster_admin --client-key=./keys/cluster_admin.key --client-certificate=./certificates/cluster_admin.crt --embed-certs=true
kubectl config set-credentials secure_operator --client-key=./keys/secure_operator.key --client-certificate=./certificates/secure_operator.crt --embed-certs=true
kubectl config set-credentials tech_support --client-key=./keys/tech_support.key --client-certificate=./certificates/tech_support.crt --embed-certs=true
kubectl config set-context minikube@cluster_admin --cluster=minikube --user=cluster_admin
kubectl config set-context minikube@secure_operator --cluster=minikube --user=secure_operator
kubectl config set-context minikube@tech_support --cluster=minikube --user=tech_support
```

# Apply Roles and Role Bindings

```bash
kubectl apply -f ./roles/cluster_admin.yaml
kubectl apply -f ./roles/cluster_viewer.yaml
kubectl apply -f ./roles/secure_manager.yaml

kubectl apply -f ./role_bindings/cluster_admin.yaml
kubectl apply -f ./role_bindings/cluster_viewer.yaml
kubectl apply -f ./role_bindings/secure_manager.yaml
```
