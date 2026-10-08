{ pkgs, ... }:

let
  discord-protos = pkgs.python3Packages.buildPythonPackage {
    pname = "discord-protos";
    version = "0.0.2";
    pyproject = true;

    src = pkgs.fetchPypi {
      pname = "discord-protos";
      version = "0.0.2";
      hash = "sha256-I5U6BfMr7ttAtwjsS0V1MKYZaknI110zeukoKipByZc=";
    };

    build-system = [ pkgs.python3Packages.setuptools ];
    dependencies = [ pkgs.python3Packages.protobuf ];
    pythonImportsCheck = [ "discord_protos" ];
    doCheck = false;
  };

  discord-py-self = pkgs.python3Packages.buildPythonPackage {
    pname = "discord.py-self";
    version = "2.1.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "dolfies";
      repo = "discord.py-self";
      tag = "v2.1.0";
      hash = "sha256-jVz3uGU+4E5Awbk6ZYAsXvEpClNHm2QN1RpBTIiQTpE=";
    };

    build-system = [ pkgs.python3Packages.setuptools ];
    dependencies = [
      pkgs.python314Packages.aiohttp
      pkgs.python314Packages.curl-cffi
      pkgs.python314Packages.tzlocal
      pkgs.python314Packages.audioop-lts
      discord-protos
    ];
    doCheck = false;
    pythonImportsCheck = [ "discord" ];
  };

  python = pkgs.python314.withPackages (ps: [
    discord-py-self
    ps.inquirer
    ps.keyring
    ps.requests
    ps.tkinter
  ]);

in
pkgs.stdenv.mkDerivation {
  pname = "mudaremote";
  version = "unstable";
  dontBuild = true;
  passthru = { inherit python; };

  src = pkgs.fetchFromGitHub {
    owner = "misutesu-desu";
    repo = "MudaRemote";
    rev = "main";
    hash = "sha256-eDvxTisMyoceScP8GubZQGmEFta7Ykmw0gi76zX9GUQ=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/

    install -Dm644 ${../modules/services/misc/mudaremote/presets.json} $out/presets.json
  '';
}
