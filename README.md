# NoirWatch

NoirWatch monitors specified websites for changes and sends notifications. It supports various notification methods including Pushover and native desktop notifications.

[![Support me on Buy Me a Coffee](https://img.shields.io/badge/Support%20me-Buy%20Me%20a%20Coffee-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/binarynoir)
[![Support me on Ko-fi](https://img.shields.io/badge/Support%20me-Ko--fi-blue?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/binarynoir)

## Features

- Monitor multiple websites for changes
- Send notifications via Pushover and native desktop notifications (macOS, Linux, Windows)
- Configurable check intervals
- Verbose logging with different log levels
- Run as a background service
- Customizable configuration and URL list files

## Feature Roadmap

- [x] Monitor multiple websites for changes
- [x] Send notifications via Pushover
- [x] Send notifications via native desktop notifications (macOS, Linux, Windows)
- [x] Run as a background service
- [ ] Run the check a specific number of times and then exit
- [ ] Output change averages for all urls
- [ ] Add averages to notifications
- [ ] Full historical average change report

## Requirements

- Bash
- `curl` for fetching website content
- `sed` for HTML content normalization
- `xmllint` for HTML content normalization
- `powershell` for Windows desktop notifications
- `notify-send` for Linux desktop notifications

## Installation

### macOS Using Homebrew

1. Tap the repository (if not already tapped):

   ```bash
   brew tap binarynoir/noirwatch
   ```

2. Install NoirWatch:

   ```bash
   brew install noirwatch
   ```

### Manual Installation (Linux/macOS Only)

1. Clone the repository:

   ```bash
   git clone https://github.com/binarynoir/noirwatch.git
   cd noirwatch
   ```

2. Make the script executable:

   ```bash
   chmod +x noirwatch
   ```

3. Install `notify-send` for desktop notifications (if not already installed) on Linux:

   ```bash
   # On Debian/Ubuntu-based systems
   sudo apt install libnotify-bin

   # On Fedora-based systems
   sudo dnf install libnotify

   # On Arch-based systems
   sudo pacman -S libnotify
   ```

### Windows Installation

1. Install [Git for Windows](https://gitforwindows.org/) (includes Git Bash, if not installed).

2. Clone the repository:

   ```bash
   git clone https://github.com/binarynoir/noirwatch.git
   cd noirwatch
   ```

3. Make the script executable (in Git Bash or similar terminal):

   ```bash
   chmod +x noirwatch
   ```

4. Ensure PowerShell is enabled in your Git Bash environment for notifications.

### Installing the Man Page (Linux/macOS Only)

1. Move the man file to the appropriate directory:

   ```bash
   sudo mv noirwatch.1 /usr/local/share/man/man1/
   ```

2. Update the man database:

   ```bash
   sudo mandb
   ```

3. View the man page:

   ```bash
   man noirwatch
   ```

## Setting Up as a Service

### Linux

1. Create a systemd service file:

   ```bash
   sudo nano /etc/systemd/system/noirwatch.service
   ```

2. Add the following content to the service file:

   ```ini
   [Unit]
   Description=NoirWatch Service
   After=network.target

   [Service]
   ExecStart=/path/to/noirwatch --start
   WorkingDirectory=/path/to
   StandardOutput=syslog
   StandardError=syslog
   Restart=always
   User=your-username

   [Install]
   WantedBy=multi-user.target
   ```

   Replace `/path/to/noirwatch` with the actual path to the `noirwatch` script and `your-username` with your actual username.

3. Reload systemd to apply the new service:

   ```bash
   sudo systemctl daemon-reload
   ```

4. Enable the service to start on boot:

   ```bash
   sudo systemctl enable noirwatch
   ```

5. Start the service:

   ```bash
   sudo systemctl start noirwatch
   ```

6. Check the status of the service:

   ```bash
   sudo systemctl status noirwatch
   ```

### macOS

1. Create a launchd plist file:

   ```bash
   sudo nano /Library/LaunchDaemons/com.noirwatch.plist
   ```

2. Add the following content to the plist file:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>Label</key>
       <string>com.noirwatch</string>
       <key>ProgramArguments</key>
       <array>
           <string>/path/to/noirwatch</string>
           <string>--start</string>
       </array>
       <key>WorkingDirectory</key>
       <string>/path/to</string>
       <key>RunAtLoad</key>
       <true/>
       <key>KeepAlive</key>
       <true/>
       <key>StandardOutPath</key>
       <string>/var/log/noirwatch.log</string>
       <key>StandardErrorPath</key>
       <string>/var/log/noirwatch.log</string>
   </dict>
   </plist>
   ```

   Replace `/path/to/noirwatch` with the actual path to the `noirwatch` script.

3. Load the plist file to start the service:

   ```bash
   sudo launchctl load /Library/LaunchDaemons/com.noirwatch.plist
   ```

4. Check the status of the service:

   ```bash
   sudo launchctl list | grep com.noirwatch
   ```

5. To unload the service:

   ```bash
   sudo launchctl unload /Library/LaunchDaemons/com.noirwatch.plist
   ```

### Setting Up NoirWatch as a Service on Windows

1. **Create a Task in Task Scheduler**:

   - Open Task Scheduler and select "Create Task".
   - In the "General" tab, name the task "NoirWatch" and select "Run whether user is logged on or not".
   - In the "Triggers" tab, click "New" and set the trigger to "At startup".
   - In the "Actions" tab, click "New" and set the action to "Start a program".
     - In the "Program/script" field, enter the path to `bash.exe` (usually located in `C:\Program Files\Git\bin\bash.exe` if using Git Bash).
     - In the "Add arguments (optional)" field, enter the path to the `noirwatch` script and the `--start` argument, e.g., `/path/to/noirwatch --start`.
   - In the "Conditions" tab, uncheck "Start the task only if the computer is on AC power" to ensure it runs on battery power as well.
   - In the "Settings" tab, ensure "Allow task to be run on demand" is checked.

2. **Save and Test the Task**:

   - Click "OK" to save the task.
   - To test the task, right-click on the "NoirWatch" task in Task Scheduler and select "Run".

3. **Verify the Task**:

   - Check the status of the task in Task Scheduler to ensure it is running.
   - Verify that NoirWatch is running by checking the log file or the expected notifications.

## Usage

Run the script with the desired options. Below are some examples:

- Monitor a single URL:

  ```bash
  ./noirwatch https://example.com
  ```

- Monitor URLs from a file:

  ```bash
  ./noirwatch -f urls
  ```

- Run the script in the background:

  ```bash
  ./noirwatch -b https://example.com
  ```

- Send Pushover notifications:

  ```bash
  ./noirwatch -p -a YOUR_API_TOKEN -u YOUR_USER_KEY https://example.com
  ```

## Configuration

NoirWatch uses a configuration file to store default settings. The default location is `$HOME/.config/noirwatch.conf`. You can initialize a configuration file with default settings using:

```bash
./noirwatch --init
```

### Example Configuration File

```bash
# NoirWatch Configuration File
CACHE_DIR="/tmp/noirwatch_cache"
LOG_FILE="/tmp/noirwatch_cache/noirwatch.log"
CONFIG_FILE="$HOME/.config/noirwatch.conf"
URL_FILE="$HOME/.config/noirwatch_urls.conf"
CHECK_INTERVAL=15
TIMEOUT=5
PUSHOVER_NOTIFICATION=false
PUSHOVER_API_TOKEN=""
PUSHOVER_USER_KEY=""
DESKTOP_NOTIFICATION=true
VERBOSE=false
LOG_LEVEL="INFO"
THRESHOLD=0
```

## Options

### General Options

- `-h, --help`: Display the help message.
- `-V, --version`: Display the script version.

### Configuration and Initialization

- `-c, --config <config_file>`: Specify a custom configuration file.
- `-I, --init`: Initialize the configuration file.
- `-F, --force-init`: Force initialize the configuration file if one exists.
- `-s, --show-config`: Show the configuration settings.
- `-S, --show-config-file`: Show the configuration file.

### Cache Management

- `-C, --clean`: Delete all cached files.
- `-k, --cache-dir <path>`: Specify a custom cache directory.

### Notification Options

- `-p, --pushover`: Send Pushover notifications.
- `-a, --api-token <token>`: Specify the API token for Pushover notifications.
- `-u, --user-key <key>`: Specify the user key for Pushover notifications.
- `-d, --desktop`: Send desktop notifications using AppleScript.

### Logging and Output

- `-v, --verbose`: Enable verbose output.
- `-l, --log`: Log the log file to the screen.
- `-o, --output <file>`: Specify a custom log file location.
- `-L, --log-level <level>`: Set the log level (FATAL, ERROR, WARN, INFO, DEBUG).

### URL Management

- `-f, --url-file <file>`: Specify a file containing a list of URLs to monitor.
- `-U, --list-urls`: List all watched URLs.

### Network Check Configuration

- `-i, --interval <minutes>`: Set the interval between checks (default is 15 minutes).
- `-t, --threshold <percentage>`: Set the threshold percentage for detecting changes (default: 0%).
- `-T, --timeout <seconds>`: Set the timeout for ping and DNS tests (default: 5 seconds).

### Process Management

- `-r, --start`: Start the network check service in the background.
- `-t, --stop`: Stop the network check service.
- `-z, --status`: Check the current status of the network check service.

## Instructions for Running the Tests

To run the tests for the `NoirWatch` script, follow these steps:

### Prerequisites

Ensure you have the following installed on your system:

- Bash
- Git (for cloning the repository)

### Steps to Run the Tests

1. **Navigate to the Test Directory**:

   ```bash
   cd test
   ```

2. **Update the Test Configuration File:** Open the test_noirwatch.conf file in your preferred text editor and ensure it contains the following configuration:

   ```bash
   # NoirWatch Configuration File
   CONFIG_FILE="./test_noirwatch.conf"
   URL_FILE="./test_urls.conf"
   CACHE_DIR="./test_cache"
   LOG_FILE="./test_noirwatch.log"
   CHECK_INTERVAL=1
   THRESHOLD=1
   BACKGROUND=false
   PUSHOVER=false
   DESKTOP=false
   VERBOSE=true
   LOG_LEVEL="DEBUG"
   ```

3. **Update the Test URL File:** Open the test_urls.conf file in your preferred text editor and ensure it contains the following URLs:

   ```bash
   http://example.com
   http://example.org
   ```

4. **Make the test script executable**:

   ```bash
   chmod +x test.sh
   ```

5. **Run the Test Script:**

   ```bash
   ./test_script.sh
   ```

6. **Clean Up Test Files (optional):**

   ```bash
   rm -rf ./test_cache
   rm -f ./test_noirwatch.log
   ```

### Summary

The `test.sh` script will:

1. Create a test configuration file (default or custom).
2. Run various tests to check the functionality of NoirWatch, including configuration initialization, cache directory creation, log file creation, and website monitoring.
3. Clean up the test files and directories after the tests are completed, except for the custom configuration file if it was passed in.

Follow these instructions to ensure that NoirWatch is functioning correctly. If you encounter any issues, please open an issue or submit a pull request on the GitHub repository.

## Releases

### Releasing new releases

- Update the changelog with new features and fixes
- Commit all changed files and create a pull request
- Run the release script from the project repo's root directory

  ```bash
  ./scripts/publish-release.md
  ```

### Manually Releasing new releases

- Create a new GitHub release using the new version number as the "Tag version". Use the exact version number and include a prefix `v`
- Publish the release.

  ```bash
  git checkout main
  git pull
  git tag -a v1.y.z -m "v1.y.z"
  git push --tags
  ```

Run shasum on the release for homebrew distribution.

```bash
shasum -a 256 noirwatch-1.x.x.tar.gz
```

The release will automatically be drafted.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Author

John Smith III

## Acknowledgments

Thanks to all contributors and users for their support and feedback.
