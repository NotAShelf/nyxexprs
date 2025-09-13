{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "headscale-ui";
  version = "2025.08.23";

  src = fetchzip {
    # https://github.com/gurucomputing/headscale-ui/releases/download/2025.08.23/headscale-ui.zip
    url = "https://github.com/gurucomputing/headscale-ui/releases/download/${finalAttrs.version}/headscale-ui.zip";
    hash = "sha256-66c4KC6tJath/A79idp4ypwd3y0VI80mG8/Gj/WwmnY=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp -rvf ./* $out/share/

    runHook postInstall
  '';

  meta = {
    description = "Web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = [lib.licenses.bsd3];
    maintainers = with lib.maintainers; [NotAShelf];
  };
})
