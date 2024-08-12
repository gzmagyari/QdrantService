# Qdrant Service Setup

This project provides scripts to set up and manage Qdrant, a vector database, as a service on your system.

## Prerequisites

- Docker installed on your system
- Systemd-based Linux distribution (for service management)

## Configuration

Before setting up the Qdrant service, you need to configure the paths and settings. This is done through the `qdrant_config.conf` file.

1. Open `qdrant_config.conf` in a text editor.
2. Modify the values as needed. The default configuration is:

```
QDRANT_BASE_DIR=/root/QdrantService
QDRANT_STORAGE_DIR=${QDRANT_BASE_DIR}/storage
QDRANT_LOG_FILE=${QDRANT_BASE_DIR}/qdrant.log
QDRANT_SERVICE_FILE=/etc/systemd/system/qdrant.service
QDRANT_START_SCRIPT=${QDRANT_BASE_DIR}/start.sh
QDRANT_STOP_SCRIPT=${QDRANT_BASE_DIR}/stop.sh
```

3. Save the changes.

## Setup

To set up Qdrant as a service:

1. Ensure all files (`qdrant_config.conf`, `setup_as_service.sh`, `start.sh`, `stop.sh`) are in the same directory.
2. Make the setup script executable:
   ```
   chmod +x setup_as_service.sh
   ```
3. Run the setup script with root privileges:
   ```
   sudo ./setup_as_service.sh
   ```

This will create the necessary directories, set up the Qdrant service, and enable it to start on boot.

## Usage

### Using systemd (Recommended)

After setup, you can manage the Qdrant service using systemctl:

- Start the service: `sudo systemctl start qdrant`
- Stop the service: `sudo systemctl stop qdrant`
- Restart the service: `sudo systemctl restart qdrant`
- Check the status: `sudo systemctl status qdrant`

### Alternative: Using start.sh and stop.sh directly

If you encounter issues with the systemd service or prefer to run Qdrant manually, you can use the start.sh and stop.sh scripts directly:

1. Make the scripts executable (if not already):
   ```
   chmod +x start.sh stop.sh
   ```

2. To start Qdrant:
   ```
   sudo ./start.sh
   ```

3. To stop Qdrant:
   ```
   sudo ./stop.sh
   ```

Note: When using this method, Qdrant will not automatically start on system boot. You'll need to manually start it after each system restart.

## Logs

Qdrant logs are stored in the file specified by `QDRANT_LOG_FILE` in the configuration. By default, this is `/root/qdrantService/qdrant.log`.

## Customization

If you need to change any paths or settings after the initial setup:

1. Modify the `qdrant_config.conf` file.
2. If using the systemd service, run the `setup_as_service.sh` script again to apply the changes.
3. If using the scripts directly, the changes will take effect the next time you run start.sh.

## Troubleshooting

If you encounter any issues:

1. Check the Qdrant log file for error messages.
2. Ensure Docker is running and the Qdrant image is available.
3. Verify that all paths in the configuration file are correct and accessible.
4. If the systemd service is not working, try running Qdrant using the start.sh script directly to see if there are any error messages.

For more information about Qdrant, visit the [official Qdrant documentation](https://qdrant.tech/documentation/).

## License

This project is open-source and available under the [MIT License](LICENSE).
