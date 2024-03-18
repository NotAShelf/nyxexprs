{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  rofi-wayland-unwrapped,
  libqalculate,
  glib,
  cairo,
  gobject-introspection,
  wrapGAppsHook,
  pins,
  ...
}: let
  pin = pins.rofi-calc;
in
  stdenv.mkDerivation {
    pname = "rofi-calc-wayland";
    inherit (pin) version;

    src = fetchFromGitHub {
      inherit (pin.repository) owner repo;
      sha256 = pin.hash;
      rev = pin.revision;
    };

    nativeBuildInputs = [
      autoreconfHook
      pkg-config
      gobject-introspection
      wrapGAppsHook
    ];

    buildInputs = [
      rofi-wayland-unwrapped
      libqalculate
      glib
      cairo
    ];

    patches = [
      ../../patches/0002-patch-plugin-dir.patch
    ];

    postPatch = ''
      sed "s|qalc_binary = \"qalc\"|qalc_binary = \"${libqalculate}/bin/qalc\"|" -i src/calc.c
    '';

    meta = with lib; {
      description = "Do live calculations in rofi!";
      homepage = "https://github.com/svenstaro/rofi-calc";
      license = licenses.mit;
      platforms = with platforms; linux;
    };
  }
