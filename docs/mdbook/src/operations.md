# Operations

## Health Checks

### HTTP Endpoints

| Endpoint | Purpose | Expected |
|----------|---------|----------|
| `GET /healthz` | Liveness probe | 200 OK |
| `GET /readyz` | Readiness probe | 200 after S3 and Raft leader checks pass |
| `GET /metrics` | Prometheus metrics | 200 OK |
| `GET /v2/` | OCI API version check | 200 (no auth) or 401 (auth enabled) |
| `GET /api/v1/admin/cluster/status` | Raft cluster health | 200 with leader info |

### Cluster Status

```bash
curl -s http://localhost:5050/api/v1/admin/cluster/status | jq
```

Returns leader ID, the numeric quorum threshold, healthy voter count, and node details.

## Garbage Collection

layerhouse uses reference-count based garbage collection:

1. **Walk the Raft state machine** — identify all referenced blobs
2. **Grace period** — blobs uploaded within the last hour are immune from GC
3. **Tombstone** — commit a delete request to Raft
4. **S3 DELETE** — after tombstone is committed, issue S3 DELETE

### Configuration

```toml
[gc]
interval_secs = 3600      # Run GC every hour
grace_period_secs = 3600  # Protect blobs uploaded in the last hour
dry_run = false           # Set true to log without deleting
```

### Manual GC

GC runs automatically on the configured interval. There is no manual trigger API.

## Monitoring

### Prometheus Metrics

Available at `GET /metrics`:

| Metric | Description |
|--------|-------------|
| `layerhouse_up` | Process liveness |
| `layerhouse_raft_leader` | Whether this node is the Raft leader |
| `layerhouse_raft_quorum` | Required healthy voters for quorum |
| `layerhouse_raft_healthy_voters` | Voters caught up with the leader |
| `layerhouse_gc_last_run_timestamp_seconds` | Last GC sweep timestamp |
| `layerhouse_gc_last_deleted_blobs` | Blobs deleted by the last GC sweep |
| `layerhouse_gc_last_delete_errors` | Delete errors from the last GC sweep |
| `layerhouse_auth_jwks_keys` | Number of keys currently available for JWT validation |
| `layerhouse_auth_jwks_cache_age_seconds` | Age of the current last-good JWKS material |
| `layerhouse_auth_jwks_stale_cache` | Whether validation is using stale last-good JWKS material |
| `layerhouse_auth_jwks_refresh_failures_total` | Total failed JWKS refresh attempts |
| `layerhouse_auth_jwks_endpoint_info` | Active issuer or JWKS endpoint used by the latest successful refresh |

### Logging

Set `RUST_LOG` for verbosity. Set `LAYERHOUSE_LOG_FORMAT=json` for JSON logs:

```bash
RUST_LOG=layerhouse_server=debug cargo run
LAYERHOUSE_LOG_FORMAT=json layerhouse-server --config config.toml
```

## Backup and Recovery

### Snapshots

Raft snapshots are automatically uploaded to S3 after each snapshot build:

```
s3://bucket/raft-snapshots/<node-id>/latest.bin
```

### Recovery from S3

On startup, each node checks for a snapshot in S3. If found, it restores the state
machine from the snapshot and joins the cluster. No manual intervention needed.

### Database Backup

The kanidm database (`/data/kanidm.db`) should be backed up regularly. See the
[kanidm documentation](https://kanidm.github.io/kanidm/stable/backup_and_restore.html)
for backup procedures.
