{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.services.misc.horsering;
in
{
  options.modules.services.misc.horsering = lib.my.mkServerModule {
    name = "Horsering";
    autoConfiguredServiceInfra = false;
  };

  config = mkIf cfg.enable {
    modules.services.infrastructure = {
      caddy.virtualHosts."horser.ing".extraConfig = "reverse_proxy localhost:${toString cfg.port}";
      cloudflared.ingress."horser.ing" = "http://localhost:${toString cfg.port}";
    };
    modules.services.monitoring.glance.monitoredSites = singleton {
      url = "https://horser.ing";
      title = cfg.name;
      inherit (cfg.glance) icon;
    };
    systemd.services.horsering = {
      description = "a webring for horses";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${
          inputs.horsering.packages.${pkgs.system}.default
        }/bin/horsering --bind 0.0.0.0:${toString cfg.port}";
        Restart = "on-failure";
        DynamicUser = true;
      };
    };
  };
}
