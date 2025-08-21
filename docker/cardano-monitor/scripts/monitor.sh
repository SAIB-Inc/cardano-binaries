#!/bin/bash

echo "Cardano Monitor starting..."
echo "Configuration:"
echo "  - Node Host: ${CARDANO_NODE_HOST}"
echo "  - TCP Port: ${CARDANO_NODE_TCP_PORT}"
echo "  - Network: ${NETWORK}"
echo "  - Ping Interval: ${PING_INTERVAL}s"

# Determine network magic
if [ "$NETWORK" = "mainnet" ]; then
    NETWORK_ARGS="--mainnet"
else
    # Default to preprod testnet magic 1
    NETWORK_ARGS="--testnet-magic 1"
fi

# Wait for cardano-node TCP service to be available
echo "Waiting for ${CARDANO_NODE_HOST}:${CARDANO_NODE_TCP_PORT} to become available..."
ATTEMPTS=0
while ! nc -w 1 ${CARDANO_NODE_HOST} ${CARDANO_NODE_TCP_PORT} < /dev/null 2>/dev/null; do
    ATTEMPTS=$((ATTEMPTS + 1))
    echo "Attempt $ATTEMPTS: Waiting for ${CARDANO_NODE_HOST}:${CARDANO_NODE_TCP_PORT}..."
    if [ $ATTEMPTS -eq 60 ]; then
        echo "ERROR: Cardano node not available after 120 seconds"
        exit 1
    fi
    sleep 2
done

echo "Cardano node TCP service is available!"

# Start socat bridge
echo "Starting socat bridge to create Unix socket..."
socat UNIX-LISTEN:${CARDANO_NODE_SOCKET_PATH},fork,reuseaddr TCP:${CARDANO_NODE_HOST}:${CARDANO_NODE_TCP_PORT} &
SOCAT_PID=$!

# Wait for socket to be created
echo "Waiting for Unix socket to be created..."
for i in $(seq 1 30); do
    if [ -S ${CARDANO_NODE_SOCKET_PATH} ]; then
        echo "Unix socket created successfully at ${CARDANO_NODE_SOCKET_PATH}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "ERROR: Unix socket not created after 60 seconds"
        exit 1
    fi
    sleep 2
done

# Function to restart socat if it dies
restart_socat() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): Socat bridge died, restarting..."
    socat UNIX-LISTEN:${CARDANO_NODE_SOCKET_PATH},fork,reuseaddr TCP:${CARDANO_NODE_HOST}:${CARDANO_NODE_TCP_PORT} &
    SOCAT_PID=$!
    sleep 3
}

# Function to calculate sync percentage
calculate_sync_percentage() {
    local tip_data="$1"
    
    # Extract slot and block numbers
    local slot=$(echo "$tip_data" | jq -r '.slot // 0')
    local block=$(echo "$tip_data" | jq -r '.block // 0')
    local sync_progress=$(echo "$tip_data" | jq -r '.syncProgress // "0"')
    
    # Handle sync progress
    if [[ "$sync_progress" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        # If sync_progress is already 100 or greater, it's already a percentage
        if (( $(echo "$sync_progress >= 100" | bc -l) )); then
            echo "${sync_progress}%"
        # If it's between 0 and 1 (decimal), convert to percentage
        elif (( $(echo "$sync_progress > 0 && $sync_progress < 1" | bc -l) )); then
            sync_percent=$(echo "$sync_progress * 100" | bc)
            echo "${sync_percent}%"
        # Otherwise, assume it's already a percentage
        else
            echo "${sync_progress}%"
        fi
    else
        echo "${sync_progress}%"
    fi
}

# Main monitoring loop
echo "Starting tip monitoring..."
CONSECUTIVE_FAILURES=0
MAX_FAILURES=5

# Latency statistics
LATENCY_COUNT=0
LATENCY_TOTAL=0
LATENCY_MIN=999999
LATENCY_MAX=0

while true; do
    # Check if socat is still running
    if ! kill -0 $SOCAT_PID 2>/dev/null; then
        restart_socat
    fi
    
    # Query blockchain tip with timing
    echo -n "$(date '+%Y-%m-%d %H:%M:%S'): Querying blockchain tip... "
    
    # Record start time in milliseconds
    START_TIME=$(date +%s%3N)
    
    if TIP_OUTPUT=$(cardano-cli query tip --socket-path ${CARDANO_NODE_SOCKET_PATH} ${NETWORK_ARGS} 2>&1); then
        # Record end time and calculate latency
        END_TIME=$(date +%s%3N)
        LATENCY=$((END_TIME - START_TIME))
        
        # Parse the output
        SLOT=$(echo "$TIP_OUTPUT" | jq -r '.slot // 0')
        BLOCK=$(echo "$TIP_OUTPUT" | jq -r '.block // 0')
        HASH=$(echo "$TIP_OUTPUT" | jq -r '.hash // "unknown"' | cut -c1-12)
        SYNC=$(calculate_sync_percentage "$TIP_OUTPUT")
        
        echo "OK | Slot: $SLOT | Block: $BLOCK | Hash: ${HASH}... | Sync: $SYNC | Latency: ${LATENCY}ms"
        
        # Update latency statistics
        LATENCY_COUNT=$((LATENCY_COUNT + 1))
        LATENCY_TOTAL=$((LATENCY_TOTAL + LATENCY))
        [ $LATENCY -lt $LATENCY_MIN ] && LATENCY_MIN=$LATENCY
        [ $LATENCY -gt $LATENCY_MAX ] && LATENCY_MAX=$LATENCY
        
        # Show statistics every 10 queries
        if [ $((LATENCY_COUNT % 10)) -eq 0 ]; then
            AVG_LATENCY=$((LATENCY_TOTAL / LATENCY_COUNT))
            echo "$(date '+%Y-%m-%d %H:%M:%S'): Latency Stats - Min: ${LATENCY_MIN}ms | Max: ${LATENCY_MAX}ms | Avg: ${AVG_LATENCY}ms | Samples: $LATENCY_COUNT"
        fi
        
        # Reset failure counter on success
        CONSECUTIVE_FAILURES=0
    else
        echo "FAILED"
        echo "Error output: $TIP_OUTPUT"
        
        CONSECUTIVE_FAILURES=$((CONSECUTIVE_FAILURES + 1))
        
        if [ $CONSECUTIVE_FAILURES -ge $MAX_FAILURES ]; then
            echo "ERROR: Failed to query tip $MAX_FAILURES times consecutively. Checking connection..."
            
            if ! nc -w 1 ${CARDANO_NODE_HOST} ${CARDANO_NODE_TCP_PORT} < /dev/null 2>/dev/null; then
                echo "ERROR: Lost connection to ${CARDANO_NODE_HOST}:${CARDANO_NODE_TCP_PORT}"
                echo "Exiting with error status"
                exit 1
            else
                echo "TCP connection is still alive, restarting socat bridge..."
                kill $SOCAT_PID 2>/dev/null
                restart_socat
                CONSECUTIVE_FAILURES=0
            fi
        fi
    fi
    
    sleep ${PING_INTERVAL}
done