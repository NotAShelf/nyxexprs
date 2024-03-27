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
    rev = "a99434929ced7673087458d18c4f78ae8a4c962a";
    hash = "sha256-eUFGyFAI3aNW18ChRBsBhsKG6Lh+jxwUeScqCm2xagQ=";
  };

  patches = (prev.patches or []) ++ [./0001-fullscreen-transparency.patch];
  mesonFlags = (prev.mesonFlags or []) ++ ["-Dfullscreen_alpha=true"];

  meta = {
    mainProgram = "foot";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
