{
  lib,
  fetchFromGitea,
  foot,
  pins,
  date,
  # Settings
  withAlphaPatch ? true,
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
    # Bring back fullscreen transparency (i.e., fullscreen alpha)
    ++ (lib.optionals withAlphaPatch [
      # Taken with the explicit permission of Fazzi, thank you :)
      # <https://codeberg.org/fazzi/foot>
      ./patches/foot_fullscreen_alpha.patch
    ]);

  meta = {
    description = "An auto-upgrading version of Foot to ensure we are always up to dates";
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
