{
  config,
  lib,
  inputs,
  sysadmin,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.services.productivity.buzz-agenda;
  agenda = config.services.buzz-agenda;
  hostname = "${cfg.subdomain}.${flakeSettings.domains.tailnet}";
in
{
  imports = lib.singleton inputs.buzz-agenda.nixosModules.default;

  options.modules.services.productivity.buzz-agenda = {
    enable = mkEnableOption "the daily school agenda, served on the tailnet only";
    subdomain = mkOption {
      type = types.str;
      default = "school";
      description = "Subdomain of the tailnet domain to serve the reports on. There is deliberately no public domain or Cloudflare tunnel for this: it holds grades.";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.modules.services.infrastructure.caddy.enable
          && config.modules.services.infrastructure.tailscale.enable;
        message = "modules.services.productivity.buzz-agenda needs Caddy and Tailscale enabled.";
      }
    ];

    modules.security.sops.secrets.buzz-agenda-env.path = "/var/secrets/buzz-agenda-env";

    services.buzz-agenda = {
      enable = true;
      credentialsFile = config.modules.security.sops.secrets.buzz-agenda-env.path;
    };

    # caddy serves the files, and the sysadmin can read them over ssh
    users.users = {
      caddy.extraGroups = lib.singleton agenda.group;
      ${sysadmin.username}.extraGroups = lib.singleton agenda.group;
    };

    modules.services.infrastructure.caddy.virtualHosts."https://${hostname}".extraConfig = ''
      bind tailscale/${cfg.subdomain}
      tls {
        get_certificate tailscale
      }
      root * ${agenda.outputDir}
      file_server browse
    '';
  };
}
