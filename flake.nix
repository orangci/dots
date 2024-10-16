{
  description = "orangc's dots";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # nixvim = {
    #   url = "github:orxngc/nixvim";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    hyprpanel,
    ...
  }: let
    system = "x86_64-linux";
    host = "anacreon";
    username = "orangc";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."${username}@${host}" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          hyprpanel.overlay
        ];
      };
      extraSpecialArgs = {
        inherit system;
        inherit inputs;
        inherit username;
        inherit host;
      };
      modules = [./hosts/${host}/home.nix inputs.stylix.homeManagerModules.stylix];
    };
    nixosConfigurations."${host}" = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit system;
        inherit inputs;
        inherit username;
        inherit host;
      };
      modules = [
        ./hosts/${host}/config.nix
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
