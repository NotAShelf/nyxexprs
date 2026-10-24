{
  # «https://github.com/notashelf/nyxexprs»
  description = "Personal package overlay for commonly used derivations";

  # This is so that you don't have to compile Alejandra unless you already
  # have it in the Nix store, which is unlikely.
  nixConfig = {
    extra-substituters = ["https://nyx.cachix.org"];
    extra-trusted-public-keys = ["nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE"];
  };

  outputs = {self, ...} @ args: let
    inputs = (import ./.tack) {overrides = args.tackOverrides or {};};
    inherit (inputs) nixpkgs;
    inherit (nixpkgs) lib;

    inherit (builtins) concatStringsSep match listToAttrs;
    inherit (lib.attrsets) genAttrs;
    inherit (lib.filesystem) packagesFromDirectoryRecursive;
    inherit (lib.customisation) callPackageWith;

    systems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = f:
      genAttrs systems (system:
        f {
          inherit system;
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        });

    date = concatStringsSep "-" (match "(.{4})(.{2})(.{2}).*" self.lastModifiedDate);

    mkPackages = pkgs: let
      system = pkgs.stdenv.hostPlatform.system;
      base = packagesFromDirectoryRecursive {
        callPackage = callPackageWith (pkgs // {inherit inputs date;});
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
        "licenseit"
        "mrc"
        "gcolor"
        "tailray"
        "nh"
        "gh-notify"
        "stash"
        "eh"
        "microfetch"

        # 3rd party packages
        "wiremix"
        "nil"
      ];

      mappedPkgs = listToAttrs (builtins.concatMap (input: let
        pkg = ((inputs.${input}.packages or {}).${system} or {}).default or null;
      in
        lib.optional (pkg != null) {
          name = input;
          value = pkg;
        })
      fromInputs);
    in
      base // mappedPkgs;
  in {
    packages = forAllSystems ({pkgs, ...}: mkPackages pkgs);

    overlays.default = _: mkPackages;

    # Formatter that traverses the entire tree and formats Nix files
    formatter = forAllSystems ({
      system,
      pkgs,
    }:
      pkgs.writeShellApplication {
        name = "nix3-fmt-wrapper";

        runtimeInputs = [
          self.packages.${system}.alejandra-custom
          pkgs.fd
          pkgs.deno
        ];

        text = ''
          fd "$@" -t f -e nix -x alejandra -q '{}'
          fd "$@" -t f -e md -x deno fmt '{}'
        '';
      });

    devShells = forAllSystems ({
      system,
      pkgs,
    }: {
      default = pkgs.mkShellNoCC {
        name = "nyxexprs";
        packages = [
          pkgs.tack

          # Also put the default formatter in the devshell
          self.formatter.${system}
        ];
      };
    });

    apps = forAllSystems ({pkgs, ...}: {
      update-pkgs = {
        type = "app";
        program = lib.getExe (
          pkgs.writeShellApplication {
            name = "update";
            text = ''
              nix-shell --show-trace "${nixpkgs.outPath}/maintainers/scripts/update.nix" \
                --argstr skip-prompt true \
                --arg predicate '(
                  let prefix = builtins.toPath ./pkgs; prefixLen = builtins.stringLength prefix;
                  in (_: p: p.meta ? position && (builtins.substring 0 prefixLen p.meta.position) == prefix)
                )'
            '';
          }
        );
      };
    });

    # In case I ever decide to use Hydra.
    hydraJobs = self.packages;
  };
}
