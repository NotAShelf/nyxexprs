{
  lib,
  fetchFromGitea,
  foot,
  ...
}:
foot.overrideAttrs (prev: let
  version = "2024-03-14-unstable";
in {
  inherit version;
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "foot";
    rev = "3a7ea1f44b5cac16c4d67cddb75c02638d59c55c";
    hash = "sha256-1kDm5XSFz4Q4lAcPkK8h4eJWzx7VDKqEHKjBDbbYhO0=";
  };

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
