{
  description = "orangc's NixOS flake";
  inputs = {
    # unstable nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    # when raf writes documentation for hjem, we'll be switching from home-manager to hjem
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # unstable Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    # i don't know if i still want to be using stylix but we'll stick with it
    stylix.url = "github:danth/stylix";

    # ferris says hi!
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # quickshillin' it
    quickshell.url = "git+https://git.outfoxxed.me/quickshell/quickshell";

    # fancy nixy neovim
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # for modules.server.minecraft
    nix-minecraft = {
      url = "github:infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # widgets framework configurable in *python*!!
    ignis = {
      url = "github:ignis-sh/ignis";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # walker (we be walkin') written by a bald man
    walker.url = "github:abenz1267/walker";

    # for hoyoverse games like genshin and honkai
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";

    # for blocking gambling websites, porn, etc
    stevenBlackHosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # hjem is a rafware alternative to home-mananager
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    hjem-rum = {
      url = "github:snugnug/hjem-rum";
      inputs.nixpkgs.follows = "nixpkgs-small";
      inputs.hjem.follows = "hjem";
    };

    # copyparty is a file server that is awesome
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # so nix-index, nix-locate, and comma can work
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # all in one solution to a media server. for jellyfin, the *arr stack, et cetera
    nixflix = {
      url = "github:kiriwalawren/nixflix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for declarative DNS
    # why my fork? it supports cloudflare proxying
    dns-nix = {
      url = "git+https://git.orangc.net/c/dns.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # documentation generator. peak rafware
    ndg.url = "github:feel-co/ndg";

    # an extremely handsome and charming man is the maintainer of this cute little bot
    # hint: it's me, i'm the handsome man
    takina = {
      url = "git+https://git.orangc.net/c/takina";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      flakeSettings = {
        username = "orangc";
        domains = {
          primary = "orangc.net";
          secondary = "orang.ci";
          email = "orangc.net";
          tailnet = "cormorant-emperor.ts.net";
        };
      };

      lib = nixpkgs.lib.extend (
        final: _prev: {
          my = import ./lib {
            lib = final;
            inherit flakeSettings;
          };
        }
      );

      customPkgs = import ./pkgs {
        inherit
          inputs
          pkgs
          lib
          system
          flakeSettings
          ;
      };

      nixosMachine =
        { host }:
        lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              system
              host
              flakeSettings
              ;
          };
          modules = [
            ./hosts/${host}/config.nix
            home-manager.nixosModules.home-manager
            (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" flakeSettings.username ])
            # hjem.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    inputs
                    system
                    host
                    flakeSettings
                    ;
                };
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${flakeSettings.username} = import ./hosts/${host}/home.nix;
              };
            }
          ];
        };
    in
    {
      packages.${system} = customPkgs;
      formatter.${system} = pkgs.nixfmt;
      nixosConfigurations = {
        komashi = nixosMachine { host = "komashi"; };
        sirius = nixosMachine { host = "sirius"; };
        gensokyo = nixosMachine { host = "gensokyo"; };
      };
    };
}
