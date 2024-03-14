{
  lib,
  fetchFromGitHub,
  # python
  python3,
  # runtime dependencies
  ffmpeg,
  fzf,
  mpv,
}:
python3.pkgs.buildPythonPackage {
  pname = "mov-cli";
  version = "2024-03-14-unstable";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = "620c46a4426cedda1b8cd4739c8ab3faeccae187";
    hash = "sha256-l2CwHbvtRZ+tktwF3+zJj4KM4tCN0sRf/o654FWs0C4=";
  };

  makeWrapperArgs = let
    binPath = lib.makeBinPath [
      ffmpeg
      fzf
      mpv
    ];
  in [
    "--prefix PATH : ${binPath}"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    click
    colorama
    httpx
    krfzf-py
    lxml
    poetry-core
    pycrypto
    setuptools
    six
    tldextract
    toml
    inquirer
    unidecode
  ];

  build-system = [
    python3.pkgs.setuptools-scm
  ];

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "httpx"
    "tldextract"
  ];

  meta = {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "A cli tool to browse and watch movies";
    license = lib.licenses.gpl3Only;
    mainProgram = "mov-cli";
  };
}
