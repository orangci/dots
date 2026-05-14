{
  config,
  lib,
  flakeSettings,
  ...
}:

let
  inherit (lib) types;
  cfg = config.modules.services.infrastructure.cloudflared;

  allModules = config.modules.services or { };
  validModules = lib.filterAttrs (
    _: mod:
    (mod ? enable && mod.enable)
    && lib.hasAttrByPath [ "cloudflared" "enable" ] mod
    && mod.cloudflared.enable
    && mod.subdomain != null
    && mod ? port
    && mod.port != null
  ) allModules;

  mkIngress =
    domain:
    lib.mapAttrs' (
      _: mod: lib.nameValuePair "${mod.subdomain}.${domain}" "http://localhost:${toString mod.port}"
    ) validModules;

  domains = lib.filter (d: d != "" && d != null) [
    flakeSettings.domains.primary
    flakeSettings.domains.secondary
  ];

in
{
  options.modules.services.infrastructure.cloudflared = {
    enable = lib.mkEnableOption "Enable Cloudflared";
    ingress = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Collect ingress entries from other modules";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.security.sops.secrets."cloudflared/cert.pem".path = "/var/secrets/cloudflared/cert.pem";
    modules.security.sops.secrets."cloudflared/credentials.json".path =
      "/var/secrets/cloudflared/credentials.json";

    services.cloudflared = {
      enable = true;
      tunnels.homelab = {
        default = "http_status:404";
        certificateFile = config.modules.security.sops.secrets."cloudflared/cert.pem".path;
        credentialsFile = config.modules.security.sops.secrets."cloudflared/credentials.json".path;
        ingress = lib.mkMerge ((map mkIngress domains) ++ lib.singleton cfg.ingress);
      };
    };
  };
}
