ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BUILD_ARCH
ARG CHIRPSTACK_VERSION="4.20.0"
ARG GATEWAY_BRIDGE_VERSION="4.1.2"

RUN apk add --no-cache redis

# Official static builds from artifacts.chirpstack.io, pinned by SHA-256.
RUN set -eux; \
    case "${BUILD_ARCH}" in \
        amd64) arch=amd64; \
            cs_sha=483fa5cab609e448477caab05a3f6cb8d7c6c7bd8f23180f3cae077c72e7bfc1; \
            gwb_sha=113c7e5bd42d06c66272506827d323ef6469980007500e8f161754ea4e6d2596 ;; \
        aarch64) arch=arm64; \
            cs_sha=bf074d09680b7b4d47ad5a75dbfa4f913b0b5543777ed8c1f6cfb34fb2b7c2a1; \
            gwb_sha=cc844c7a320e32d09eb92748e8cd5b352f978ecf56b90c58b6f19b8100bd7094 ;; \
        *) echo "Unsupported architecture: ${BUILD_ARCH}"; exit 1 ;; \
    esac; \
    cd /tmp; \
    curl -fsSLo cs.tgz "https://artifacts.chirpstack.io/downloads/chirpstack/chirpstack_${CHIRPSTACK_VERSION}_sqlite_linux_${arch}.tar.gz"; \
    echo "${cs_sha}  cs.tgz" | sha256sum -c -; \
    curl -fsSLo gwb.tgz "https://artifacts.chirpstack.io/downloads/chirpstack-gateway-bridge/chirpstack-gateway-bridge_${GATEWAY_BRIDGE_VERSION}_linux_${arch}.tar.gz"; \
    echo "${gwb_sha}  gwb.tgz" | sha256sum -c -; \
    tar -xzf cs.tgz -C /usr/local/bin chirpstack; \
    tar -xzf gwb.tgz -C /usr/local/bin chirpstack-gateway-bridge; \
    rm -f cs.tgz gwb.tgz; \
    chirpstack --version; \
    chirpstack-gateway-bridge version

COPY rootfs /
RUN chmod a+x /usr/local/bin/render-chirpstack-config /etc/cont-init.d/*.sh /etc/services.d/*/run
