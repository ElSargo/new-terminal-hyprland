{
  description = "Dev shell the project";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, fenix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        rust = fenix.packages.${system}.complete.toolchain;
        rustPlatform = pkgs.makeRustPlatform {
          cargo = rust;
          rustc = rust;
        };
      in {
        nixpkgs.overlays = [ fenix.overlays.complete ];
        devShells.default = pkgs.mkShell {
          buildInputs = [ rust pkgs.lldb_9 pkgs.sccache pkgs.mold pkgs.clang ];
        };

        defaultPackage = rustPlatform.buildRustPackage {
          name = "new-termainl-hyprland";
          src = ./.;
          cargoSha256 = "sha256-q87uXENhyAKjy2VB5Il/BBPJIcjAbOsHsKQTPaGrzZc=";
          target = "x86_64-unknown-linux-gnu";
        };
      });
}

