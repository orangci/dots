{ pkgs, lib, ... }:

let
  discord-py-self = pkgs.python314Packages.buildPythonPackage rec {
    pname = "discord.py-self";
    version = "2.1.0";

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = lib.fakeHash;
    };

    pyproject = true;

    build-system = [
      pkgs.python314Packages.setuptools
    ];

    dependencies = with pkgs.python314Packages; [
      aiohttp
      curl-cffi
      tzlocal
      discord-protos
      audioop-lts
    ];
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

  src = pkgs.fetchFromGitHub {
    owner = "misutesu-desu";
    repo = "MudaRemote";
    rev = "main";
    hash = lib.fakeHash;
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/

    install -Dm644 ${../modules/services/misc/mudaremote/presets.json} $out/presets.json
  '';

  passthru = {
    inherit python;
  };
}
