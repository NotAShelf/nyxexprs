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
    version = "3.5.3";

    jar = builtins.fetchurl {
      url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${finalAttrs.version}/reposilite-${finalAttrs.version}-all.jar";
      sha256 = "1wc12pwwmyxj6fhb1s9ql0s6sk2y4nx7kj1vkfjdrqwvwn2b19v6";
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
