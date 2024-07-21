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
    rev = "aea16ba5d2896ef22bf0bea45e5e8142c0ff1c2a";
    hash = "sha256-CeDQriQIbyx3V1l719g3AuhnVVYYc63kA0BQpEFQ26A=";
  };

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
