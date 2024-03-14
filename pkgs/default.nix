{inputs, ...}: {
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
      inherit (pkgs) callPackage fetchFromGitea foot alejandra;
      pins = import ../npins;

      mkPackage = path: {__functor = self: self.override;} // (callPackage path {inherit pins;});
    in {
      /*
      packages that follow npins entries
      they can be updated via npins
      */
      ani-cli = mkPackage ./ani-cli;
      rat = mkPackage ./rat;
      rofi-calc-wayland = mkPackage ./rofi-calc-wayland;
      rofi-emoji-wayland = mkPackage ./rofi-emoji-wayland;

      /*
      static packages
      need manual intervention with each update
      */
      mov-cli = callPackage ./mov-cli {};
      cloneit = callPackage ./cloneit {};
      headscale-ui = callPackage ./headscale-ui {};
      mastodon-bird-ui = callPackage ./mastodon-bird-ui {};
      reposilite-bin = callPackage ./reposilite-bin {
        javaJdk = pkgs.openjdk_headless;
      };

      /*
      patched packages
      patches packages take a package from nixpkgs and patch it to suit my own needs
      */
      foot-transparent = foot.overrideAttrs (prev: let
        version = "2024-03-14-unstable";
      in {
        inherit version;
        src = fetchFromGitea {
          domain = "codeberg.org";
          owner = "dnkl";
          repo = "foot";
          rev = "dd3bb13d97b405495465357f7b7b17c9f2bba3c2";
          hash = "sha256-Pp3/cNELRYmTOQrJgHX6c+t0QkxEjoly0TLMKVj3H0E=";
        };

        patches = (prev.patches or []) ++ [../patches/0001-foot-transparent.patch];
        mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

        meta.mainProgram = "foot";
      });

      alejandra-no-ads = alejandra.overrideAttrs (prev: {
        patches = (prev.patches or []) ++ [../patches/0003-alejandra-remove-ads.patch];
      });

      # override gnome-control-center to trick it into thinking we're running gnome
      #  <https://github.com/NixOS/nixpkgs/issues/230493>
      #  <https://gitlab.gnome.org/GNOME/gnome-control-center/-/merge_requests/736>
      gccn-wrapped = pkgs.gnome.gnome-control-center.overrideAttrs (prev: {
        # gnome-control-center does not start without XDG_CURRENT_DESKTOP=gnome
        preFixup =
          ''
            gappsWrapperArgs+=(
              --set XDG_CURRENT_DESKTOP "gnome"
            );
          ''
          + prev.preFixup;
      });
    };
  };
}
