#!/usr/bin/env bash

# Test suite for NoirWatch
# Runs offline against a local HTTP server. Requires bash 4.3+, python3 and the NoirWatch dependencies.
# Usage: ./test/test.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="$SCRIPT_DIR/../noirwatch"
WORK_DIR="$(mktemp -d)"
CONFIG="$WORK_DIR/config.json"
CACHE="$WORK_DIR/cache"
SITE_DIR="$WORK_DIR/site"
PASSED=0
FAILED=0
SERVER_PID=""

# Function: Remove test artifacts and stop the web server
cleanup() {
    "$APP" -c "$CONFIG" -C "$CACHE" --stop >/dev/null 2>&1
    [[ -n "$SERVER_PID" ]] && kill "$SERVER_PID" 2>/dev/null
    rm -rf "$WORK_DIR"
}
trap cleanup EXIT

# Function: Run the app and capture its output and exit code
run() {
    OUTPUT=$("$APP" "$@" 2>&1 </dev/null)
    STATUS=$?
}

# Function: Record a passing or failing assertion
check() {
    local description="$1"
    shift
    if "$@"; then
        PASSED=$((PASSED + 1))
        printf "  ok   %s\n" "$description"
    else
        FAILED=$((FAILED + 1))
        printf "  FAIL %s\n" "$description"
        printf "       exit code: %s\n" "${STATUS:-n/a}"
        printf "%s\n" "${OUTPUT:-}" | sed 's/^/       | /' | head -20
    fi
}

status_is() { [[ "$STATUS" -eq "$1" ]]; }
output_has() { [[ "$OUTPUT" == *"$1"* ]]; }
output_lacks() { [[ "$OUTPUT" != *"$1"* ]]; }
json_true() { jq -e "$1" "$2" >/dev/null; }

# Function: Start a local web server for the test pages
start_server() {
    mkdir -p "$SITE_DIR"
    PORT=$(python3 -c 'import socket; s = socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1])')
    python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$SITE_DIR" >/dev/null 2>&1 &
    SERVER_PID=$!
    for _ in {1..50}; do
        curl -s "http://127.0.0.1:$PORT/" >/dev/null && return 0
        sleep 0.1
    done
    echo "Failed to start the test web server" >&2
    exit 1
}

# Function: Write a test page
write_page() {
    cat >"$SITE_DIR/page.html" <<EOF
<html><head><script>var token = "$2";</script></head>
<body><nav>Menu</nav><div class="heading">Headline</div><p>$1</p><div class="ad">Buy now $2</div></body></html>
EOF
}

# Function: Write a configuration file
write_config() {
    cat >"$CONFIG" <<EOF
{
    "configuration": {
        "CACHE_DIR": "$CACHE",
        "LOG_FILE": "$CACHE/noirwatch.log",
        "CHECK_INTERVAL": "1s",
        "TIMEOUT": "5s",
        "PUSHOVER_API_TOKEN": "secrettoken123",
        "PUSHOVER_USER_KEY": "secretuser456",
        "THRESHOLD": "0"$1
    },
    "urls": {
        "default": [
            { "NAME": "First", "URL": "http://127.0.0.1:$PORT/page.html", "UPDATED_CMD": "$WORK_DIR/on_change.sh" },
            { "URL": "http://127.0.0.1:$PORT/page.html?second" }
        ]
    }
}
EOF
}

start_server

# The command run on changes records each call so the test can count them
cat >"$WORK_DIR/on_change.sh" <<EOF
#!/usr/bin/env bash
echo "\$1" >>"$WORK_DIR/on_change.calls"
echo ok
EOF
chmod +x "$WORK_DIR/on_change.sh"

echo "Command line"
run --help
check "--help exits 0" status_is 0
check "--help shows usage" output_has "Usage:"
run --version
check "--version shows the version" output_has "version:"
run --bogus
check "unknown options are rejected" status_is 1
run --repeat abc
check "--repeat rejects non-numbers" status_is 1
run --threshold abc -C "$CACHE" -S
check "--threshold rejects non-numbers" status_is 1
run -C "$CACHE" --interval 5x -S
check "invalid intervals are rejected" status_is 1
run -C "$CACHE" -v -S
check "-v works without -L" status_is 0

echo "Safety checks"
run -C / -S
check "refuses / as the cache directory" status_is 1
run -C "$HOME" -S
check "refuses the home directory as the cache directory" status_is 1

echo "Configuration"
run --init -c "$WORK_DIR/init.json" -C "$CACHE"
check "--init creates a configuration file" status_is 0
check "the generated configuration is valid JSON" json_true '.urls.default | length == 2' "$WORK_DIR/init.json"
check "the configuration file is private" test "$(find "$WORK_DIR/init.json" -perm 600 | wc -l)" -eq 1
run --init -c "$WORK_DIR/init.json" -C "$CACHE"
check "--init without a terminal will not overwrite" status_is 1
run --init --force-init -n 'Quote " Host' -c "$WORK_DIR/init.json" -C "$CACHE"
check "--force-init overwrites" status_is 0
check "special characters are escaped in JSON" json_true '.configuration.SYSTEM_NAME == "Quote \" Host"' "$WORK_DIR/init.json"
echo '{ not json' >"$WORK_DIR/bad.json"
run -c "$WORK_DIR/bad.json" -C "$CACHE" -S
check "invalid JSON is reported" status_is 1
write_config ', "PATH": "/nowhere", "VERSION": "9.9.9"'
run -c "$CONFIG" -S
check "unknown keys are ignored with a warning" output_has "Ignoring unknown configuration key 'PATH'"
check "the app still runs with unknown keys" status_is 0
run -c "$CONFIG" -L DEBUG -S
check "debug logs mask secrets" output_lacks "secrettoken123"
run -c "$WORK_DIR/missing.json" -S
check "a missing --config file is reported" status_is 1

echo "Change detection"
write_config ""
write_page "First version" "a"
run -c "$CONFIG" -N 1
check "first check saves a baseline" status_is 0
check "first check does not report a change" output_lacks "has changed"
write_page "First version" "b"
run -c "$CONFIG" -N 1
check "script and ad changes are ignored" output_lacks "has changed"
write_page "Second version" "b"
run -c "$CONFIG" -N 1
check "a content change is reported" output_has "First has changed by"
check "the change command runs for the URL that sets it" test "$(wc -l <"$WORK_DIR/on_change.calls")" -eq 1
check "settings do not leak into the next URL" output_has "127.0.0.1:$PORT/page.html?second has changed"
check "the change command receives the settings" grep -q "CHANGED_PERCENT=" "$WORK_DIR/on_change.calls"
run -c "$CONFIG" -N 1
check "an unchanged page is not reported" output_lacks "has changed"
write_page "Third version" "b"
run -c "$CONFIG" -N 1 -H 101
check "changes below the threshold are not reported" output_lacks "has changed"
run -C "$CACHE" -N 1 "[0]http://127.0.0.1:$PORT/page.html"
check "URLs on the command line accept a threshold prefix" status_is 0
run -C "$CACHE" -N 1 "http://127.0.0.1:$PORT/missing.html"
check "fetch errors are logged" output_has "Failed to fetch"
run -C "$CACHE" -N 1 "file:///etc/passwd"
check "non-HTTP URLs are refused" output_has "Failed to fetch"

echo "Service management"
run -c "$CONFIG" --status
check "--status exits 3 when stopped" status_is 3
run -c "$CONFIG" --start
check "--start starts the service" status_is 0
run -c "$CONFIG" --status
check "--status exits 0 when running" status_is 0
run -c "$CONFIG" -N 1
check "a second instance is refused" status_is 1
run -c "$CONFIG" --clean
check "--clean refuses while the service runs" status_is 1
run -c "$CONFIG" --restart
check "--restart restarts the service" output_has "running in the background"
run -c "$CONFIG" --stop
check "--stop stops the service" output_has "service stopped"
check "--stop removes the PID file" test ! -f "$CACHE/noirwatch.pid"
run -c "$CONFIG" --clean
check "--clean deletes the cache" test ! -d "$CACHE"

printf "\n%d passed, %d failed\n" "$PASSED" "$FAILED"
[[ "$FAILED" -eq 0 ]]
