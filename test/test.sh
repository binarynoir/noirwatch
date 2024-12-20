#!/usr/bin/env bash

# Test script for NoirWatch

# Configuration files
CONFIG_FILE="./test/test.json"
AUTOMATED_CONFIG_FILE="./test/test_automated.json"
LOG_FILE="./test/test.log"
CACHE_DIR="./test/cache"
NOIRWATCH_SCRIPT="../noirwatch"  # Path to the NoirWatch script

# Function to clean up the automated config file and other test artifacts
cleanup() {
    echo "Cleaning up..."
    rm -f "$AUTOMATED_CONFIG_FILE" "$LOG_FILE"
    rm -rf "$CACHE_DIR"
    echo "Cleanup complete."
}

# Trap to ensure cleanup happens on script exit
trap cleanup EXIT

# Check if the NoirWatch script exists
if [[ ! -f "$NOIRWATCH_SCRIPT" ]]; then
    echo "Error: NoirWatch script $NOIRWATCH_SCRIPT does not exist."
    exit 1
fi

# Check if the provided config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Configuration file $CONFIG_FILE does not exist."
    exit 1
fi

# Function to initialize the automated config file
initialize_automated_config() {
    echo "Initializing automated configuration file..."
    $NOIRWATCH_SCRIPT --init --config "$AUTOMATED_CONFIG_FILE" --force-init

    # Validate that the automated config file was created
    if [[ ! -f "$AUTOMATED_CONFIG_FILE" ]]; then
        echo "Error: Failed to create automated configuration file $AUTOMATED_CONFIG_FILE."
        exit 1
    fi
}

# Function to test log levels
test_log_levels() {
    local config_file=$1
    local levels=("ERROR" "WARN" "INFO" "DEBUG")
    for level in "${levels[@]}"; do
        echo "Testing log level: $level"
        $NOIRWATCH_SCRIPT --config "$config_file" --log-level "$level" --output "$LOG_FILE"
        if ! grep -q "\[$level\]" "$LOG_FILE"; then
            echo "Error: Log level $level not found in log file."
            exit 1
        fi
    done
}

# Function to test logging to screen and file
test_logging() {
    local config_file=$1
    echo "Testing logging to screen and file..."
    $NOIRWATCH_SCRIPT --config "$config_file" --log-level DEBUG --output "$LOG_FILE" --verbose
    if ! grep -q "DEBUG" "$LOG_FILE"; then
        echo "Error: DEBUG log not found in log file."
        exit 1
    fi
    $NOIRWATCH_SCRIPT --config "$config_file" --log-level INFO --log
}

# Function to test all CLI options
test_cli_options() {
    local config_file=$1
    echo "Testing CLI options..."
    $NOIRWATCH_SCRIPT --config "$config_file" --init --force-init
    $NOIRWATCH_SCRIPT --config "$config_file" --show-config
    $NOIRWATCH_SCRIPT --config "$config_file" --show-config-file
    $NOIRWATCH_SCRIPT --config "$config_file" --clean
    $NOIRWATCH_SCRIPT --config "$config_file" --cache-dir "$CACHE_DIR"
    $NOIRWATCH_SCRIPT --config "$config_file" --pushover --api-token "dummy_token" --user-key "dummy_key"
    $NOIRWATCH_SCRIPT --config "$config_file" --desktop
    $NOIRWATCH_SCRIPT --config "$config_file" --verbose
    $NOIRWATCH_SCRIPT --config "$config_file" --log
    $NOIRWATCH_SCRIPT --config "$config_file" --output "$LOG_FILE"
    $NOIRWATCH_SCRIPT --config "$config_file" --log-level DEBUG
    $NOIRWATCH_SCRIPT --config "$config_file" --url-file "$URL_FILE"
    $NOIRWATCH_SCRIPT --config "$config_file" --list-urls
    $NOIRWATCH_SCRIPT --config "$config_file" --interval 10
    $NOIRWATCH_SCRIPT --config "$config_file" --threshold 5
    $NOIRWATCH_SCRIPT --config "$config_file" --timeout 10
    $NOIRWATCH_SCRIPT --config "$config_file" --start
    sleep 5
    $NOIRWATCH_SCRIPT --config "$config_file" --status
    $NOIRWATCH_SCRIPT --config "$config_file" --stop
}

# Main script execution
if [[ "$1" == "provided" ]]; then
    CONFIG_FILE_TO_USE="$CONFIG_FILE"
elif [[ "$1" == "autogen" ]]; then
    CONFIG_FILE_TO_USE="$AUTOMATED_CONFIG_FILE"
    initialize_automated_config
else
    echo "Usage: $0 {provided|autogen}"
    exit 1
fi

# Run the NoirWatch script with the selected config file
echo "Running NoirWatch with $CONFIG_FILE_TO_USE..."
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --url-file "$URL_FILE" --log-level DEBUG --output "$LOG_FILE"

# Check log file for errors
echo "Checking log file for errors..."
if grep -q "ERROR" "$LOG_FILE"; then
    echo "Error: Errors found in log file."
    exit 1
fi

# Test log level functions
echo "Testing log level functions..."
test_log_levels "$CONFIG_FILE_TO_USE"

# Test logging to screen and file
test_logging "$CONFIG_FILE_TO_USE"

# Test all CLI options
test_cli_options "$CONFIG_FILE_TO_USE"

# Test cache management functions
echo "Testing cache management functions..."
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --clean
if [[ -d "$CACHE_DIR" ]]; then
    echo "Error: Cache directory was not deleted."
    exit 1
fi

# Test notification functions (mocked)
echo "Testing notification functions..."
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --desktop
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --pushover --api-token "dummy_token" --user-key "dummy_key"

# Test process management functions
echo "Testing process management functions..."
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --start
sleep 5
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --status
$NOIRWATCH_SCRIPT --config "$CONFIG_FILE_TO_USE" --stop

# Additional validation steps can be added here
# For example, checking specific log entries, output files, etc.

echo "All tests completed successfully."