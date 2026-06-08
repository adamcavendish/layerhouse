#!/usr/bin/env bash
set -euo pipefail

cat <<'YAML'
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: layerhouse-selfsigned
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: layerhouse-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: Layerhouse Tilt CA
  secretName: layerhouse-ca-secret
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: layerhouse-selfsigned
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: layerhouse-ca
spec:
  ca:
    secretName: layerhouse-ca-secret
YAML
