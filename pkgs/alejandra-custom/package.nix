{
  lib,
  alejandra,
  ...
}:
alejandra.overrideAttrs (prev: {
  pname = "alejandra-custom";

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
