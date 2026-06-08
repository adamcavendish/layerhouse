FROM rust:1.92-slim AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app
ENV CI=true
ENV VP_HOME=/opt/vite-plus
ENV VP_NODE_MANAGER=yes
ENV VP_NODE_VERSION=24.15.0
ENV PATH="${VP_HOME}/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y --no-install-recommends pkg-config libssl-dev ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://viteplus.dev/install.sh | bash \
    && vp --version \
    && node --version

COPY Cargo.toml Cargo.lock ./
COPY docs/assets/brand docs/assets/brand
COPY crates/ crates/

WORKDIR /app/crates/layerhouse-server/dashboard
RUN vp install \
    && vp build

WORKDIR /app
RUN --mount=type=cache,target=/app/target \
    --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    cargo build --release -p layerhouse-server \
    && cp /app/target/release/layerhouse-server /tmp/layerhouse-server

FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/layerhouse-server /usr/local/bin/layerhouse-server

ENTRYPOINT ["layerhouse-server"]
