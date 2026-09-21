# portfolio (web)

Deploy GitOps do portfólio (`portfolio-eobryandev-2.0`).

- **URL**: https://eobryandev.synit.top (DNS via TF `cloudflare_record.eobryandev`)
- **Imagem**: `ghcr.io/eobryandev/portfolio-web:<sha>` (pipeline `docker-deploy.yml` no repo da app faz bump do `newTag` aqui)
- **App atual**: frontend estático, sem env, sem Secret de app, sem migrate.

## Banco reservado (futuro blog)

Database `eobryandev-portifolio` + role `eobryandev_portifolio_app`
provisionados via `manifests/provision-portfolio.yaml` (mesmo padrão do
palpitai). Credencial no Secret `portfolio-db` (ns `databases`, imperativo):

```bash
PORT_PW=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32)
kubectl -n databases exec pg-main-1 -c postgres -- \
  psql -U postgres -d postgres -tAc "ALTER ROLE eobryandev_portifolio_app WITH PASSWORD '$PORT_PW';"
kubectl -n databases create secret generic portfolio-db \
  --from-literal=username=eobryandev_portifolio_app \
  --from-literal=password="$PORT_PW" \
  --from-literal=dbname=eobryandev-portifolio \
  --from-literal=host=pg-main-rw \
  --from-literal=port=5432 \
  --from-literal=url="postgresql://eobryandev_portifolio_app:$PORT_PW@pg-main-rw:5432/eobryandev-portifolio"
```

## Telemetria

`OTEL_*` já injetado no Deployment (endpoint do collector central).
Logs: Loki `{namespace="apps"}` · Traces: Tempo `resource.service.name = "portfolio-web"`.
