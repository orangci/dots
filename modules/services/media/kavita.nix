{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) singleton mkIf;
  cfg = config.modules.services.media.kavita;
in
{
  options.modules.services.media.kavita = lib.my.mkServerModule {
    name = "Kavita";
    subdomain = "read";
  };

  config = mkIf cfg.enable {
    # so kavita can access copyparty directories
    users.users.kavita.extraGroups =
      mkIf config.modules.services.files.copyparty.enable singleton
        "copyparty";
    modules.security.sops.secrets.kavita-token.path = "/var/secrets/kavita-token";
    services.kavita = {
      enable = true;
      settings.Port = cfg.port;
      tokenKeyFile = config.modules.security.sops.secrets.kavita-token.path;
    };
    # for downloading manga
    environment.systemPackages = lib.singleton pkgs.mangal;
  };
}
