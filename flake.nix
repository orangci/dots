{
  description = "orangc's dots";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:orxngc/nixvim";
    stylix.url = "github:danth/stylix";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    ags.url = "github:Aylur/ags";
    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ {
    nixpkgs,
    # nixpkgs-stable,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    host = "helicon";
    username = "orangc";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit host;
          # pkgs-stable = import nixpkgs-stable {
          #   inherit system;
          #   config.allowUnfree = true;
          # };
        };
        modules = [
          ./hosts/${host}/config.nix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users.${username} = import ./hosts/${host}/home.nix;
            };
          }
        ];
      };
    };
  };
}
