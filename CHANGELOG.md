# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0] - 2025-06-16

### Added

- Enhanced build script with version display and additional window control fixes
- Implemented `--clean-cache` option to remove cache and build directories
- Introduced `--keep-installer` option to manage installer caching
- Added `maid.json` file for AI analysis

### Fixed

- Now the script search for '7zip' package instead of 'p7zip-full' to ensure compatibility with various distributions (thanks: @p-h-a-i-l)
- Fixed issue with Electron bundling even when `--bundle-electron` was 0
- Enhanced MainWindowPage detection and modified conditional logic in app.asar

## [0.1.1] - 2025-03-27

### Added

- Support for NVM-installed Electron in AppRun script
- Enhanced Electron detection and logging for troubleshooting
- Improved Electron path detection with user feedback for missing executable
- Support for custom Claude download URL in build script
- Command line argument support for appimagetool and help message
- Enhanced AppImage build script with command line arguments support
- .gitignore to exclude package files, node_modules, and build artifacts

### Changed

- Refactored AppImage build script to move output to current directory and clean up build artifacts
- Updated README to include command line arguments documentation

### Fixed

- Corrected appimagetool installation logic (exit was too early) - contributed by @cyrillkuettel
- Ensured --no-sandbox option is used in AppRun script

## [0.1.0] - 2025-03-22

### Added

- Initial project setup and first commit

---

## Contributors

- **Fabio Rotondo** (@fsoft72) - Project creator and main contributor
- **cyrillkuettel** (@cyrillkuettel) - Bug fixes and improvements
