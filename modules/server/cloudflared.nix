{
  config,
  lib,
  flakeSettings,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mapAttrs'
    nameValuePair
    filterAttrs
    mkOption
    types
    ;

  cfg = config.modules.server.cloudflared;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod:
    (mod ? enable && mod.enable)
    && lib.hasAttrByPath [ "cloudflared" "enable" ] mod
    && mod.cloudflared.enable
    && mod.subdomain != null
    && mod ? port
    && mod.port != null
  ) allModules;

  dynamicIngress = mapAttrs' (
    _: mod:
    nameValuePair "${mod.subdomain}.${flakeSettings.domains.primary}" "http://localhost:${toString mod.port}"
  ) validModules;

in
{
  options.modules.server.cloudflared = {
    enable = mkEnableOption "Enable Cloudflared";
    ingress = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Collect ingress entries from other modules";
    };
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
          cfg.ingress
          dynamicIngress
        ];
      };
    };
  };
}
