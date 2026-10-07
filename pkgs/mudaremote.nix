{ pkgs, lib, ... }:

let
  discord-protos = pkgs.python314Packages.buildPythonPackage {
    pname = "discord-protos";
    version = "1.2.367";

    pyproject = true;
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/4f/39/67bc98d66993903ee95bd0c1ded0671d2064b87a48ce4eb08068f29ee478/discord_protos-1.2.367.tar.gz";
      hash = lib.fakeHash;
    };

    build-system = [
      pkgs.python314Packages.setuptools
    ];
  };

  discord-py-self = pkgs.python314Packages.buildPythonPackage {
    pname = "discord.py-self";
    version = "2.1.0";
    pyproject = true;
    doCheck = false;

    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/c7/37/0a319b6465183a01d245ecdae99d59503bad41ed1176cd7e6943306a5949/discord_py_self-2.1.0.tar.gz";
      hash = "sha256-m8bYdxHpNFeE8u0jyrvmPrqWcwCOW0YKol41RlcLzQc=";
    };

    build-system = [ pkgs.python314Packages.setuptools ];
    dependencies = with pkgs.python314Packages; [
      aiohttp
      audioop-lts
      aiodns
      brotli
      orjson
      curl-cffi
      tzlocal
      discord-protos
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
