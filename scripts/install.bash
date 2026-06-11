#!/env/bash

curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

k3s kubectl get nodes

# ssh doink@k3s "sudo cat /etc/rancher/k3s/k3s.yaml" | sed -e 's/127.0.0.1/k3s/g' -e 's/localhost/k3s/g' > ~/.kube/config && chmod 600 ~/.kube/config && kubectl cluster-info
scp doink@k3s:/etc/rancher/k3s/k3s.yaml ~/.kube/config
sed -i 's/127.0.0.1/k3s/g' ~/.kube/config && sed -i 's/localhost/k3s/g' ~/.kube/config
chmod 600 ~/.kube/config
kubectl cluster-info

kubectl create namespace argocd
kubectl apply --server-side -k https://github.com/jacokok/argo-test.git/bootstrap

# Get default password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl apply -f https://raw.githubusercontent.com/jacokok/argo-test/refs/heads/main/apps/argocd.yaml
