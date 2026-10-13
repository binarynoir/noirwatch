# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- none

## [1.4.0] - 2026-10-13

### Fixed

- Changes were detected on the whole page, including scripts, styles and navigation, so any script or ad change could trigger a notification. Only the visible text is compared now
- On Linux and in Docker, HTML tags were never removed before comparing, because `sed -i ''` only works on macOS
- Redirects were not followed, so a site that redirects was compared using the redirect response
- The change percentage counted the two diff header lines as changes
- `bc` was needed for threshold checks but was not listed as a dependency; it is no longer used
- `--threshold` accepted values that are not numbers
- `UPDATED_CMD` logged an error when the command succeeded without printing anything
- Running with Bash 3.2, the macOS default, now prints a clear error instead of failing partway through
- `-v, --verbose` was rejected unless `-L, --log-level` was also given
- `--clean` deleted the default cache directory instead of the one set in the configuration file
- `--restart` did nothing when the service was stopped
- Stopping the service could take up to a full check interval; it now stops immediately
- Settings carried over from one URL to the next, so a URL without its own setting used the previous URL's value
- Pushover notifications were built with `eval`, so text in a notification could run as shell code; desktop notifications on macOS and Windows broke on quotes
- The Windows desktop notification opened a dialog that paused checks until it was closed; it is now a notification balloon
- Invalid intervals and timeouts are rejected with a clear error instead of being misread
- `--init` built the configuration file by pasting values into JSON, so a quote in a value made the file invalid
- The Brewfile used commands Homebrew does not support; it now lists the development dependencies

### Changed

- Saved page content uses a new format. The first check after upgrading saves a new baseline instead of sending a notification
- Only http and https URLs are fetched
- Fetch errors include the reason reported by curl
- `--status` exits with status 3 when the service is not running, so scripts can check it
- Configuration settings are no longer exported as environment variables to the commands NoirWatch runs; commands still receive the settings as their argument
- Unknown keys in the configuration file are ignored with a warning
- The Dockerfile builds from the local checkout, runs as an unprivileged user, and runs NoirWatch in the foreground so `docker logs` and `docker stop` work
- The systemd and launchd examples in the README run NoirWatch in the foreground; with `--start` the service manager restarted it in a loop

### Security

- The configuration file, log file and cache directory are created readable only by you
- Pushover keys no longer appear in the process list or in debug logs
- The cache directory is refused if it belongs to another user, is a system directory, or is your home directory or one above it
- A stale PID file can no longer make `--stop` signal an unrelated process

### Added

- An offline test suite, `test/test.sh`
- A GitHub Actions workflow that runs ShellCheck and the tests on Linux and macOS
- The release workflow runs the tests first and checks that the tag matches `VERSION`; the release script checks for a clean `main` branch and a changelog entry

## [1.3.4] - 2026-10-13

### Fixed

- README: the usage examples used `-f urls`, which force-reinitializes the configuration file, and `-b`, which is not an option. They now show watching the configuration file's URL list and `--start`, `--status` and `--stop`
- README and man page: the default configuration file is `~/.config/noirwatch.json`, not `noirwatch.conf`
- README and man page: the interval option is `-I, --interval`, takes values such as `90s` or `15m`, and defaults to 60 seconds; `-T, --timeout` now describes the request timeout
- README: the test instructions now match `test/test.sh` (`./test.sh provided` or `./test.sh autogen`)
- README: the service options named "AppName" instead of NoirWatch
- `--help`, README: `-d, --desktop` no longer says notifications use AppleScript; they work on macOS, Linux and Windows

### Added

- README: document `-E, --edit-config`, `-N, --repeat` and per-URL thresholds (`'[15]https://example.com'`)
- Man page: document `-v, --verbose` and `-L, --log-level`

## [1.3.3] - 2025-01-01

### Fixed

- Issue where script would not run

## [1.3.2] - 2024-12-30

### Fixed

- Minor variable protections

## [1.3.1] - 2024-12-20

### Added

- Dockerfile and related documentation

### Fixed

- shasum was missing in requirements check
- References to URL file removed

## [1.3.0] - 2024-12-20

### Added

- Command to edit configuration file
- Repeat URL check N times and exit
- Per-URL configuration via JSON configuration file
- Run a custom command on change detection

### Changed

- Configuration is now in JSON format
- Combined URL configuration with new JSON configuration format
- Intervals are now available in seconds, minutes, hours
- Dependencies now include timeout
- Desktop notification default is now false
- Reorganized code for maintainability and logic

### Removed

- Support for bash based configuration files
- Separate URL file

### Fixed

- Console logging formatting errors
- All paths are now normalized

## [1.2.1] - 2024-11-29

### Changed

- Output the app name in message that the app is running interactively

### Fixed

- Configuration file failing to load

## [1.2.0] - 2024-11-29

### Added

- Restart service command line option

### Changed

- Updated single character command line options for consistency
- Documentation to reflect all changes in the latest release

### Fixed

- Failure to remove PID file on service stop

## [1.1.2] - 2024-11-27

### Fixed

- URL validation failing
- Initialization of config uses old config for new settings file
- Not showing version info when displaying configuration

## [1.1.1] - 2024-11-26

### Fixed

- Help adjusted for timeout option

## [1.1.0] - 2024-11-26

### Added

- System name displayed in notifications using local host name
- System name configurable using `--system-name` `-n`

### Changed

- Cross platform CACHE_DIR path generation using system temporary path
- Cross platform CONFIG_FILE path generation using system configuration path
- Order of Pushover user key and api token
- Additional code reorganization

### Fixed

- Cross platform paths are normalization
- URL default location is empty
- Failing on --status and --stop

## [1.0.2] - 2024-11-23

### Added

- Fatal error messages
- Test configuration files
- Feature roadmap to README.md

### Fixed

- Test script updated to latest version of application.

## [1.0.1] - 2024-11-23

### Fixed

- Application hangs when no URLS provided.

## [1.0.0] - 2024-11-23

### Added

- Initial release
