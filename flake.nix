{
  description = "Claude Desktop to AppImage build environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_24
            nodePackages.pnpm
            nodePackages.npm
            nodePackages.yarn
            git
            curl
            wget
            p7zip
            file
            bash
            icoutils
            imagemagick
          ];

          shellHook = ''
            echo "Claude Desktop to AppImage development environment"
            echo "Node.js version: $(node --version)"
            echo "npm version: $(npm --version)"
            
            # Set npm prefix to a writable location
            export NPM_CONFIG_PREFIX="$PWD/.npm-global"
            export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
            
            # Ensure the directory exists
            mkdir -p "$NPM_CONFIG_PREFIX"
          '';
        };
      });
}