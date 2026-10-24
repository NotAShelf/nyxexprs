{
  lib,
  inputs,
  date,
  fuzzel,
  ...
}:
fuzzel.overrideAttrs {
  pname = "fuzzel-git";
  version = "0-unstable-${date}";
  src = inputs.fuzzel;

  meta = {
    description = "Fuzzel app launcher, tracks latest git revision";
    mainProgram = "fuzzel";
    maintainers = with lib.maintainers; [NotAShelf];
  };
}
