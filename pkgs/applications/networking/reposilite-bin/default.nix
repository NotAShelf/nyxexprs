{
  lib,
  stdenvNoCC,
  makeWrapper,
  openjdk_headless,
  javaJdk ? openjdk_headless,
  maxMemory ? "40m",
  ...
}: let
  jdk = javaJdk;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "reposilite-bin";
    version = "3.5.10";
    src = builtins.fetchurl {
      url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${finalAttrs.version}/reposilite-${finalAttrs.version}-all.jar";
      sha256 = "1wqgy94sslg3jm2lzzzzl6m6x24q2z70dprl1si9mid6r74jxlh5";
    };

    nativeBuildInputs = [makeWrapper];

    phases = ["installPhase"];
    installPhase = ''
      runHook preInstall

      # wrap the reposilite jar with the JAVA_HOME environment variable and memory flags
      # maxMemory should be in megabytes. 40m is a reasonable defeat, but you may increase
      # it if you experience a higher load
      makeWrapper ${jdk}/bin/java $out/bin/reposilite \
        --set JAVA_HOME ${jdk.home} \
        --add-flags "-Xmx${maxMemory}m -jar $src/reposilite-${finalAttrs.version}-all.jar"

      runHook postInstall
    '';

    meta = {
      description = "A lightweight repository manager for Maven artifacts";
      homepage = "https://reposilite.com";
      license = lib.licenses.asl20;
      mainProgram = "reposilite";
      maintainers = with lib.maintainers; [NotAShelf];
    };
  })
