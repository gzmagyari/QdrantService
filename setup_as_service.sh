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

# Check if the service file already exists
if [ -f "$QDRANT_SERVICE_FILE" ]; then
    echo "Qdrant service is already set up. Exiting."
    exit 0
fi

# Ensure the directories exist
mkdir -p "$QDRANT_BASE_DIR"
mkdir -p "$QDRANT_STORAGE_DIR"

# Make the start.sh script executable
chmod +x "$QDRANT_START_SCRIPT"

# Make the stop.sh script executable
chmod +x "$QDRANT_STOP_SCRIPT"

# Create the qdrant.service file
cat << EOF > "$QDRANT_SERVICE_FILE"
[Unit]
Description=Qdrant Vector Search Engine
After=docker.service
Requires=docker.service

[Service]
Type=simple
ExecStart=$QDRANT_START_SCRIPT
ExecStop=$QDRANT_STOP_SCRIPT
Restart=always
User=root
WorkingDirectory=$QDRANT_BASE_DIR

# Resource Limits
LimitNOFILE=65535
LimitNPROC=65535

# Extend timeout for service start
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable qdrant

echo "Qdrant service has been set up."