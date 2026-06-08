# Docker Compose Deployment

Production multi-replica layerhouse with RustFS for local S3-compatible storage.

## Files

| File | Description |
|---|---|
| `standalone.yml` | Single layerhouse node + RustFS |
| `cluster.yml` | Three-node Raft cluster + RustFS |
| `config/standalone.toml` | Config for standalone mode |
| `config/cluster.toml` | Config for cluster mode |

## Quick start

```bash
# Single node
docker compose -f deploy/compose/standalone.yml up -d

# Three-node cluster
docker compose -f deploy/compose/cluster.yml up -d
```

## Rolling updates

Named services (`layerhouse-0`, `layerhouse-1`, `layerhouse-2`) allow
rolling restarts without downtime:

```bash
docker compose -f deploy/compose/cluster.yml up -d --no-deps layerhouse-0
docker compose -f deploy/compose/cluster.yml up -d --no-deps layerhouse-1
docker compose -f deploy/compose/cluster.yml up -d --no-deps layerhouse-2
```

Each node gracefully leaves the Raft cluster on shutdown (uploads snapshot,
removes itself from membership), then the updated container rejoins on start.

## Configuration

Override defaults via environment variables:

```bash
RUSTFS_ACCESS_KEY=mykey RUSTFS_SECRET_KEY=mysecret \
  docker compose -f deploy/compose/cluster.yml up -d
```

For persistent configuration, copy `config/cluster.toml` and edit.
