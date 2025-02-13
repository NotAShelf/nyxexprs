{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ai-robots-txt";
  version = "1.25";

  src = fetchurl {
    url = "https://github.com/ai-robots-txt/ai.robots.txt/releases/download/v${finalAttrs.version}/robots.txt";
    hash = "sha256-r4C+RDNpzfokBkvTG1v1D9gbu5zpC91+onQFYw05lZE=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp $src $out

    runHook postInstall
  '';

  meta = {
    description = "List of AI agents and robots to block";
    homepage = "https://github.com/ai-robots-txt/ai.robots.txt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [NotAShelf];
    platforms = lib.platforms.all;
  };
})
