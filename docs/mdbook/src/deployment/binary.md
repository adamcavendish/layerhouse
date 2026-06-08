# Binary

Run layerhouse directly from the binary. No root required, no container
runtime needed. Deploy with systemd or oxmgr for process supervision.

## Quick start (single node)

```bash
# 1. Start RustFS
rustfs &

# 2. Create bucket (one-time)
rc alias set local http://127.0.0.1:9000 mykey mysecret
rc bucket create local/layerhouse -p

# 3. Start layerhouse
layerhouse-server --config deploy/binary/config/standalone.toml
```

## Cluster (3 nodes)

Copy the binary to each host. Set `HOSTNAME` to match the Raft node identity
convention (`<prefix>-<N>`):

```bash
# Host 1 (bootstraps cluster)
HOSTNAME=layerhouse-0 layerhouse-server --config deploy/binary/config/cluster.toml

# Host 2
HOSTNAME=layerhouse-1 layerhouse-server --config deploy/binary/config/cluster.toml

# Host 3
HOSTNAME=layerhouse-2 layerhouse-server --config deploy/binary/config/cluster.toml
```

Peers discover each other via DNS. Set up DNS records or `/etc/hosts` entries
for `layerhouse-0`, `layerhouse-1`, `layerhouse-2`.

## Process management

### oxmgr (recommended)

```bash
oxmgr apply deploy/binary/oxmgr/oxfile.toml
```

oxmgr provides restart-on-failure, log rotation, and health checks without
root privileges. See [OxMgr](https://github.com/Vladimir-Urik/OxMgr).

### systemd

```bash
sudo cp deploy/binary/systemd/layerhouse.service /etc/systemd/system/
sudo systemctl enable --now layerhouse
```

Systemd requires root for installation. The service runs as the `layerhouse`
user. Adjust `User=` and `ExecStart=` in the unit file for your environment.

## Configuration paths

Binary deployment uses paths relative to the working directory:

```
./config.toml          # layerhouse config (or set LAYERHOUSE_CONFIG)
./data/raft/           # Raft log (ephemeral, no backup needed)
```

No `/etc/layerhouse/` writes required. Override with:

```bash
layerhouse-server --config /path/to/config.toml
```

## Upgrading

```bash
# 1. Graceful shutdown (uploads snapshot, leaves Raft)
kill -SIGTERM $(pidof layerhouse-server)

# 2. Replace binary
cp layerhouse-server-new /usr/local/bin/layerhouse-server

# 3. Restart
layerhouse-server --config config.toml
```

The node rejoins the Raft cluster automatically on restart. Snapshots
restored from S3 ensure no data loss.
