{
  stdenv,
  fetchzip,
  lib,
}: let
  pname = "headscale-ui";
  version = "0-unstable-2024-02-24";
in
  stdenv.mkDerivation {
    inherit pname version;
    src = fetchzip {
      url = "https://github.com/gurucomputing/headscale-ui/releases/download/2024.02.24-beta-1/headscale-ui.zip";
      sha256 = "sha256-6SUgtSTFvJWNdsWz6AiOfUM9p33+8EhDwyqHX7O2+NQ=";
    };

    installPhase = ''
      mkdir -p $out/share/
      cp -r web/ $out/share/
    '';

    meta = {
      description = "A web frontend for the headscale Tailscale-compatible coordination server";
      homepage = "https://github.com/gurucomputing/headscale-ui";
      license = [lib.licenses.bsd3];
    };
  }
