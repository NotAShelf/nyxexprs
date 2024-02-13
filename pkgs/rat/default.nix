{
  pins,
  lib,
  disableHardening ? true,
  fetchFromGitHub,
  stdenv,
  unixtools,
}:
assert disableHardening -> lib.warn "nyxpkgs/rat disables hardening to avoid segfaults. You may want to consider overriding the package if this is undesirable" true; let
  pin = pins.rat;

  pname = "rat";
  version = "2.0.1";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      inherit (pin.repository) owner repo;
      sha256 = pin.hash;
      rev = pin.revision;
    };

    # the code is so unsafe, it doesn't work with even one of hardening flags
    # lol
    hardeningDisable = lib.optionals disableHardening ["all"];

    buildInputs = [unixtools.xxd];
    buildPhase = ''
      runHook preBuild
      make linux_audio
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -Dm755 ./bin/rat -t "$out/bin/"
      runHook postInstall
    '';

    meta = {
      description = "rat";
      homepage = "https://github.com/thinkingsand/rat";
      maintainers = with lib.maintainers; [NotAShelf];
    };
  }
