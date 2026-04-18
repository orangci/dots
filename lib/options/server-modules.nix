{ lib, flakeSettings }:

{
  name ? null,
  port ? 8800,
  subdomain ? name,
  glanceIcon ? "sh:${lib.strings.replaceStrings [ " " ] [ "-" ] (lib.strings.toLower name)}",
}:

with lib;

{
  enable = mkEnableOption "${name}";

  glance.enable = mkEnableOption "visibility for ${name} in the Glance dashboard";
  cloudflared.enable = mkEnableOption "Cloudflare Tunnelling for ${name}";
  internalTailscaleDomain.enable = mkEnableOption "an internal tailnet domain for ${name} at ${subdomain}.${flakeSettings.domains.tailnet}";
  ntfyChecking.enable = mkEnableOption "Ntfy sending notifications when this ${name} goes down";

  name = mkOption {
    type = types.str;
    default = name;
    description = "Set the name of the service with correct capitalisation if necessary for other modules such as modules.glance to access.";
  };

  port = mkOption {
    type = types.port;
    default = port;
    description = "The port at which ${name} is hosted at.";
  };

  subdomain = mkOption {
    type = types.str;
    default = strings.toLower subdomain;
    description = "The domain at which ${name} is hosted at.";
  };

  glance.icon = mkOption {
    type = types.str;
    default = glanceIcon;
    description = "The icon for ${name} to be displayed in the Glance dashboard.";
  };
}
