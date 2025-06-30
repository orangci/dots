{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mapAttrs'
    nameValuePair
    filterAttrs
    ;

  cfg = config.modules.server.cloudflared;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) allModules;

  dynamicIngress = mapAttrs' (
    _: mod: nameValuePair mod.domain "http://localhost:${toString mod.port}"
  ) validModules;

in
{
  options.modules.server.cloudflared = {
    enable = mkEnableOption "Enable Cloudflared";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets."cloudflared/cert.pem".path = "/var/secrets/cloudflared/cert.pem";
    modules.common.sops.secrets."cloudflared/credentials.json".path =
      "/var/secrets/cloudflared/credentials.json";

    services.cloudflared = {
      enable = true;
      tunnels.homelab = {
        default = "http_status:404";
        certificateFile = config.modules.common.sops.secrets."cloudflared/cert.pem".path;
        credentialsFile = config.modules.common.sops.secrets."cloudflared/credentials.json".path;

        ingress = mkMerge [
          # { "example.orangc.net" = "http://localhost:8800"; }
          { "mc.orangc.net" = "tcp://localhost:${toString config.modules.server.minecraft.juniper.port}"; }
          dynamicIngress
        ];
      };
    };
  };
}
