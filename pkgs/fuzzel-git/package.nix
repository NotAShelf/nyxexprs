{
  lib,
  pins,
  date,
  pixman,
  fetchurl,
  fetchFromGitea,
  fuzzel,
  ...
}: let
  # Latest fuzzel release requires Pixman >=0.46.1, but Nixpkgs still ships 0.42
  pixman_46 = pixman.overrideAttrs {
    pname = "pixman";
    version = "0.46.2";
    src = fetchurl {
      url = "https://cairographics.org/releases/pixman-0.46.2.tar.gz";
      hash = "sha256-Pg3lum41aRaUaj2VgZLxVQXcq4UTR3G/6rTOTim71zM=";
    };
  };
  pin = pins.fuzzel;
in
  (fuzzel.override {pixman = pixman_46;}).overrideAttrs {
    pname = "fuzzel-git";
    version = "0-unstable-${date}";
    src = fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "fuzzel";
      rev = pin.revision;
      sha256 = pin.hash;
    };

    meta = {
      description = "Fuzzel app launcher, tracks latest git revision";
      mainProgram = "fuzzel";
      maintainers = with lib.maintainers; [NotAShelf];
    };
  }
