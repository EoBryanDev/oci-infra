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

## Exportando telemetria para o OTel Collector

Endpoint único (dentro do cluster):

- OTLP gRPC: `http://otel-collector-opentelemetry-collector.monitoring.svc.cluster.local:4317`
- OTLP HTTP: `http://otel-collector-opentelemetry-collector.monitoring.svc.cluster.local:4318`

O Collector roteia sozinho: métricas → Prometheus, logs → Loki, traces → Tempo.
Exemplo (variáveis de ambiente na sua app):

```
OTEL_EXPORTER_OTLP_ENDPOINT=http://otel-collector-opentelemetry-collector.monitoring.svc.cluster.local:4317
OTEL_SERVICE_NAME=minha-app
```

## Queries prontas (Grafana → Explore)

Logs com erro por namespace (Loki):

```
{namespace="apps"} |= "error"
```

Latência p95 por rota (Tempo, TraceQL):

```
{ resource.service.name = "minha-app" } | quantile_over_time(duration, .95)
```

Targets com falha (Prometheus):

```
up == 0
```
