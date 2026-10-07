{ pkgs, lib, ... }:

let
  discord-py-self = pkgs.python3Packages.buildPythonPackage {
    pname = "discord.py-self";
    version = "2.1.0";
    pyproject = true;

    src = pkgs.fetchPypi {
      pname = "discord.py-self";
      version = "2.1.0";
      hash = "sha256-I5U6BfMr7ttAtwjsS0V1MKYZaknI110zeukoKipByZc=";
    };

    build-system = [ pkgs.python3Packages.setuptools ];
    doCheck = false;
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
