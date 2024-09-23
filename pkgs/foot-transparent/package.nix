{
  lib,
  fetchFromGitea,
  foot,
  pins,
  date,
  ...
}:
foot.overrideAttrs (prev: let
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

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    description = "Patched version of Foor terminal emulator that brings back fullscreen transparency";
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
