{
  pkgs,
  mkPackage,
  callPackage,
  ...
}: {
  /*
  packages that follow npins entries
  they can be updated via npins
  */
  ani-cli = mkPackage ./applications/misc/ani-cli;
  rat = mkPackage ./applications/misc/rat;
  rofi-calc-wayland = mkPackage ./applications/misc/rofi-calc-wayland;
  rofi-emoji-wayland = mkPackage ./applications/misc/rofi-emoji-wayland;

  /*
  static packages
  need manual intervention with each update
  */
  mov-cli = callPackage ./applications/misc/mov-cli {};
  cloneit = callPackage ./applications/misc/cloneit {};
  mastodon-bird-ui = callPackage ./applications/social/mastodon-bird-ui {};
  headscale-ui = callPackage ./applications/networking/headscale-ui {};
  reposilite-bin = callPackage ./applications/networking/reposilite-bin {
    javaJdk = pkgs.openjdk_headless;
  };

  # patched packages
  # those packages usually follow nixpkgs, so they need neither pinning
  # nor manual intervention
  foot-transparent = callPackage ./applications/terminal-emulators/foot-transparent {};
  alejandra-no-ads = callPackage ./tools/nix/alejandra-no-ads {};
}
