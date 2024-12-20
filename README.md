# NoirWatch

NoirWatch monitors specified websites for changes and sends notifications. It supports various notification methods including Pushover and native desktop notifications.

[![Support me on Buy Me a Coffee](https://img.shields.io/badge/Support%20me-Buy%20Me%20a%20Coffee-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/binarynoir)
[![Support me on Ko-fi](https://img.shields.io/badge/Support%20me-Ko--fi-blue?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/binarynoir)
[![Visit my website](https://img.shields.io/badge/Website-binarynoir.tech-8c8c8c?style=for-the-badge)](https://binarynoir.tech)

## Features

- Monitor multiple websites for changes
- Send notifications via Pushover and native desktop notifications (macOS, Linux, Windows)
- Configurable check intervals
- Verbose logging with different log levels
- Background execution support
- Customizable configuration and URL list files

## Feature Roadmap

- [x] Monitor multiple websites for changes
- [x] Send notifications via Pushover
- [x] Send notifications via native desktop notifications (macOS, Linux, Windows)
- [x] Run as a background service
- [x] Run a custom script on change detection
- [x] Run the check a specific number of times and then exit
- [x] Robust configuration using JSON which includes per URL options
- [ ] Output change averages for all urls
- [ ] Add averages to notifications
- [ ] Full historical average change report
- [ ] Add more notification methods (email, slack, discord, teams, Telegram etc.)

## Requirements

- Bash 4.0+
- `curl` for fetching website content
- `sed` for HTML content normalization
- `shasum` for change comparisons
- `timeout` for custom command files
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

NoirWatch uses a configuration file to store default settings. The default location is `~/.config/noirwatch.conf`. You can initialize a configuration file with default settings using:

```bash
./noirwatch --init
```

### Example Configuration File

```json
{
	"configuration": {
		"CACHE_DIR": "/tmp/noirwatch_cache",
		"LOG_FILE": "/tmp/noirwatch_cache/noirwatch.log",
		"CHECK_INTERVAL": "60s",
		"TIMEOUT": "5s",
		"SYSTEM_NAME": "Test System",
		"PUSHOVER_NOTIFICATION": "false",
		"PUSHOVER_USER_KEY": "",
		"PUSHOVER_API_TOKEN": "",
		"DESKTOP_NOTIFICATION": "false",
		"VERBOSE": "true",
		"LOG_LEVEL": "DEBUG",
		"THRESHOLD": "0"
	},
	"urls": {
		"default": [
			{
				"NAME": "Apple Newsroom",
				"URL": "https://www.apple.com/newsroom/",
				"TIMEOUT": "5s",
				"THRESHOLD": "1",
				"UPDATED_CMD": "./test/test_cmd.sh",
				"CMD_TIMEOUT": "5s"
			},
			{
				"NAME": "9to5mac Homepage",
				"URL": "https://9to5mac.com",
				"TIMEOUT": "10s",
				"THRESHOLD": "5",
				"UPDATED_CMD": "./test/test_cmd.sh",
				"CMD_TIMEOUT": "5s"
			}
		]
	}
}
```

## Options

### General Options

- `-h, --help`: Display the help message.
- `-V, --version`: Display the script version.

### Configuration and Initialization

- `-c, --config <config_file>`: Specify a custom configuration file.
- `-i, --init`: Initialize the configuration file.
- `-f, --force-init`: Force initialize the configuration file if one exists.
- `-S, --show-config`: Show the configuration settings.
- `-e, --show-config-file`: Show the configuration file.

### Cache Management

- `-x, --clean`: Delete all cached files.
- `-C, --cache-dir <path>`: Specify a custom cache directory.

### Notification Options

- `-n, --system-name`: Name of the system running the script.
- `-p, --pushover`: Send Pushover notifications.
- `-u, --user-key <key>`: Specify the user key for Pushover notifications.
- `-a, --api-token <token>`: Specify the API token for Pushover notifications.
- `-d, --desktop`: Send desktop notifications using AppleScript.

### Logging and Output

- `-v, --verbose`: Enable verbose output.
- `-l, --log`: Log the log file to the screen.
- `-o, --output <file>`: Specify a custom log file location.
- `-L, --log-level <level>`: Set the log level (FATAL, ERROR, WARN, INFO, DEBUG).

### Remote Connection Configuration

- `-i, --interval <minutes>`: Set the interval between checks (default is 15 minutes).
- `-T, --timeout <seconds>`: Set the timeout for ping and DNS tests (default: 5 seconds).
- `-H, --threshold <percentage>`: Set the threshold percentage for detecting changes (default: 0%).
- `-U, --list-urls`: List all watched URLs.

### Process Management

- `-s, --start`: Start the AppName service in the background.
- `-k, --stop`: Stop the AppName service.
- `-r, --restart`: Restart the AppName service.
- `-t, --status`: Check the current status of the AppName service.

## Docker Deployment Instructions

This guide provides step-by-step instructions to deploy the NoirWatch service using Docker.

### Docker Prerequisites

Ensure you have the following installed on your system:

- Docker

### Using the Dockerfile

To download the `Dockerfile` from the GitHub repository, run the following command:

```sh
curl -O https://raw.githubusercontent.com/binarynoir/noirwatch/main/Dockerfile
```

### Build and Deploy

Navigate to the directory containing the `Dockerfile` and run the following command to build and start the service:

```sh
docker build -t noirwatch-image .
docker run -d --name noirwatch noirwatch-image
```

### Conclusion

You have successfully deployed the NoirWatch service using Docker. The service will automatically start when the container is created and will restart if it stops unexpectedly. For any further modifications or assistance, feel free to ask!

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

   ```json
   {
   	"configuration": {
   		"CACHE_DIR": "./test/cache",
   		"LOG_FILE": "./test/cache/noirwatch.log",
   		"CHECK_INTERVAL": "60s",
   		"TIMEOUT": "5s",
   		"SYSTEM_NAME": "Test System",
   		"PUSHOVER_NOTIFICATION": "false",
   		"PUSHOVER_USER_KEY": "",
   		"PUSHOVER_API_TOKEN": "",
   		"DESKTOP_NOTIFICATION": "false",
   		"VERBOSE": "true",
   		"LOG_LEVEL": "DEBUG",
   		"THRESHOLD": "0"
   	},
   	"urls": {
   		"default": [
   			{
   				"NAME": "Apple Newsroom",
   				"URL": "https://www.apple.com/newsroom/",
   				"TIMEOUT": "5s",
   				"THRESHOLD": "1",
   				"UPDATED_CMD": "./test/test_cmd.sh",
   				"CMD_TIMEOUT": "5s"
   			},
   			{
   				"NAME": "9to5mac Homepage",
   				"URL": "https://9to5mac.com",
   				"TIMEOUT": "10s",
   				"THRESHOLD": "5",
   				"UPDATED_CMD": "./test/test_cmd.sh",
   				"CMD_TIMEOUT": "5s"
   			}
   		]
   	}
   }
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
   ./test.sh
   ```

6. **Run the Test Script with a Custom Configuration File**:

   ```bash
   ./test.sh /path/to/custom_config_file
   ```

7. **Clean Up Test Files (optional)**:

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
