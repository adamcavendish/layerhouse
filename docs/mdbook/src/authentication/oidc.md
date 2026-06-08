# Dashboard OIDC

The Layerhouse dashboard supports browser-based login via OpenID Connect through
kanidm.

## Flow

```mermaid
sequenceDiagram
    Browser->>Layerhouse: GET /
    Layerhouse-->>Browser: 302 /oauth2/start
    Browser->>Layerhouse: GET /oauth2/start
    Layerhouse-->>Browser: 302 kanidm:/ui/oauth2
    Browser->>Kanidm: GET /ui/oauth2
    Kanidm-->>Browser: Login form
    Browser->>Kanidm: POST credentials
    Kanidm-->>Browser: 302 /oauth2/callback?code=...
    Browser->>Layerhouse: GET /oauth2/callback?code=...
    Layerhouse->>Kanidm: POST /oauth2/token
    Kanidm-->>Layerhouse: {access_token, refresh_token}
    Layerhouse-->>Browser: 302 / (set-cookie)
    Browser->>Layerhouse: GET / (with cookie)
    Layerhouse-->>Browser: Dashboard SPA
```

## Configuration

The dashboard OIDC flow requires these config values:

```toml
[auth]
issuer_url = "https://registry.example.com/oauth2/openid/layerhouse"
issuer_internal_url = "https://kanidm:8443/oauth2/openid/layerhouse"
client_id = "layerhouse"
client_secret = "<oauth2-client-secret>"
token_endpoint_url = "http://localhost:5050/v2/token"
redirect_uri = "http://localhost:5050/oauth2/callback"
token_signing_keys = ["<base64-encoded-key>"]
session_encryption_key = "<base64-encoded-32-byte-key>"
```

## Session Management

After successful login, Layerhouse sets an encrypted session cookie:

- **Name**: `layerhouse_session`
- **Encryption**: AES-256-GCM
- **Attributes**: `HttpOnly`, `SameSite=Lax`, `Path=/`
- **Lifetime**: Matches kanidm access token expiry

The session cookie is required for dashboard API access and PAT management.

## Endpoints

| Endpoint | Purpose |
|----------|---------|
| `GET /oauth2/start` | Initiate OIDC flow, redirect to kanidm |
| `GET /oauth2/callback` | Handle kanidm callback, exchange code for tokens |
| `GET /api/v1/session` | Get current session info (requires cookie) |
