# Cardano Monitor Container
# Uses cardano-cli to monitor a remote Cardano node via TCP proxy
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    bash \
    curl \
    socat \
    netcat-openbsd \
    jq \
    bc

# Download and install cardano-cli
RUN mkdir -p /tmp/cardano && \
    cd /tmp/cardano && \
    curl -L -o cardano-node.tar.gz \
    "https://github.com/IntersectMBO/cardano-node/releases/download/10.4.1/cardano-node-10.4.1-linux.tar.gz" && \
    tar -xzf cardano-node.tar.gz && \
    mv bin/cardano-cli /usr/local/bin/ && \
    chmod +x /usr/local/bin/cardano-cli && \
    cd / && \
    rm -rf /tmp/cardano

# Create directories
RUN mkdir -p /app /ipc

# Copy monitor script
COPY scripts/monitor.sh /app/monitor.sh
RUN chmod +x /app/monitor.sh

# Environment variables
ENV CARDANO_NODE_HOST=cardano-node
ENV CARDANO_NODE_TCP_PORT=3002
ENV PING_INTERVAL=30
ENV NETWORK=mainnet
ENV CARDANO_NODE_SOCKET_PATH=/ipc/node.socket

# Set working directory
WORKDIR /app

# Run the monitor script
ENTRYPOINT ["/app/monitor.sh"]