{
  lib,
  stdenvNoCC,
  fetchurl,
  pins,
}: let
  pin = pins.ai-robots-txt;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "ai-robots-txt";
    inherit (pin) version;

    src = fetchurl {
      url = "https://github.com/ai-robots-txt/ai.robots.txt/releases/download/${finalAttrs.version}/robots.txt";
      hash = "sha256-i1ZD9aN7qzwUDMx9qhMxxi/HFwGsSONjpYe4twy1r5s=";
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      cp $src $out/share/robots.txt

      runHook postInstall
    '';

    meta = {
      description = "List of AI agents and robots to block";
      homepage = "https://github.com/ai-robots-txt/ai.robots.txt";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [NotAShelf];
      platforms = lib.platforms.all;
    };
  })
