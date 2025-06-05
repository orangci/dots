{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.minecraft;
  pkgs = import inputs.nixpkgs {
    system = config.nixpkgs.system;
    overlays = [ inputs.nix-minecraft.overlay ];
  };
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  options.modules.server.minecraft = {
    enable = mkEnableOption "Enable minecraft";
    juniper.enable = mkEnableOption "Enable Juniper SMP server";
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      dataDir = "/var/lib/minecraft";
      eula = true;
      servers.juniper = mkIf cfg.juniper.enable {
        enable = true;
        enableReload = true;
        package = pkgs.fabricServers.fabric-1_21_5;
      };
    };
  };
}
