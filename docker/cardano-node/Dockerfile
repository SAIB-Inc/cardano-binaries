# Cardano Node with TCP-to-Unix Socket Proxy
# Based on Blink Labs cardano-node for enhanced features
FROM ghcr.io/blinklabs-io/cardano-node:10.5.1-1

# Install socat for TCP to Unix socket proxy
USER root
RUN apt-get update && \
    apt-get install -y socat && \
    rm -rf /var/lib/apt/lists/*

# Create startup script
COPY scripts/startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh

# Create necessary directories
RUN mkdir -p /data /ipc

# Expose ports
# 3001 - Cardano node port (P2P)
# 3002 - TCP proxy to Unix socket (for mini-protocols)
EXPOSE 3001 3002

# Environment variables
ENV NETWORK=mainnet
ENV RESTORE_SNAPSHOT=true
ENV CARDANO_SOCKET_PATH=/ipc/node.socket
ENV TCP_SOCKET_PORT=3002
ENV NODE_PORT=3001

# Use our custom startup script
ENTRYPOINT ["/app/startup.sh"]