{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.server.minecraft;
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./servers
  ];
  options.modules.server.minecraft = {
    enable = mkEnableOption "Enable minecraft";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.minecraft-rcon-password.path = "/var/secrets/minecraft-rcon-password";
    environment.systemPackages = [ pkgs.rconc ];
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/var/lib/minecraft";
      environmentFile = config.modules.common.sops.secrets.minecraft-rcon-password.path;
    };
  };
}
