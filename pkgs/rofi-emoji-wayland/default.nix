{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  cairo,
  glib,
  libnotify,
  rofi-wayland-unwrapped,
  wl-clipboard,
  wtype,
  pins,
  ...
}: let
  pin = pins.rofi-emoji;
in
  stdenv.mkDerivation {
    pname = "rofi-emoji-wayland";
    inherit (pin) version;

    src = fetchFromGitHub {
      inherit (pin.repository) owner repo;
      sha256 = pin.hash;
      rev = pin.revision;
    };

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      makeWrapper
    ];

    buildInputs = [
      cairo
      glib
      libnotify
      rofi-wayland-unwrapped
      wl-clipboard
      wtype
    ];

    patches = [
      ../../patches/0002-patch-plugin-dir.patch
    ];

    postPatch = ''
      patchShebangs clipboard-adapter.sh
    '';

    postFixup = ''
      chmod +x $out/share/rofi-emoji/clipboard-adapter.sh
      wrapProgram $out/share/rofi-emoji/clipboard-adapter.sh \
        --prefix PATH ":" ${lib.makeBinPath [libnotify wl-clipboard wtype]}
    '';

    meta = {
      description = "An emoji selector plugin for Rofi";
      homepage = "https://github.com/Mange/rofi-emoji";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [NotAShelf];
      platforms = lib.platforms.linux;
    };
  }
