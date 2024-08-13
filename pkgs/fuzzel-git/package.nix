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
  pname = "foot-transparent";
  version = "0-${date}-unstable";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = pin.revision;
    sha256 = pin.hash;
  };

  meta = {
    description = "Patched version of Fuzzel app launcher that tracks latest git revision";
    mainProgram = "fuzzel";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
