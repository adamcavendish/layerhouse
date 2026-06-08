# Kubernetes Deployment

layerhouse runs as a StatefulSet with automatic Raft membership management.

## Architecture

```
┌─────────────────────────────────────────────┐
│                  Kubernetes                  │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ orb-0   │  │ orb-1   │  │ orb-2   │     │
│  │ Raft ✓  │  │ Raft ✓  │  │ Raft ✓  │     │
│  └─────────┘  └─────────┘  └─────────┘     │
│       │            │            │            │
│       └────────────┼────────────┘            │
│                    │                         │
│            ┌───────┴───────┐                 │
│            │  S3 (external) │                │
│            └───────────────┘                 │
└─────────────────────────────────────────────┘
```

- **StatefulSet** provides stable hostnames (`layerhouse-0`, `layerhouse-1`, ...)
- **DNS discovery** (`discovery_dns = "layerhouse"`) enables automatic peer discovery
- **Kubernetes reconciler** adjusts Raft membership when replicas change
- **No PVC** — Raft log uses ephemeral redb; state recovers from S3 snapshots

## Install

```bash
helm install layerhouse ./deploy/kubernetes/helm \
  --namespace layerhouse \
  --create-namespace \
  --set storage.s3.endpoint=https://s3.example.internal \
  --set storage.s3.bucket=layerhouse \
  --set storage.s3.region=us-east-1
```

See [values.yaml](helm/values.yaml) for all options.
