#!/usr/bin/env bash
# Test Script for NoirWatch
# Description: Tests all functionalities of the NoirWatch script, including logging.

# Path to the NoirWatch script
NOIRWATCHSCRIPT="../noirwatch"

# Test URLs
TEST_URL1="http://example.com"
TEST_URL2="https://httpbin.org/get"
TEST_URL3="[10]https://jsonplaceholder.typicode.com/posts/1"

# Configuration file for testing
TEST_CONFIG_FILE="./test_noirwatch.conf"

# URL file for testing
TEST_URL_FILE="./test_urls.conf"

# Function to run a test
run_test() {
    local description=$1
    local command=$2
    echo "Running test: $description"
    eval $command
    echo "Test completed: $description"
    echo "----------------------------------------"
}

# Initialize configuration
run_test "Initialize configuration" "$NOIRWATCHSCRIPT --init"

# Show help
run_test "Show help" "$NOIRWATCHSCRIPT --help"

# Show version
run_test "Show version" "$NOIRWATCHSCRIPT --version"

# Show configuration
run_test "Show configuration" "$NOIRWATCHSCRIPT --show-config"

# Show configuration file
run_test "Show configuration file" "$NOIRWATCHSCRIPT --show-config-file"

# List URLs
run_test "List URLs" "$NOIRWATCHSCRIPT --list-urls"

# Clean cache
run_test "Clean cache" "$NOIRWATCHSCRIPT --clean"

# Run in background
run_test "Run in background" "$NOIRWATCHSCRIPT --background"

# Send Pushover notification (requires valid API token and user key)
# run_test "Send Pushover notification" "$NOIRWATCHSCRIPT --pushover --api-token YOUR_API_TOKEN --user-key YOUR_USER_KEY"

# Send desktop notification (only on macOS)
# run_test "Send desktop notification" "$NOIRWATCHSCRIPT --desktop"

# Log to screen
run_test "Log to screen" "$NOIRWATCHSCRIPT --log"

# Set log level
run_test "Set log level to DEBUG" "$NOIRWATCHSCRIPT --log-level DEBUG"

# Kill all instances
run_test "Kill all instances" "$NOIRWATCHSCRIPT --killall"

# List PIDs
run_test "List PIDs" "$NOIRWATCHSCRIPT --list-pids"

# Kill specific PID (replace 12345 with an actual PID)
# run_test "Kill specific PID" "$NOIRWATCHSCRIPT --kill 12345"

# Run the main functionality
run_test "Run main functionality" "$NOIRWATCHSCRIPT $TEST_URL1 $TEST_URL2 $TEST_URL3"

# Test logging functions
run_test "Log FATAL message" "$NOIRWATCHSCRIPT --log-level FATAL && $NOIRWATCHSCRIPT --log"
run_test "Log ERROR message" "$NOIRWATCHSCRIPT --log-level ERROR && $NOIRWATCHSCRIPT --log"
run_test "Log WARN message" "$NOIRWATCHSCRIPT --log-level WARN && $NOIRWATCHSCRIPT --log"
run_test "Log INFO message" "$NOIRWATCHSCRIPT --log-level INFO && $NOIRWATCHSCRIPT --log"
run_test "Log DEBUG message" "$NOIRWATCHSCRIPT --log-level DEBUG && $NOIRWATCHSCRIPT --log"

# Clean up test files
rm -f $TEST_URL_FILE $TEST_CONFIG_FILE
rm -rf ./test_cache
rm -f ./test_noirwatch.log

echo "All tests completed."
