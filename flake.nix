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
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # i don't know if i still want to be using stylix but we'll stick with it
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs-small";
      inputs.home-manager.follows = "home-manager";
    };

    # ferris says hi!
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

    # my own quickshell rice coming soon!! maybe! (using end-4's currently)
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-small";
    };

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
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    username = "orangc";

    nixosMachine = {host}:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system host username;};
        modules = [
          ./hosts/${host}/config.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {inherit inputs system host username;};
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              users.${username} = import ./hosts/${host}/home.nix;
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      anacreon = nixosMachine {host = "anacreon";};
      helicon = nixosMachine {host = "helicon";};
      urithiru = nixosMachine {host = "urithiru";};
    };
  };
}
