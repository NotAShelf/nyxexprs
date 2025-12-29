{
  lib,
  btop,
}:
btop.overrideAttrs {
  patches = [
    ./patches/normalize_processes.patch
  ];

  meta = {
    description = "Monitor of resources, with a patch to normalize process names on Nix";
    mainProgram = "btop";
    maintainers = [lib.maintainers.NotAShelf];
  };
}
