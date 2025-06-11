{
  # «https://github.com/notashelf/nyxexprs»
  description = "Personal package overlay for commonly used derivations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Rest of my packages will be constructed from previous flakes
    watt = {
      url = "github:NotAShelf/watt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flint = {
      url = "github:NotAShelf/flint";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    inquisitor = {
      url = "github:NotAShelf/inquisitor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ndg = {
      url = "github:feel-co/ndg";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    licenseit = {
      url = "github:notashelf/licenseit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mrc = {
      url = "github:notashelf/mrc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wiremix = {
      url = "github:tsowell/wiremix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
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
        inputs',
        config,
        pkgs,
        lib,
        ...
      }: let
        inherit (builtins) concatStringsSep match listToAttrs;
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
        packages = let
          base = packagesFromDirectoryRecursive {
            callPackage = callPackageWith (recursiveUpdate pkgs {inherit pins date;});
            directory = ./pkgs;
          };

          # Borrowed diniamo/niqspkgs, with love <3
          # (and without useless pipe operators)
          fromInputs = [
            # My packages
            "watt"
            "flint"
            "inquisitor"
            "ndg"

            # 3rd party packages
            "wiremix"
          ];

          mappedPkgs = listToAttrs (map (input: {
              name = input;
              value = inputs'.${input}.packages.default;
            })
            fromInputs);
        in
          base // mappedPkgs;

        formatter = config.packages.alejandra-custom;
        devShells = {
          default = pkgs.mkShellNoCC {
            name = "nyxexprs";
            packages = [pkgs.npins];
          };
        };
      };
    };

  # This is so that you don't have to compile Alejandra.
  nixConfig = {
    extra-substituters = ["https://nyx.cachix.org"];
    extra-trusted-public-keys = ["nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE"];
  };
}
