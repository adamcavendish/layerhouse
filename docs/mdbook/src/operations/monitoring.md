# Monitoring

## Prometheus Metrics

Available at `GET /metrics`.

| Metric | Labels | Description |
|--------|--------|-------------|
| `layerhouse_up` | none | Process liveness |
| `layerhouse_raft_leader` | none | 1 if this node is the leader, 0 otherwise |
| `layerhouse_raft_quorum` | none | Required healthy voters for quorum |
| `layerhouse_raft_healthy_voters` | none | Voters caught up with the leader |
| `layerhouse_gc_last_run_timestamp_seconds` | none | Last GC sweep timestamp |
| `layerhouse_gc_last_deleted_blobs` | none | Blobs deleted by the last GC sweep |
| `layerhouse_gc_last_delete_errors` | none | Delete errors from the last GC sweep |
| `layerhouse_auth_jwks_keys` | none | Number of keys currently available for JWT validation |
| `layerhouse_auth_jwks_cache_age_seconds` | none | Age of the current last-good JWKS material |
| `layerhouse_auth_jwks_stale_cache` | none | 1 when validation is using stale last-good JWKS because all configured endpoints are unreachable |
| `layerhouse_auth_jwks_refresh_failures_total` | none | Total failed JWKS refresh attempts |
| `layerhouse_auth_jwks_endpoint_info` | `endpoint` | Active issuer or JWKS endpoint used by the latest successful refresh |

## Logging

Human-readable logs are the default. Set `LAYERHOUSE_LOG_FORMAT=json` for JSON logs; the Helm chart uses JSON logs by default.

```bash
# Debug logging
RUST_LOG=layerhouse_server=debug cargo run

# Specific module logging
RUST_LOG=layerhouse_server::raft=debug cargo run

# JSON format
LAYERHOUSE_LOG_FORMAT=json layerhouse-server --config config.toml
```

### Log Levels

| Level | Usage |
|-------|-------|
| `error` | Fatal errors requiring attention |
| `warn` | Degraded but operational (e.g., JWKS refresh failed) |
| `info` | Normal operations (startup, leadership changes, snapshot builds) |
| `debug` | Detailed request/response tracing |

## Alerting

Recommended alerts:

| Alert | Condition | Severity |
|-------|-----------|----------|
| No leader | `layerhouse_raft_leader == 0` for all nodes > 30s | Critical |
| Quorum lost | `layerhouse_raft_healthy_voters < layerhouse_raft_quorum` | Critical |
| JWKS refresh failure | `layerhouse_auth_jwks_refresh_failures_total` increasing for > 5 min | Warning |
| Stale JWKS cache in use | `layerhouse_auth_jwks_stale_cache == 1` near the `jwks_max_stale_seconds` window | Warning |
