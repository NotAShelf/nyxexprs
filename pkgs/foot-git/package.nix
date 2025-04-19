{
  lib,
  fetchFromGitea,
  foot,
  pins,
  date,
  ...
}:
foot.overrideAttrs (let
  pin = pins.foot;
in {
  pname = "foot-transparent";
  version = "0-unstable-${date}";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "foot";
    rev = pin.revision;
    sha256 = pin.hash;
  };

  meta = {
    description = "An auto-upgrading version of FOot to ensure we are always up to dates";
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
