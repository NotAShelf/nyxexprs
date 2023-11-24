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
      inherit (pkgs) callPackage foot;

      pins = import ../npins;
      mkPackage = path: {__functor = self: self.override;} // (callPackage path {inherit pins;});
    in {
      # packages that follow npins entries
      # they can be updated via npins
      ani-cli = mkPackage ./ani-cli;
      rat = mkPackage ./rat;
      mov-cli = mkPackage ./mov-cli;
      rofi-calc-wayland = mkPackage ./rofi-calc-wayland;
      rofi-emoji-wayland = mkPackage ./rofi-emoji-wayland;

      # static packages
      # need manual intervention with each update
      cloneit = callPackage ./cloneit {};
      headscale-ui = callPackage ./headscale-ui {};
      mastodon-bird-ui = callPackage ./mastodon-bird-ui {};
      reposilite-bin = callPackage ./reposilite-bin {};

      # patched packages
      foot-transparent = foot.overrideAttrs (prev: {
        mesonFlags = prev.mesonFlags ++ ["-Dfullscreen_alpha=true"];
        mainProgram = "foot";
        patches = (prev.patches or []) ++ [../patches/0001-foot-transparent.patch];
      });
    };
  };
}
