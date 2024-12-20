#!/usr/bin/env bash

# Define the log file
log_file="./test/cache/test_cmd.log"

# Get the current date and time
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")

# This script will log the settings it receives to a log file with the date and time
echo "Running $(basename "$0") script at: $current_datetime" >>"$log_file"

# Declare the associative array and deserialize the incoming settings string
echo "Incoming settings string: $1" >>"$log_file"
declare -A settings
while IFS='=' read -r key value; do
    settings["$key"]="$value"
done < <(echo "$1" | tr ';' '\n')

status="${settings["STATUS"]}"
echo "Getting a specific important key: STATUS=$status" >>"$log_file"

echo "All Settings:" >>"$log_file"
# Log the settings
for key in "${!settings[@]}"; do
    echo "  $key=${settings[$key]}" >>"$log_file"
    echo "  $key=${settings[$key]}" # ensuring output is not seen by calling script
done

echo 0
