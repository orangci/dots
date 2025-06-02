{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.it-tools;
in
{
  options.modules.server.it-tools.enable = mkEnableOption "Enable it-tools";

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "corentinth/it-tools:latest";
      ports = [ "9535:80" ];
      extraOptions = [ "--restart=unless-stopped" ];
    };
  };
}
