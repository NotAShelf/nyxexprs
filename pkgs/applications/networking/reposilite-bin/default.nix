{
  pkgs,
  lib,
  javaJdk,
  ...
}: let
  inherit (pkgs) stdenv;

  jdk = javaJdk;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "reposilite-bin";
    version = "3.5.8";

    jar = builtins.fetchurl {
      url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${finalAttrs.version}/reposilite-${finalAttrs.version}-all.jar";
      sha256 = "sha256:1skbbdfcbdhlhyrg1y1fimm87kq1ws6g5xy0sxaglgky9j218c0p";
    };

    dontUnpack = true;

    nativeBuildInputs = [pkgs.makeWrapper];
    installPhase = ''
      runHook preInstall
      makeWrapper ${jdk}/bin/java $out/bin/reposilite \
        --add-flags "-Xmx40m -jar $jar" \
        --set JAVA_HOME ${jdk}
      runHook postInstall
    '';

    meta = {
      description = "A lightweight repository manager for Maven artifacts";
      homepage = "https://reposilite.com";
      license = lib.licenses.asl20;
      mainProgram = "reposilite"; # we don't inherit pname here because it contains the -bin suffix, which the resulting binary won't have
      maintainers = with lib.maintainers; [NotAShelf];
    };
  })
