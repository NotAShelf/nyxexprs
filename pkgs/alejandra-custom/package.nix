{
  lib,
  alejandra,
  ...
}:
alejandra.overrideAttrs (prev: {
  pname = "alejandra-custom";
  version = "0-unstable-2024-07-21";

  patches =
    (prev.patches or [])
    ++ [./0001-no-ads.patch];

  doCheck = false;

  meta = {
    description = "Custom build of Alejandra without ads & spaces around lists and attrsets";
    mainProgram = "alejandra";
    maintainers = [lib.maintainers.NotAShelf];
  };
})
