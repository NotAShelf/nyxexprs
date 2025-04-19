{
  lib,
  stdenvNoCC,
  fetchzip,
  pins,
}: let
  pin = pins.headscale-ui;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "headscale-ui";
    inherit (pin) version;

    src = fetchzip {
      url = "https://github.com/gurucomputing/headscale-ui/releases/download/${finalAttrs.version}/headscale-ui.zip";
      sha256 = "sha256-Autk8D9G1Ott2ahbgJ7mGZKDChsSDgfrOhnurNiIdsQ=";
    };

    installPhase = ''
      runHook preInstall

      ls -lah
      mkdir -p $out/share
      cp -rvf ./*  $out/share

      runHook postInstall
    '';

    meta = {
      description = "A web frontend for the headscale Tailscale-compatible coordination server";
      homepage = "https://github.com/gurucomputing/headscale-ui";
      license = [lib.licenses.bsd3];
      maintainers = with lib.maintainers; [NotAShelf];
    };
  })
