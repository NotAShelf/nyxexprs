{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
  pins,
}: let
  pin = pins.mov-cli;
in
  python3Packages.buildPythonPackage {
    format = "pyproject";
    pname = "mov-cli";
    inherit (pin) version;

    src = fetchFromGitHub {
      inherit (pin.repository) owner repo;
      sha256 = pin.hash;
      rev = pin.revision;
    };

    propagatedBuildInputs = with python3Packages; [
      poetry-core
      pycryptodome
      lxml
      six
      beautifulsoup4
      tldextract
      (httpx.overrideAttrs (_: {
        src = fetchFromGitHub {
          owner = "encode";
          repo = "httpx";
          rev = "refs/tags/0.26.0";
          hash = "sha256-qMMx1CYu2/yH4NRvZFzJOflAPIbcvMYJqU4r+chuzl0=";
        };
      }))
      (buildPythonPackage (let
        pname = "krfzf_py";
        version = "0.0.4";
      in {
        inherit pname version;
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-W0wpR1/HRrtYC3vqEwh+Jwkgwnfa49LCFIArOXaSPCE=";
        };
      }))
    ];

    meta = {
      homepage = "https://github.com/mov-cli/mov-cli";
      description = "A cli tool to browse and watch movies";
      license = lib.licenses.gpl3Only;
      mainProgram = "mov-cli";
    };
  }
