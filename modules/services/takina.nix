{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf singleton mkEnableOption;
  cfg = config.modules.server.takina;
in
{
  imports = singleton inputs.takina.nixosModules.default;
  options.modules.server.takina = {
    enable = mkEnableOption "Takina Discord bot";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.takina-env.path = "/var/secrets/takina-env";
    services.takina = {
      enable = true;
      environmentFile = config.modules.common.sops.secrets.takina-env.path;
      config = {
        prefix = ".";
        embedColor = "#FAB387";
        libretranslateApiUrl = "http://localhost:${toString config.modules.server.libretranslate.port}";
      };
    };
  };
}
