{
  lib,
  fetchFromGitea,
  fcft,
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
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen-alpha=true"];
  nativeBuildInputs =
    (prev.nativeBuildInputs or [])
    ++ [
      (fcft.overrideAttrs {
        src = fetchFromGitea {
          domain = "codeberg.org";
          owner = "dnkl";
          repo = "fcft";
          tag = "3.3.1";
          hash = "sha256-qgNNowWQhiu6pr9bmWbBo3mHgdkmNpDHDBeTidk32SE=";
        };
      })
    ];

  meta = {
    description = "Patched version of Foor terminal emulator that brings back fullscreen transparency";
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
