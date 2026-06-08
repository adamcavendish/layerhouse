# DNS Discovery

Layerhouse uses DNS-based peer discovery instead of a static peer list. All nodes
resolve the configured `discovery_dns` name and discover peers dynamically.

## How It Works

1. On startup, each node performs a DNS lookup of `discovery_dns`
2. For each resolved IP, it probes `/raft/status` over HTTP or HTTPS,
   depending on whether `[raft.tls]` is enabled
3. If a reachable cluster exists, it joins via `POST /raft/join`
4. If no cluster exists and the node has ordinal 0, it bootstraps

## Docker Compose

```yaml
services:
  layerhouse-0:
    hostname: layerhouse-0
    networks:
      default:
        aliases:
          - layerhouse
  layerhouse-1:
    hostname: layerhouse-1
    networks:
      default:
        aliases:
          - layerhouse
```

The `layerhouse` network alias resolves to all nodes' IPs. `discovery_dns = "layerhouse"`
uses Docker's built-in DNS.

## Kubernetes

```yaml
apiVersion: v1
kind: Service
metadata:
  name: layerhouse
spec:
  clusterIP: None
  selector:
    app: layerhouse
  ports:
  - port: 5051
    name: raft
```

The headless service `layerhouse` returns all pod IPs. `discovery_dns = "layerhouse"`
uses Kubernetes DNS.

## Node Identity

Node ID is derived from the hostname suffix:

| Hostname | Ordinal | Node ID |
|----------|---------|---------|
| `layerhouse-0` | 0 | 1 |
| `layerhouse-1` | 1 | 2 |
| `layerhouse-2` | 2 | 3 |

Ordinal 0 bootstraps the cluster if no existing cluster is found.
