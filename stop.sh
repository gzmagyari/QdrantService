#!/bin/bash

# Function to read the configuration file
read_config() {
    local config_file="$(dirname "$0")/qdrant_config.conf"
    if [ -f "$config_file" ]; then
        while IFS='=' read -r key value; do
            if [[ ! $key =~ ^# && -n $key ]]; then
                value=$(eval echo "$value")
                export "$key=$value"
            fi
        done < "$config_file"
    else
        echo "Configuration file not found: $config_file"
        exit 1
    fi
}

# Read the configuration
read_config

# Find the container ID or name running Qdrant
CONTAINER_ID=$(docker ps -q --filter "ancestor=qdrant/qdrant")

# Check if the container is running
if [ -z "$CONTAINER_ID" ]; then
    echo "No Qdrant container is running."
else
    # Stop the running Qdrant container
    docker stop $CONTAINER_ID
    echo "Qdrant container stopped."

    # Optionally remove the container
    docker rm $CONTAINER_ID
    echo "Qdrant container removed."
fi