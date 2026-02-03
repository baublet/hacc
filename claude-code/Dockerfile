ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install dependencies
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    openssh-client \
    bash \
    curl \
    jq \
    ttyd \
    python3 \
    py3-pip

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Copy root filesystem
COPY rootfs /

# Make scripts executable
RUN chmod +x /etc/s6-overlay/scripts/*.sh \
    && chmod +x /etc/s6-overlay/s6-rc.d/*/run 2>/dev/null || true \
    && chmod +x /etc/s6-overlay/s6-rc.d/*/finish 2>/dev/null || true \
    && chmod +x /usr/local/bin/*

# Labels
LABEL \
    io.hass.name="HACC" \
    io.hass.description="Home Assistant Claude Code - AI coding assistant with web terminal" \
    io.hass.type="addon" \
    io.hass.version="1.0.0" \
    io.hass.arch="aarch64|amd64"
