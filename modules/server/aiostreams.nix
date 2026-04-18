{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    singleton
    ;
  cfg = config.modules.server.aiostreams;
  envFile = pkgs.writeText "aiostreams.env" ''
    # BASE_URL=https://${cfg.subdomain}
    BASE_URL=https://aiostreams.cormorant-emperor.ts.ne
    ADDON_ID=${cfg.subdomain}
    LOG_TIMEZONE=${config.time.timeZone}
  '';
in
{
  options.modules.server.aiostreams = lib.my.mkServerModule { name = "AIOStreams"; };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.aiostreams-secret-env.path = "/var/secrets/aiostreams-secret-env";
    systemd.tmpfiles.rules = singleton "d /var/lib/aiostreams 0755 root root -";
    virtualisation.oci-containers.containers.aiostreams = {
      image = "ghcr.io/viren070/aiostreams:latest";
      ports = singleton "${toString cfg.port}:3000";
      volumes = singleton "/var/lib/aiostreams:/app/data";
      environmentFiles = [
        config.modules.common.sops.secrets.aiostreams-secret-env.path
        envFile
      ];
    };
  };
}
