{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.kavita;
in
{
  options.modules.server.kavita = lib.my.mkServerModule {
    name = "Kavita";
    subdomain = "read";
  };

  config = mkIf cfg.enable {
    # so kavita can access copyparty directories
    users.users.kavita.extraGroups = mkIf config.modules.server.copyparty.enable [ "copyparty" ];
    modules.common.sops.secrets.kavita-token.path = "/var/secrets/kavita-token";
    services.kavita = {
      enable = true;
      settings.Port = cfg.port;
      tokenKeyFile = config.modules.common.sops.secrets.kavita-token.path;
    };
    # for downloading manga
    environment.systemPackages = lib.singleton pkgs.mangal;
  };
}
