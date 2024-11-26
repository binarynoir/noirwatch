# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- none

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
