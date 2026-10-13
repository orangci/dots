{ lib, flakeSettings }:

{
  name ? null,
  port ? 8800,
  subdomain ? name,
  glanceIcon ? "sh:${lib.strings.replaceStrings [ " " ] [ "-" ] (lib.strings.toLower name)}",
  autoConfiguredServiceInfra ? true,
}:

with lib;

{
  enable = mkEnableOption name;

  glance.enable = mkEnableOption "visibility for ${name} in the Glance dashboard";
  cloudflared.enable = mkEnableOption "Cloudflare Tunnelling for ${name}";
  internalTailscaleDomain.enable = mkEnableOption "an internal tailnet domain for ${name} at ${subdomain}.${flakeSettings.domains.tailnet}";
  ntfyChecking.enable = mkEnableOption "Ntfy sending notifications when this ${name} goes down";

  autoConfiguredServiceInfra = mkOption {
    type = types.bool;
    default = autoConfiguredServiceInfra;
    description = "Whether Caddy, Tailscale, Cloudflared and Glance configure this service automatically from the options of this module. Turn it off for services that need custom routing, and set up the infrastructure yourself.";
  };

  name = mkOption {
    type = types.str;
    default = name;
    example = "Immich";
    description = "The display name of ${name}, with the capitalisation it should be shown with. Glance and the ntfy checker read this.";
  };

  port = mkOption {
    type = types.port;
    default = port;
    example = 8800;
    description = "The local port ${name} listens on. Caddy, Cloudflared and Tailscale proxy to it.";
  };

  subdomain = mkOption {
    type = types.str;
    default = strings.toLower subdomain;
    example = "photos";
    description = "The subdomain ${name} is served on, under each of the primary and secondary domains (and the tailnet domain, if enabled).";
  };

  glance.icon = mkOption {
    type = types.str;
    default = glanceIcon;
    example = "sh:immich";
    description = "The icon for ${name} in the Glance dashboard, as `prefix:name`. The prefix picks the icon set: `si` Simple Icons, `sh` selfh.st icons, `di` Dashboard Icons, `mdi` Material Design Icons. Put `auto-invert` in front, separated by a space, to invert the colours with the browser theme.";
  };
}
