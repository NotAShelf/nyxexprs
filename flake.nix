{
  description = "A personal package overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-parts,
    self,
    ...
  } @ inputs: let
    pins = import ./npins;
  in
    flake-parts.lib.mkFlake {inherit inputs self;} {
      systems = ["x86_64-linux" "aarch64-linux"];
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

        formatter = pkgs.alejandra;
        devShells.default = with pkgs; mkShell {buildInputs = [npins];};
      };
    };
}
