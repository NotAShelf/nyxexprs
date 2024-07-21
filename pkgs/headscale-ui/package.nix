{
  stdenvNoCC,
  fetchzip,
  lib,
}: let
  pname = "headscale-ui";
  version = "0-unstable-2024-02-24";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;
    src = fetchzip {
      url = "https://github.com/gurucomputing/headscale-ui/releases/download/2024.02.24-beta1/headscale-ui.zip";
      sha256 = "sha256-HHzxGlAtVXs0jfNJ/khbNA/aQsGKvii1Hm+8hlJQYYY=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share
      cp -r ./* $out/share
      runHook postInstall
    '';

    meta = {
      description = "A web frontend for the headscale Tailscale-compatible coordination server";
      homepage = "https://github.com/gurucomputing/headscale-ui";
      license = [lib.licenses.bsd3];
    };
  }
