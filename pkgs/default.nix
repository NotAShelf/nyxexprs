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

    packages = {
      ani-cli = pkgs.callPackage ./ani-cli {};
      rat = pkgs.callPackage ./rat {};
      mov-cli = pkgs.callPackage ./mov-cli {};
      reposilite-bin = pkgs.callPackage ./reposilite-bin {};
      cloneit = pkgs.callPackage ./cloneit {};

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
