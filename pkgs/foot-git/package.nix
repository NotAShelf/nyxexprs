{
  withAlphaPatch ? true,
  lib,
  fetchFromGitea,
  foot,
  pins,
  date,
  ...
}:
foot.overrideAttrs (oldAttrs: let
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

  patches =
    (oldAttrs.patches or [])
    ++ (lib.optionals withAlphaPatch [
      # Thank you fazzi :)
      # <https://codeberg.org/fazzi/foot/commit/bebc6f0ffd0d767f560ee50825a0b0fba197c90f.patch>
      ./patches/foot_fullscreen_alpha.patch
    ]);

  meta = {
    description = "An auto-upgrading version of FOot to ensure we are always up to dates";
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
