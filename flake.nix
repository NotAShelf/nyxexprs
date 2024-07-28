{
  description = "A personal package overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs self;} {
      systems = import inputs.systems;
      imports = [flake-parts.flakeModules.easyOverlay];

      perSystem = {
        system,
        config,
        pkgs,
        lib,
        ...
      }: let
        inherit (builtins) concatStringsSep match;
        inherit (lib.attrsets) recursiveUpdate;
        inherit (lib.filesystem) packagesFromDirectoryRecursive;
        inherit (lib.customisation) callPackageWith;

        pins = import ./npins;
        date = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" self.lastModifiedDate);
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        overlayAttrs = config.packages;
        packages = packagesFromDirectoryRecursive {
          callPackage = callPackageWith (recursiveUpdate pkgs {inherit pins date;});
          directory = ./pkgs;
        };

        formatter = config.packages.alejandra-custom;
        devShells = {
          default = self.devShells.${system}.npins;
          npins = pkgs.mkShellNoCC {
            packages = [pkgs.npins];
          };
        };
      };
    };
}
