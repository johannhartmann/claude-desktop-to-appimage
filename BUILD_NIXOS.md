# Building Claude Desktop AppImage on NixOS

This guide explains how to build the Claude Desktop AppImage on NixOS using the provided Nix flake.

## Prerequisites

- NixOS with flakes enabled
- Git

## Quick Start

1. Clone the repository:
```bash
git clone https://github.com/fsoft72/claude-desktop-to-appimage.git
cd claude-desktop-to-appimage
```

2. Enter the Nix development shell:
```bash
nix develop
```

3. Install required npm packages:
```bash
npm install -g asar electron
```

4. Download appimagetool:
```bash
mkdir -p tools
wget -O tools/appimagetool-x86_64.AppImage https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x tools/appimagetool-x86_64.AppImage
```

5. Build the AppImage:
```bash
# Build with bundled electron (recommended for portability)
./build-appimage.sh --appimagetool ./tools/appimagetool-x86_64.AppImage --bundle-electron

# Or build using system electron (smaller size)
./build-appimage.sh --appimagetool ./tools/appimagetool-x86_64.AppImage
```

6. The AppImage will be created in the build directory and copied to your current directory.

## Using the Nix Flake

The `flake.nix` provides all necessary dependencies:

- Node.js 24
- npm, yarn, pnpm
- p7zip (for extracting Windows installer)
- wget (for downloading)
- icoutils (for icon extraction)
- imagemagick (for icon conversion)

The flake also configures npm to use a local directory for global packages, avoiding permission issues common on NixOS.

## Troubleshooting

### SOURCE_DATE_EPOCH Error

If you encounter an error about `SOURCE_DATE_EPOCH` when building the AppImage:

```
FATAL ERROR:SOURCE_DATE_EPOCH and command line options can't be used at the same time to set timestamp(s)
```

Run appimagetool manually without this environment variable:

```bash
unset SOURCE_DATE_EPOCH
./tools/appimagetool-x86_64.AppImage /tmp/claude-build/ClaudeDesktop.AppDir ./Claude-Desktop-x86_64.AppImage
```

### npm Global Install Errors

The flake automatically configures npm to use `$PWD/.npm-global` for global packages. This avoids the read-only Nix store issue. If you still have problems:

```bash
export NPM_CONFIG_PREFIX="$PWD/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
```

### Missing Dependencies

All required dependencies are included in the flake. If something is missing, you can temporarily install it in the shell:

```bash
nix-shell -p packagename
```

### Build Script Can't Find appimagetool

The script expects appimagetool at a specific path. Always use the `--appimagetool` flag:

```bash
./build-appimage.sh --appimagetool ./tools/appimagetool-x86_64.AppImage
```

## Without Flakes

If you're not using flakes, create a shell.nix:

```nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_24
    nodePackages.npm
    p7zip
    wget
    icoutils
    imagemagick
    git
    curl
    file
    bash
  ];

  shellHook = ''
    export NPM_CONFIG_PREFIX="$PWD/.npm-global"
    export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
    mkdir -p "$NPM_CONFIG_PREFIX"
  '';
}
```

Then run:
```bash
nix-shell
```

## Build Options

The build script supports several options:

- `--bundle-electron`: Include Electron in the AppImage (recommended for compatibility)
- `--keep-installer`: Keep the Windows installer for faster rebuilds
- `--clean-cache`: Clean the download cache
- `--claude-download-url`: Use a custom download URL for Claude Desktop

## Output

The script will create an AppImage file named `Claude-Desktop-[VERSION]-x86_64.AppImage` in your current directory. This file is portable and should run on most Linux distributions.

## Notes

- The build process downloads the official Windows installer and extracts its resources
- A Linux-compatible native module is created to replace Windows-specific functionality
- The AppImage includes all necessary dependencies when built with `--bundle-electron`
- First build may take longer due to downloads; subsequent builds are faster with `--keep-installer`