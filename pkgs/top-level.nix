{
  pkgs,
  mkPackage,
  callPackage,
  ...
}: {
  # packages that follow npins entries
  # they can be updated via npins
  ani-cli = mkPackage ./applications/misc/ani-cli;
  rat = mkPackage ./applications/misc/rat;
  rofi-calc-wayland = mkPackage ./applications/misc/rofi-plugins/rofi-calc-wayland;
  rofi-emoji-wayland = mkPackage ./applications/misc/rofi-plugins/rofi-emoji-wayland;

  # static packages
  # need manual intervention with each update
  cloneit = callPackage ./applications/misc/cloneit {};
  mov-cli = callPackage ./applications/misc/mov-cli {};
  mpv-history = callPackage ./applications/video/mpv/scripts/save-history {};
  mastodon-bird-ui = callPackage ./applications/social/mastodon-bird-ui {};
  headscale-ui = callPackage ./applications/networking/headscale-ui {};

  # patched packages
  # those packages usually follow nixpkgs, so they need neither pinning
  # nor manual intervention
  foot-transparent = callPackage ./applications/terminal-emulators/foot-transparent {};
  alejandra-no-ads = callPackage ./tools/nix/alejandra-no-ads {};
}
