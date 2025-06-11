{
  lib,
  fetchFromGitea,
  fuzzel,
  pins,
  date,
  ...
}:
fuzzel.overrideAttrs (let
  pin = pins.fuzzel;
in {
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
})
