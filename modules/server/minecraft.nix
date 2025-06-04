{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.modules.server.minecraft;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  options.modules.server.minecraft = {
    enable = mkEnableOption "Enable minecraft";
    juniper.enable = mkEnableOption "Enable Juniper SMP server";
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      dataDir = "/var/lib/minecraft";
      eula = true;
      openFirewall = true;
      servers.juniper = mkIf cfg.juniper.enable {
        enable = true;
        enableReload = true;
        package = pkgs.fabricServers.fabric-1_21_5;
      };
    };
  };
}
