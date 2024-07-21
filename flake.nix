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
  } @ inputs: let
    pins = import ./npins;
  in
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
        inherit (lib.filesystem) packagesFromDirectoryRecursive;
      in {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        overlayAttrs = config.packages;
        packages = packagesFromDirectoryRecursive {
          callPackage = lib.callPackageWith (pkgs // {inherit pins;});
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
