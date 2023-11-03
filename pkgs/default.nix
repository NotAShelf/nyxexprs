{
  inputs,
  self,
  ...
}: {
  systems = ["x86_64-linux"];

  imports = [inputs.flake-parts.flakeModules.easyOverlay];

  perSystem = {
    config,
    system,
    pkgs,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    packages = let
      pins = import ../npins;
      mkPackage = path: {__functor = self: self.override;} // (pkgs.callPackage path {inherit pins;});
    in {
      # packages that follow npins entries
      # they can be updated via npins
      ani-cli = mkPackage ./ani-cli;
      rat = mkPackage ./rat;
      mov-cli = mkPackage ./mov-cli;

      # static packages
      # need manual intervention with each update
      cloneit = pkgs.callPackage ./cloneit {};
      reposilite-bin = pkgs.callPackage ./reposilite-bin {};

      # patched packages
      foot-transparent = pkgs.foot.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ../patches/0001-foot-transparent.patch
          ];
      });
    };
  };
}
