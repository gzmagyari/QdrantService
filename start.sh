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

# Ensure the directories exist
mkdir -p "$QDRANT_BASE_DIR"
mkdir -p "$QDRANT_STORAGE_DIR"

# Start the Qdrant container in the background and log output
docker run -d -p 6333:6333 -v "$QDRANT_STORAGE_DIR:/qdrant/storage" qdrant/qdrant &> "$QDRANT_LOG_FILE" &

# Print message
echo "Qdrant is starting, logs can be found in $QDRANT_LOG_FILE"
