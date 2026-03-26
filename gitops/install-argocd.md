# Deploying ArgoCD for GitOps

Once your Kubernetes cluster is up and running via the Ansible playbook, follow these steps to install ArgoCD and configure your application deployment.

## 1. Install ArgoCD
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## 2. Access ArgoCD API Server
By default, the Argo CD API server is not exposed with an external IP. To access the UI, you can port-forward:
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## 3. Login using the CLI
The initial password for the admin account is auto-generated and stored as clear text in the field password in a secret named argocd-initial-admin-secret. You can retrieve this password using kubectl:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Login using `admin` and the password above at `localhost:8080`.

## 4. Deploy the Spring Demo Application
Now deploy the `Application` manifest found in this directory. 
Make sure you update the `repoURL` in `application.yaml` to point to your actual Git repository where the `helm/` directory is located.

```bash
kubectl apply -f application.yaml
```
