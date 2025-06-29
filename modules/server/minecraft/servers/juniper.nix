{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.minecraft.juniper;
  pkgs = import inputs.nixpkgs {
    system = config.nixpkgs.system;
    overlays = [ inputs.nix-minecraft.overlay ];
  };
in
{
  options.modules.server.minecraft.juniper.enable = mkEnableOption "Enable Juniper SMP server";

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = mkIf cfg.enable {
    services.minecraft-servers.servers.juniper = mkIf cfg.enable {
      enable = true;
      enableReload = true;
      package = pkgs.fabricServers.fabric-1_21_6;
    };
  };
}
