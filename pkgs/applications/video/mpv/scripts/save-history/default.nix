{
  lib,
  mpvScripts,
}:
mpvScripts.buildLua {
  pname = "save-history";
  version = "unstable-2024-03-18";

  src = builtins.filterSource (path: type: type != "directory" || (!lib.hasSuffix path ".nix")) ./.;

  meta = {
    description = "Save history of played files";
    homepage = "https://github.com/notashelf/nyxpkgs";
    maintainers = [lib.maintainers.NotAShelf];
  };
}
