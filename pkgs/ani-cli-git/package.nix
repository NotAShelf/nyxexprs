{
  inputs,
  lib,
  ani-cli,
  ...
}:
ani-cli.overrideAttrs {
  pname = "ani-cli";
  version = inputs._meta.ani-cli.version;

  src = inputs.ani-cli;

  meta = {
    description = "An auto-upgrading version of ani-cli to ensure we are always up to date with scrapers";
    maintainers = with lib.maintainers; [NotAShelf];
  };
}
