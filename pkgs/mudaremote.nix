{ pkgs, ... }:

let
  # everything has to come from one python package set, or the wrong interpreter's
  # modules end up in the env
  ps = pkgs.python314Packages;

  discord-protos = ps.buildPythonPackage {
    pname = "discord-protos";
    version = "0.0.2";
    pyproject = true;

    src = pkgs.fetchPypi {
      pname = "discord-protos";
      version = "0.0.2";
      hash = "sha256-I5U6BfMr7ttAtwjsS0V1MKYZaknI110zeukoKipByZc=";
    };

    build-system = [ ps.setuptools ];
    dependencies = [ ps.protobuf ];
    pythonImportsCheck = [ "discord_protos" ];
    doCheck = false;
  };

  discord-py-self = ps.buildPythonPackage {
    pname = "discord.py-self";
    version = "2.1.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "dolfies";
      repo = "discord.py-self";
      tag = "v2.1.0";
      hash = "sha256-jVz3uGU+4E5Awbk6ZYAsXvEpClNHm2QN1RpBTIiQTpE=";
    };

    build-system = [ ps.setuptools ];
    dependencies = [
      ps.aiohttp
      ps.curl-cffi
      ps.tzlocal
      ps.audioop-lts
      discord-protos
    ];
    doCheck = false;
    pythonImportsCheck = [ "discord" ];
  };

  python = ps.python.withPackages (p: [
    discord-py-self
    p.inquirer
    p.keyring
    p.requests
    p.tkinter
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
    hash = "sha256-jDLv0Fyx4qocEc4YeqbGSiIZN7PMOSZZWgcufeCdm18=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/

    install -Dm644 ${../modules/services/misc/mudaremote/presets.json} $out/presets.json
  '';
}
