{
  description = "Basic development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        go-overlay = final: prev: {
          go = prev.go.overrideAttrs (oldAttrs: rec {
            version = "1.22.1";
            src = final.fetchurl {
              url = "https://go.dev/dl/go${version}.src.tar.gz";
              hash = "sha256-ecm5HX8QlRWiX8Ps2q0SXWfmvbVPbU2YWA9GeZyuoyE=";
            };
          });
        };
        pkgs = nixpkgs.legacyPackages.${system}.extend go-overlay;
      in
        {
          devShells.default = pkgs.mkShell {
            shellHook = ''
            '';
            packages = with pkgs; [
              jdk
            ];
          };
        }
    );
}
