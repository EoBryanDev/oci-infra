# palpitai (web)

Deploy GitOps da web do PalpitAI (`apps/web` do repo `dev4-palpita-ai`).

- **URL**: https://palpitai.synit.top (DNS via TF `cloudflare_record.palpitai`)
- **Imagem**: `ghcr.io/eobryandev/dev4-palpita-ai-web:<sha>` (pipeline `docker-deploy.yml` no repo da app faz bump do `newTag` aqui)
- **Migrate**: Job `palpitai-migrate` (imagem `...-migrator`, `node migrate.prod.mjs`). Job completo não re-executa: para nova migração, `kubectl -n apps delete job palpitai-migrate` e o Argo recria.

## Secret `palpitai-web` (ns `apps`, imperativo — nunca no Git)

12 chaves. `DATABASE_URL` aponta o banco `palpitai` no cluster; `APP_URL`
é obrigatória (o CSRF guard `validarOrigem` rejeita login sem ela —
fallback `http://localhost:3000` quebra em produção).

```bash
PALP_PW=$(kubectl -n databases get secret palpitai-db -o jsonpath='{.data.password}' | base64 -d)
kubectl -n apps create secret generic palpitai-web \
  --from-literal=DATABASE_URL="postgresql://palpitai_app:$PALP_PW@pg-main-rw.databases.svc.cluster.local:5432/palpitai" \
  --from-literal=APP_URL='https://palpitai.synit.top' \
  --from-literal=JWT_SECRET='<32+ chars>' \
  --from-literal=JWT_EXPIRES_IN='7d' \
  --from-literal=BCRYPT_SALT_ROUNDS='12' \
  --from-literal=RATE_LIMIT_LOGIN_MAX='5' \
  --from-literal=RATE_LIMIT_LOGIN_WINDOW_MS='900000' \
  --from-literal=RATE_LIMIT_GENERAL_MAX='100' \
  --from-literal=RATE_LIMIT_GENERAL_WINDOW_MS='60000' \
  --from-literal=LINEAR_API_KEY='<opcional>' \
  --from-literal=NODE_ENV='production' \
  --from-literal=PORT='3000'
# Após criar/atualizar o Secret: kubectl -n apps rollout restart deployment palpitai-web
# (envFrom só é lido na criação do pod)
```

## Telemetria

`OTEL_*` já injetado no Deployment (endpoint do collector central).
Logs: Loki `{namespace="apps"}` · Traces: Tempo `resource.service.name = "palpitai-web"`.
