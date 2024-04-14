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
    rev = "4fd26c251cd66029b8aab739ee2e77a6904b5bed";
    hash = "sha256-qgRnOWZWf+j2mi8OVBRZRUyf9vRDtjaAg1OlRv95skc=";
  };

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
