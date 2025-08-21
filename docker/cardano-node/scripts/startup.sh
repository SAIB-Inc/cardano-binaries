#!/bin/bash
set -euo pipefail

echo "=== STARTING CARDANO NODE WITH TCP PROXY ==="

# Simple error handler
die() {
    echo "ERROR: $1" >&2
    exit 1
}

# Configuration
NETWORK=${NETWORK:-mainnet}
SOCKET_PATH="${CARDANO_SOCKET_PATH:-/ipc/node.socket}"
TCP_PORT="${TCP_SOCKET_PORT:-3002}"
NODE_PORT="${NODE_PORT:-3001}"

echo "Network: $NETWORK"
echo "Socket path: $SOCKET_PATH"
echo "TCP proxy port: $TCP_PORT"
echo "Node P2P port: $NODE_PORT"

# Set permissions if needed
[ -d "/data" ] && chown -R $(id -u):$(id -g) /data 2>/dev/null || true

# Start cardano-node using Blink Labs entrypoint
echo "Starting cardano-node..."
/usr/local/bin/entrypoint "$@" &
CARDANO_PID=$!

# Wait for socket file to exist
echo "Waiting for cardano-node socket at $SOCKET_PATH..."
WAIT_COUNT=0
while [ ! -S "$SOCKET_PATH" ]; do
    # Check if cardano-node is still running
    kill -0 $CARDANO_PID 2>/dev/null || die "cardano-node died"
    
    WAIT_COUNT=$((WAIT_COUNT + 1))
    if [ $((WAIT_COUNT % 30)) -eq 0 ]; then
        echo "Still waiting for socket... (${WAIT_COUNT}s elapsed)"
    fi
    
    sleep 1
done

echo "Socket file exists, starting TCP proxy..."
sleep 5

# Start socat TCP-to-Unix socket proxy (IPv6 compatible)
echo "Starting socat TCP proxy on port $TCP_PORT (IPv6 compatible)..."

# Use TCP6-LISTEN for IPv6 support (also accepts IPv4-mapped addresses)
socat TCP6-LISTEN:${TCP_PORT},reuseaddr,fork UNIX-CONNECT:${SOCKET_PATH} &
SOCAT_PID=$!

# Give socat a moment to start
sleep 2

# Verify socat is listening
if ! kill -0 $SOCAT_PID 2>/dev/null; then
    echo "WARNING: socat failed to start on port $TCP_PORT"
    echo "Cardano node is running but TCP proxy is not available"
    echo "Continuing with cardano-node only..."
    SOCAT_PID=""
else
    echo "TCP proxy is running on port $TCP_PORT"
    echo "You can now connect to the Cardano node socket via TCP at port $TCP_PORT"
fi

# Simple cleanup on exit
cleanup() {
    echo "Shutting down..."
    [ -n "${SOCAT_PID:-}" ] && kill $SOCAT_PID 2>/dev/null || true
    [ -n "${CARDANO_PID:-}" ] && kill $CARDANO_PID 2>/dev/null || true
    wait
}
trap cleanup EXIT

# Monitor processes
while true; do
    # Always check cardano-node
    kill -0 $CARDANO_PID 2>/dev/null || die "cardano-node died"
    
    # Only check socat if it was started successfully
    if [ -n "$SOCAT_PID" ]; then
        if ! kill -0 $SOCAT_PID 2>/dev/null; then
            echo "WARNING: socat proxy died - TCP access no longer available"
            SOCAT_PID=""
        fi
    fi
    
    sleep 5
done