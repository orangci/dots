{
  config,
  lib,
  inputs,
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
    services.minecraft-servers = {
      enable = true;
      dataDir = "/var/lib/minecraft";
      eula = true;
    };
  };
}
