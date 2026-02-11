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
    quickshell.url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

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
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      hjem,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "orangc";

      nixosMachine =
        { host }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              system
              host
              username
              ;
          };
          modules = [
            ./hosts/${host}/config.nix
            home-manager.nixosModules.home-manager
            hjem.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = {
                  inherit
                    inputs
                    system
                    host
                    username
                    ;
                };
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username} = import ./hosts/${host}/home.nix;
              };
            }
          ];
        };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      nixosConfigurations = {
        komashi = nixosMachine { host = "komashi"; };
        sirius = nixosMachine { host = "sirius"; };
        gensokyo = nixosMachine { host = "gensokyo"; };
      };
    };
}
