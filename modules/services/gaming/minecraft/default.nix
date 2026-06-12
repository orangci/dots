{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf singleton mkEnableOption;
  cfg = config.modules.services.gaming.minecraft;
in
{
  imports = singleton inputs.nix-minecraft.nixosModules.minecraft-servers;
  options.modules.services.gaming.minecraft.enable = mkEnableOption "Enable minecraft";

  config = mkIf cfg.enable {
    modules.security.sops.secrets.minecraft-rcon-password.path = "/var/secrets/minecraft-rcon-password";
    environment.systemPackages = [pkgs.rconc pkgs.packwiz];
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/var/lib/minecraft";
      environmentFile = config.modules.security.sops.secrets.minecraft-rcon-password.path;
    };
  };
}
