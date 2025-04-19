{
  pins,
  lib,
  fetchFromGitHub,
  ani-cli,
  ...
}:
ani-cli.overrideAttrs (let
  pin = pins.ani-cli;
in {
  pname = "ani-cli";
  inherit (pin) version;

  src = fetchFromGitHub {
    inherit (pin.repository) owner repo;
    sha256 = pin.hash;
    rev = pin.revision;
  };

  meta = {
    description = "An auto-upgrading version of ani-cli to ensure we are always up to date with scrapers";
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
