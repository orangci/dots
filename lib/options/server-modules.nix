{ lib, flakeSettings }:

{
  name ? null,
  port ? 8800,
  subdomain ? name,
  glanceIcon ? "sh:${lib.strings.replaceStrings [ " " ] [ "-" ] (lib.strings.toLower name)}",
}:

with lib;

{
  enable = mkEnableOption "Enable ${name}";

  glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
  cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
  internalTailscaleDomain.enable = mkEnableOption "Enable an internal tailnet domain for this service at ${subdomain}.${flakeSettings.domains.tailnet}";
  ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

  name = mkOption {
    type = types.str;
    default = name;
  };

  port = mkOption {
    type = types.port;
    default = port;
    description = "The port for ${name} to be hosted at";
  };

  subdomain = mkOption {
    type = types.str;
    default = strings.toLower subdomain;
    description = "The domain for ${name} to be hosted at";
  };

  glance.icon = mkOption {
    type = types.str;
    default = glanceIcon;
    description = "The icon for ${name} to be displayed in the Glance dashboard";
  };
}
