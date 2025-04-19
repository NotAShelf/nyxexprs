{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ai-robots-txt";
  version = "1.28";

  src = fetchurl {
    url = "https://github.com/ai-robots-txt/ai.robots.txt/releases/download/v${finalAttrs.version}/robots.txt";
    hash = "sha256-Cx01MI5Rss08lLgzwoppou0nqD0HxvfUbsa1NRVp8eQ=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share

    # Only copy relevant files
    cp .htaccess nginx-block-ai-bots.conf nginx-block-ai-bots.conf able-of-bot-metrics.md $out/share

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
