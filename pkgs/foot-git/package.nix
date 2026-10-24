{
  lib,
  foot,
  inputs,
  date,
  # Settings
  withAlphaPatch ? true,
  ...
}:
foot.overrideAttrs (oldAttrs: {
  pname = "foot-transparent";
  version = "0-unstable-${date}";

  src = inputs.foot;

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
