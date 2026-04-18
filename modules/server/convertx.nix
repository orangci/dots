{
  config,
  lib,
  ...
}:

let
  inherit (lib)
    mkIf
    singleton
    ;
  cfg = config.modules.server.convertx;
in
{
  options.modules.server.convertx = lib.my.mkServerModule {
    name = "ConvertX";
    subdomain = "convert";
    glanceIcon = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/convertx.png";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.convertx-env.path = "/var/secrets/convertx-env";
    systemd.tmpfiles.rules = singleton "d /var/lib/convertx 0755 root root -";

    virtualisation.oci-containers.containers.convertx = {
      image = "ghcr.io/c4illin/convertx";
      ports = singleton "127.0.0.1:${toString cfg.port}:3000";
      volumes = singleton "/var/lib/convertx:/app/data";
      environmentFiles = singleton "/var/secrets/convertx-env";
    };
  };
}
