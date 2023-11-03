{
  fetchFromGitHub,
  makeWrapper,
  stdenvNoCC,
  lib,
  gnugrep,
  gnused,
  wget,
  fzf,
  mpv,
  aria2,
  pins,
}: let
  pin = pins.ani-cli;
in
  stdenvNoCC.mkDerivation {
    pname = "ani-cli";
    inherit (pin) version;

    src = fetchFromGitHub {
      inherit (pin.repository) owner repo;
      sha256 = pin.hash;
      rev = pin.revision;
    };

    nativeBuildInputs = [makeWrapper];

    installPhase = ''
      runHook preInstall
      install -Dm755 ani-cli $out/bin/ani-cli
      wrapProgram $out/bin/ani-cli \
        --prefix PATH : ${lib.makeBinPath [gnugrep gnused wget fzf mpv aria2]}
      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/pystardust/ani-cli";
      description = "A cli tool to browse and play anime";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [NotAShelf];
      platforms = platforms.unix;
    };
  }
