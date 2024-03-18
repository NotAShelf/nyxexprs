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
    rev = "dd3bb13d97b405495465357f7b7b17c9f2bba3c2";
    hash = "sha256-Pp3/cNELRYmTOQrJgHX6c+t0QkxEjoly0TLMKVj3H0E=";
  };

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
