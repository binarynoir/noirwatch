# NoirWatch

NoirWatch monitors specified websites for changes and sends notifications. It supports various notification methods including Pushover and native desktop notifications.

[![Support me on Buy Me a Coffee](https://img.shields.io/badge/Support%20me-Buy%20Me%20a%20Coffee-orange?style=for-the-badge&logo=buy-me-a-coffee)](https://buymeacoffee.com/binarynoir)
[![Support me on Ko-fi](https://img.shields.io/badge/Support%20me-Ko--fi-blue?style=for-the-badge&logo=ko-fi)](https://ko-fi.com/binarynoir)

## Features

- Monitor multiple websites for changes
- Send notifications via Pushover and native desktop notifications (macOS, Linux, Windows)
- Configurable check intervals
- Verbose logging with different log levels
- Background execution support
- Customizable configuration and URL list files

## Requirements

- Bash
- `curl` for fetching website content
- `sed` for HTML content normalization
- `xmllint` for HTML content normalization
- `md5sum` for change detection
- `jq` for JSON parsing (optional, for Pushover notifications)
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

NoirWatch uses a configuration file to store default settings. The default location is `~/.noirwatchrc`. You can initialize a configuration file with default settings using:

```bash
./noirwatch --init
```

## Options

### General Options

- `-h, --help`: Display the help message.
- `-V, --version`: Display the script version.

### Configuration and Initialization

- `-c, --config <config_file>`: Specify a custom configuration file.
- `-I, --init`: Initialize the configuration file.
- `-s, --show-config`: Show the configuration settings.
- `-S, --show-config-file`: Show the configuration file.

### URL Management

- `-f, --url-file <file>`: Specify a file containing a list of URLs to monitor.
- `-U, --list-urls`: List all watched URLs.
- `-C, --clean`: Delete all cached files.

### Execution Options

- `-i, --interval <minutes>`: Set the interval between checks (default is 15 minutes).
- `-t, --threshold <percentage>`: Set the threshold percentage for detecting changes (default: 0%).
- `[INT]<url>`: Specify a threshold for a specific URL. This overrides the global threshold setting.
- `-b, --background`: Run the script in the background.
- `-p, --pushover`: Send Pushover notifications.
- `-a, --api-token <token>`: Specify the API token for Pushover notifications.
- `-u, --user-key <key>`: Specify the user key for Pushover notifications.
- `-d, --desktop`: Send desktop notifications using AppleScript.

### Logging and Output

- `-v, --verbose`: Enable verbose output.
- `-l, --log`: Log the log file to the screen.
- `-o, --output <file>`: Specify a custom log file location.
- `-L, --log-level <level>`: Set the log level (FATAL, ERROR, WARN, INFO, DEBUG, TRACE).

### Process Management

- `-K, --killall`: Kill all running instances of the script.
- `-k, --kill <pid>`: Kill a specific instance of the script by PID.
- `-P, --list-pids`: List all running instances of the script.

## Instructions for Running the Tests

To run the tests for the `NoirWatch` script, follow these steps:

1. **Navigate to the Test Directory**:

   ```bash
   cd test
   ```

2. **Update the Test Configuration File:** Open the test_noirwatchrc file in your preferred text editor and ensure it contains the following configuration:

   ```bash
   # NoirWatch Configuration File
   CONFIG_FILE="./test_noirwatchrc"
   URL_FILE="./test_urls.txt"
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

3. **Update the Test URL File:** Open the test_urls.txt file in your preferred text editor and ensure it contains the following URLs

   ```bash
   http://example.com
   http://example.org
   ```

4. **Run the Test Script:**

   ```bash
   ./test_script.sh
   ```

5. **Clean Up Test Files (optional):**

   ```bash
   rm -f ./test_noirwatchrc ./test_urls.txt
   rm -rf ./test_cache
   rm -f ./test_noirwatch.log
   ```

## Releases

### Releasing new releases

- Update the changelog with new features and fixes
- Commit all changed files and create a pull request
- Run the the release script from the project repos root directory

```bash
./scripts/publish-release.md
```

### Manually Releasing new releases

- Create new GitHub release using the new version number as the "Tag version". Use the exact version number and include a prefix `v`
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
