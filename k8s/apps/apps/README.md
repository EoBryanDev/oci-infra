# apps/

Cada aplicação real mora numa subpasta própria com `kustomization.yaml`:

```
apps/minha-app/
├── kustomization.yaml   # deployment, service, ingressroute...
├── deployment.yaml
├── service.yaml
└── ingressroute.yaml
```

E é registrada no `k8s/apps/kustomization.yaml` (lista `apps/minha-app`).
O `root-app` do ArgoCD sincroniza tudo a partir de `k8s/apps`.
