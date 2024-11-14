# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- none

## [1.3.1] - 2024-11-14

### Fixed

- An issue where a 0% change could send a notification

## [1.3.0] - 2024-11-14

### Added

- Check if config file already exists and prompt the user for verification
- Option to force replace the conf file
- Dependency validation check

### Changed

- Exit on config init
- Improved change algorithm

### Fixed

- Various typos that affected configuration and notifications
- Pushover error handling

### Security

- Removed Pushover key data logging for improved security

## [1.2.0] - 2024-11-14

### Changed

- Notification title is now "NoirWatch Alert"
- Reorganized notification code for reusability
- Removed TRACE level and refactored code to use DEBUG
- Resorted functions for maintainability

## [1.1.1] - 2024-11-13

### Changed

- Updated logging functions to work better cross platform and with older version of bash

## [1.1.0] - 2024-11-13

### Changed

- Renamed settings variables for clarity

## [1.0.1] - 2024-11-13

### Changed

- Renamed log to log_message for code clarity

## [1.0.0] - 2024-11-13

### Added

- Initial release
